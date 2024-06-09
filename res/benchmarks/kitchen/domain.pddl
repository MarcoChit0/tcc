;; Disclaimer:
;; The introduction of multiple numbered islands as areas where chefs organize their ingredients addresses a specific limitation in our PDDL translator. 
;; Originally, our translator struggled with processing 'forall' statements in effects, which made it impossible to accurately track which ingredients had been used in a recipe. 
;; To circumvent this issue, we devised the concept of islands. 
;; Once a recipe is completed, the corresponding island is "closed," rendering the ingredients placed on it inaccessible for further use.
;; As a direct consequence of this approach, it's necessary to specify the number of available islands in the instance file, ensuring that the chef has sufficient space to prepare dishes. 
;; This solution, while not ideal, provided a practical workaround to the translator's limitations.
;; Please note that this methodology introduces a requirement to manage island availability within the instance files, which may impact how you plan and execute your cooking simulations.
(define (domain kitchen)
    (:requirements :strips :typing :non-deterministic :disjunctive-preconditions :existential-preconditions :universal-preconditions :equality)
    (:types recipe ingredient costumer number)
    (:constants 0 - number)
    (:predicates
        (next ?n1 ?n2 - number)
        (finished ?isl - number)
        (on-chef-island ?i - ingredient ?n - number ?isl - number)
        (on-recipe ?i - ingredient ?n - number ?r - recipe)
        (not-on-recipe ?i - ingredient ?r - recipe)
        (on-stock ?i - ingredient ?n - number)
        (prepared ?r - recipe)
        (satisfied ?c - costumer)
        (can-accept ?c - costumer ?r - recipe)
        (num-recipes-to-refuse ?c - costumer ?n - number)
        (properly-added ?i - ingredient ?r - recipe ?isl - number)
        (can-use-chef-island ?isl - number)
    )

    (:action select-chef-island
        :parameters (?isl - number)
        :precondition (and 
            (not (finished ?isl))
            (or
                ;; first island
                (= ?isl 0) 
                ;; ended work on previous island
                (and
                    (exists (?island - number) 
                        (and
                            (next ?island ?isl)
                            (finished ?island)
                        )
                    )
                )
            )
        )
        :effect (and (can-use-chef-island ?isl))
    )
    

    ;; move one unit of the ingredient ing from the stock to the chef island chef-island
    (:action from-stock-to-chef-island
        :parameters (?i - ingredient ?on_stock ?dec_on_stock ?on_isl ?inc_on_isl ?isl - number)
        :precondition
        (and
            ;; check numerical precedence 
            (next ?dec_on_stock ?on_stock)
            (next ?on_isl ?inc_on_isl)
            
            ;; check ingredient on chef's island/ kitchen's stock
            (on-stock ?i ?on_stock)
            (on-chef-island ?i ?on_isl ?isl)

            ;; check possibility of changing the ingredient on chef's island
            (not (finished ?isl))
            (can-use-chef-island ?isl)
        )
        
        :effect 
        (and
            (not (on-stock ?i ?on_stock))
            (on-stock ?i ?dec_on_stock)
            (not (on-chef-island ?i ?on_isl ?isl))
            (on-chef-island ?i ?inc_on_isl ?isl)
        )
    )
    ;; move one unit of the ingredient ing from the chef island chef_island to the stock
    (:action from-chef-island-to-stock
        :parameters (?i - ingredient ?on_stock ?inc_on_stock ?on_isl ?dec_on_isl ?isl - number)
        :precondition 
        (and
            (next ?on_stock ?inc_on_stock)
            (next ?dec_on_isl ?on_isl)        

            (on-stock ?i ?on_stock)
            (on-chef-island ?i ?on_isl ?isl)
            
            (not (finished ?isl))
            (can-use-chef-island ?isl)    
        )
        :effect 
        (and
            (not (on-stock ?i ?on_stock))
            (on-stock ?i ?inc_on_stock)
            (not (on-chef-island ?i ?on_isl ?isl))
            (on-chef-island ?i ?dec_on_isl ?isl)
        )
        
    )

    (:action select-recipe
        :parameters (?r - recipe ?isl - number)
        :precondition 
        (and
            ;; the chef island chef_island contains the exaclty quantity of ingredient the recipe r requires
            (not (finished ?isl))
            (can-use-chef-island ?isl)
            (forall (?i - ingredient)
                ;; if is on recipe, then must also be on chef island
                ;; on-recipe -> on-chef-island <=> ((on-recipe ^ on-chef-island) v ~on-recipe)
                (properly-added ?i ?r ?isl)
            )            
        )
        :effect 
        (and
            (prepared ?r)
            (finished ?isl)
            (not (can-use-chef-island ?isl))
        )
    )    
    (:action on-recipe-add-to-recipe
        :parameters (?i - ingredient ?r - recipe ?isl ?n - number)
        :precondition 
        (and 
            (on-recipe ?i ?n ?r)
            (on-chef-island ?i ?n ?isl)

            (can-use-chef-island ?isl)
            (not (finished ?isl))
        )
        :effect 
        (and 
            (properly-added ?i ?r ?isl)
            (not (on-chef-island ?i ?n ?isl))
            (on-chef-island ?i 0 ?isl)
        )
    )
    (:action not-on-recipe-add-to-recipe
        :parameters (?i - ingredient ?r - recipe ?isl - number)
        :precondition (and (not-on-recipe ?i ?r) (can-use-chef-island ?isl) (not (finished ?isl)))
        :effect (and (properly-added ?i ?r ?isl))
    )
    
    
    (:action offer-not-refusable
        :parameters (?c - costumer ?r - recipe)
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
        :parameters (?c - costumer ?r - recipe ?refused ?dec_refused - number)
        :precondition 
        (and
            ;; number of refused recipes by the client does not exceed its limit
            (num-recipes-to-refuse ?c ?refused)
            (next ?dec_refused ?refused)

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
                    (not (num-recipes-to-refuse ?c ?refused))
                    (num-recipes-to-refuse ?c ?dec_refused)
                )
            )
        )
    )
)