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
    (:predicates
        (inc ?op ?res - number)
        (dec ?op ?res - number)
        (equal ?a ?b - number)
        (finished ?isl - number)
        (on-chef-island ?ing - ingredient ?n - number ?isl - number)
        (on-recipe ?ing - ingredient ?n - number ?r - recipe)
        (on-stock ?ing - ingredient ?n - number)
        (prepared ?r - recipe)
        (satisfied ?c - costumer)
        (can-accept ?c - costumer ?r - recipe)
        (num-refused-recipes ?c - costumer ?n - number)
        (num-recipes-to-refuse ?c - costumer ?n - number)
        (locked ?i - ingredient ?isl - number)
    )


    ;; move one unit of the ingredient ing from the stock to the chef island chef-island
    (:action from-stock-to-chef-island
        :parameters (
            ?ing - ingredient
            ?ing-on-stock ?dec-ing-on-stock ?ing-on-chef-island ?inc-ing-on-chef-island ?chef-island - number
        )
        :precondition
        (and
            (not (locked ?ing ?chef-island))
            (dec ?ing-on-stock ?dec-ing-on-stock)
            (inc ?ing-on-chef-island ?inc-ing-on-chef-island)
            (on-stock ?ing ?ing-on-stock)
            (on-chef-island ?ing ?ing-on-chef-island ?chef-island)
            (not (finished ?chef-island))
        )
        
        :effect 
        (and
            (not (on-stock ?ing ?ing-on-stock))
            (on-stock ?ing ?dec-ing-on-stock)
            (not (on-chef-island ?ing ?ing-on-chef-island ?chef-island))
            (on-chef-island ?ing ?inc-ing-on-chef-island ?chef-island)
        )
    )
    ;; move one unit of the ingredient ing from the chef island chef-island to the stock
    (:action from-chef-island-to-stock
        :parameters (
            ?ing - ingredient
            ?ing-on-stock ?inc-ing-on-stock ?ing-on-chef-island ?dec-ing-on-chef-island ?chef-island - number
        )
        :precondition 
        (and
            (not (locked ?ing ?chef-island))
            (inc ?ing-on-stock ?inc-ing-on-stock)
            (dec ?ing-on-chef-island ?dec-ing-on-chef-island)
            (on-stock ?ing ?ing-on-stock)
            (on-chef-island ?ing ?ing-on-chef-island ?chef-island)
            (not (finished ?chef-island))
        )
        :effect 
        (and
            (not (on-stock ?ing ?ing-on-stock))
            (on-stock ?ing ?inc-ing-on-stock)
            (not (on-chef-island ?ing ?ing-on-chef-island ?chef-island))
            (on-chef-island ?ing ?dec-ing-on-chef-island ?chef-island)
        )
        
    )
    (:action lock-ingredient
        :parameters (
            ?r - recipe 
            ?i - ingredient 
            ?chef-island ?n ?m - number)
        :precondition
        (and
            (not (locked ?i ?isl))
            (on-chef-island ?i ?n ?chef-island)
            (on-recipe ?i ?m ?r)
            (equal ?n ?m)
        )    
        :effect (locked ?i ?isl)
    )
    (:action select-recipe
        :parameters (?r - recipe ?chef-island - number)
        :precondition 
        (and
            ;; the chef island chef-island contains the exaclty quantity of ingredient the recipe r requires
            (not (finished ?chef-island))
            (forall (?ing - ingredient)
                (and
                    (exists (?n - number)
                        (on-recipe ?ing ?n ?r)
                    )
                    (locked ?ing ?chef-island)
                )
            )            
        )
        :effect 
        (and
            (prepared ?r)
            (finished ?chef-island)
        )
    )    
    (:action offer-not-refusable
        :parameters (
            ?c - costumer 
            ?r - recipe
            ?refused-recipes ?max - number
        )
        :precondition 
        (and
            (num-refused-recipes ?c ?refused-recipes)
            (num-recipes-to-refuse ?c ?max)
            (equal ?refused-recipes ?max)

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
            ?refused-recipes ?next ?max - number
        )
        :precondition 
        (and
            ;; number of refused recipes by the client does not exceed its limit
            (num-refused-recipes ?c ?refused-recipes)
            (num-recipes-to-refuse ?c ?max)
            (not (equal ?refused-recipes ?max))
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