;; Disclaimer:
;; The introduction of multiple numbered islands as areas where chefs organize their ingredients addresses a specific limitation in our PDDL translator. 
;; Originally, our translator struggled with processing 'forall' statements in effects, which made it impossible to accurately track which ingredients had been used in a recipe. 
;; To circumvent this issue, we devised the concept of islands. 
;; Once a recipe is completed, the corresponding island is "closed," rendering the ingredients placed on it inaccessible for further use.
;; As a direct consequence of this approach, it's necessary to specify the number of available islands in the instance file, ensuring that the chef has sufficient space to prepare dishes. 
;; This solution, while not ideal, provided a practical workaround to the translator's limitations.
;; Please note that this methodology introduces a requirement to manage island availability within the instance files, which may impact how you plan and execute your cooking simulations.
(define
    (domain kitchen)
    (:requirements :strips :typing :non-deterministic :disjunctive-preconditions :existential-preconditions :universal-preconditions :equality)
    (:types recipe ingredient costumer number - object)
    (:constants
        0 - number
    )
    (:predicates
        (next ?n1 ?n2 - number)
        (finished ?isl - number)
        (on-chef-island ?ing - ingredient ?n - number ?isl - number)
        (on-recipe ?ing - ingredient ?n - number ?r - recipe)
        (not-on-recipe ?ing - ingredient ?r - recipe)
        (on-stock ?ing - ingredient ?n - number)
        (prepared ?r - recipe)
        (satisfied ?c - costumer)
        (can-accept ?c - costumer ?r - recipe)
        (num-recipes-to-refuse ?c - costumer ?n - number)
        (properly-added ?i - ingredient ?r - recipe ?isl - number)
        (can-use-chef-island ?isl - number)
    )

    (:action select-chef-island
        :parameters (?chef_island - number)
        :precondition (and 
            (not (finished ?chef_island))
            (or
                ;; first island
                (= ?chef_island 0) 
                ;; ended work on previous island
                (and
                    (exists (?island - number) 
                        (and
                            (next ?island ?chef_island)
                            (finished ?island)
                        )
                    )
                )
            )
        )
        :effect (and (can-use-chef-island ?chef_island))
    )
    

    ;; move one unit of the ingredient ing from the stock to the chef island chef-island
    (:action from-stock-to-chef-island
        :parameters (
            ?ing - ingredient
            ?iStock ?dec_iStock ?iChefIsland ?inc_iChefIsland ?chef_island - number
        )
        :precondition
        (and
            ;; check numerical precedence 
            (next ?dec_iStock ?iStock)
            (next ?iChefIsland ?inc_iChefIsland)
            
            ;; check ingredient on chef's island/ kitchen's stock
            (on-stock ?ing ?iStock)
            (on-chef-island ?ing ?iChefIsland ?chef_island)

            ;; check possibility of changing the ingredient on chef's island
            (not (finished ?chef_island))
            (can-use-chef-island ?chef_island)
        )
        
        :effect 
        (and
            (not (on-stock ?ing ?iStock))
            (on-stock ?ing ?dec_iStock)
            (not (on-chef-island ?ing ?iChefIsland ?chef_island))
            (on-chef-island ?ing ?inc_iChefIsland ?chef_island)
        )
    )
    ;; move one unit of the ingredient ing from the chef island chef_island to the stock
    (:action from-chef_island-to-stock
        :parameters (
            ?ing - ingredient
            ?iStock ?inc_iStock ?iChefIsland ?dec_iChefIsland ?chef_island - number
        )
        :precondition 
        (and
            (next ?iStock ?inc_iStock)
            (next ?dec_iChefIsland ?iChefIsland)        

            (on-stock ?ing ?iStock)
            (on-chef-island ?ing ?iChefIsland ?chef_island)
            
            (not (finished ?chef_island))
            (can-use-chef-island ?chef_island)    
        )
        :effect 
        (and
            (not (on-stock ?ing ?iStock))
            (on-stock ?ing ?inc_iStock)
            (not (on-chef-island ?ing ?iChefIsland ?chef_island))
            (on-chef-island ?ing ?dec_iChefIsland ?chef_island)
        )
        
    )

    (:action select-recipe
        :parameters (?r - recipe ?chef_island - number)
        :precondition 
        (and
            ;; the chef island chef_island contains the exaclty quantity of ingredient the recipe r requires
            (not (finished ?chef_island))
            (can-use-chef-island ?chef_island)
            (forall (?ing - ingredient)
                ;; if is on recipe, then must also be on chef island
                ;; on-recipe -> on-chef-island <=> ((on-recipe ^ on-chef-island) v ~on-recipe)
                (properly-added ?ing ?r ?chef_island)
            )            
        )
        :effect 
        (and
            (prepared ?r)
            (finished ?chef_island)
            (not (can-use-chef-island ?chef_island))
        )
    )    
    (:action on-recipe-add-to-recipe
        :parameters (?ing - ingredient ?r - recipe ?chef_island ?n - number)
        :precondition 
        (and 
            (on-recipe ?ing ?n ?r)
            (on-chef-island ?ing ?n ?chef_island)

            (can-use-chef-island ?chef_island)
            (not (finished ?chef_island))
        )
        :effect 
        (and 
            (properly-added ?ing ?r ?chef_island)
            (not (on-chef-island ?ing ?n ?chef_island))
            (on-chef-island ?ing 0 ?chef_island)
        )
    )
    (:action not-on-recipe-add-to-recipe
        :parameters (?ing - ingredient ?r - recipe ?chef_island - number)
        :precondition (and (not-on-recipe ?ing ?r) (can-use-chef-island ?chef_island) (not (finished ?chef_island)))
        :effect (and (properly-added ?ing ?r ?chef_island))
    )
    
    
    (:action offer-not-refusable
        :parameters (
            ?c - costumer 
            ?r - recipe
        )
        :precondition 
        (and
            (num-recipes-to-refuse ?c 0)

            (prepared ?r)
            (can-accept ?c ?r)
            (not (satisfied ?c))
        )
        :effect 
        (and
            (not (prepared ?r))
            (not (can-accept ?c ?r))
            (satisfied ?c)
        )
    )
    (:action offer-refusable
        :parameters (
            ?c - costumer 
            ?r - recipe
            ?refused_recipes ?one_less_recipe_to_refuse - number
        )
        :precondition 
        (and
            ;; number of refused recipes by the client does not exceed its limit
            (num-recipes-to-refuse ?c ?refused_recipes)
            (next ?one_less_recipe_to_refuse ?refused_recipes)

            (prepared ?r)
            (can-accept ?c ?r)
            (not (satisfied ?c))
        )
        :effect             
        (and
            ;; either way, the recipe cannot be accepted by the client anymore
            (not (can-accept ?c ?r)) 
            (oneof
                ;; consumes the recipe normally -> the recipe is consumed and the client is satisfied
                (and 
                    (not (prepared ?r))
                    (satisfied ?c)
                )
                ;; refuses the recipe -> increment the counter of refused recipes
                (and 
                    (not (num-recipes-to-refuse ?c ?refused_recipes))
                    (num-recipes-to-refuse ?c ?one_less_recipe_to_refuse)
                )
            )
        )
    )
)