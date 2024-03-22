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
    (:requirements :strips :typing :non-deterministic :disjunctive-preconditions :existential-preconditions :universal-preconditions)
    (:types recipe ingredient costumer number - object)
    (:constants
        0 - number
    )
    (:predicates
        (inc ?op ?res - number)
        (dec ?op ?res - number)
        (finished ?isl - number)
        (on-chef-island ?ing - ingredient ?n - number ?isl - number)
        (on-recipe ?ing - ingredient ?n - number ?r - recipe)
        (not-on-recipe ?ing - ingredient ?r - recipe)
        (on-stock ?ing - ingredient ?n - number)
        (prepared ?r - recipe)
        (satisfied ?c - costumer)
        (can-accept ?c - costumer ?r - recipe)
        (num-refused-recipes ?c - costumer ?n - number)
        (num-recipes-to-refuse ?c - costumer ?n - number)
        (properly-added ?i - ingredient ?r - recipe ?isl - number)
    )


    ;; move one unit of the ingredient ing from the stock to the chef island chef-island
    (:action from-stock-to-chef-island
        :parameters (
            ?ing - ingredient
            ?iStock ?dec-iStock ?iChefIsland ?inc-iChefIsland ?chef-island - number
        )
        :precondition
        (and
            ;; check numerical precedence 
            (dec ?iStock ?dec-iStock)
            (inc ?iChefIsland ?inc-iChefIsland)

            ;; check ingredient on chef's island/ kitchen's stock
            (on-stock ?ing ?iStock)
            (on-chef-island ?ing ?iChefIsland ?chef-island)

            ;; check possibility of changing the ingredient on chef's island
            (not (finished ?chef-island))
        )
        
        :effect 
        (and
            (not (on-stock ?ing ?iStock))
            (on-stock ?ing ?dec-iStock)
            (not (on-chef-island ?ing ?iChefIsland ?chef-island))
            (on-chef-island ?ing ?inc-iChefIsland ?chef-island)
        )
    )
    ;; move one unit of the ingredient ing from the chef island chef-island to the stock
    (:action from-chef-island-to-stock
        :parameters (
            ?ing - ingredient
            ?iStock ?inc-iStock ?iChefIsland ?dec-iChefIsland ?chef-island - number
        )
        :precondition 
        (and
            (inc ?iStock ?inc-iStock)
            (dec ?iChefIsland ?dec-iChefIsland)
            (on-stock ?ing ?iStock)
            (on-chef-island ?ing ?iChefIsland ?chef-island)
            (not (finished ?chef-island))
        )
        :effect 
        (and
            (not (on-stock ?ing ?iStock))
            (on-stock ?ing ?inc-iStock)
            (not (on-chef-island ?ing ?iChefIsland ?chef-island))
            (on-chef-island ?ing ?dec-iChefIsland ?chef-island)
        )
        
    )

    (:action select-recipe
        :parameters (?r - recipe ?chef-island - number)
        :precondition 
        (and
            ;; the chef island chef-island contains the exaclty quantity of ingredient the recipe r requires
            (not (finished ?chef-island))
            (forall (?ing - ingredient)
                ;; if is on recipe, then must also be on chef island
                ;; on-recipe -> on-chef-island <=> ((on-recipe ^ on-chef-island) v ~on-recipe)
                (properly-added ?ing ?r ?chef-island)
            )            
        )
        :effect 
        (and
            (prepared ?r)
            (finished ?chef-island)
        )
    )    
    (:action on-recipe-add-to-recipe
        :parameters (?ing - ingredient ?r - recipe ?chef_island ?n - number)
        :precondition 
        (and 
            (on-recipe ?ing ?n ?r)
            (on-chef-island ?ing ?n ?chef_island)
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
        :precondition (and (not-on-recipe ?ing ?r))
        :effect (and (properly-added ?ing ?r ?chef_island))
    )
    
    
    (:action offer-not-refusable
        :parameters (
            ?c - costumer 
            ?r - recipe
            ?refused-recipes - number
        )
        :precondition 
        (and
            (num-refused-recipes ?c ?refused-recipes)
            (num-recipes-to-refuse ?c ?max)

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
            ?refused-recipes ?next - number
        )
        :precondition 
        (and
            ;; number of refused recipes by the client does not exceed its limit
            (num-refused-recipes ?c ?refused-recipes)
            (not (num-recipes-to-refuse ?c ?refused-recipes))
            (inc ?refused-recipes ?next)

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
                    (not (num-refused-recipes ?c ?refused-recipes))
                    (num-refused-recipes ?c ?next)
                )
            )
        )
    )
)