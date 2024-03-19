(define
    (domain kitchen)
    (:requirements :strips :typing :non-deterministic :disjunctive-preconditions :existential-preconditions :universal-preconditions)
    (:types 
        recipe ingredient costumer number - object
    )
    (:predicates
        (inc ?op ?res - number)
        (dec ?op ?res - number)

        (on-chef-island ?i - ingredient ?n - number)
        (on-recipe ?i - ingredient ?n - number ?r - recipe)
        (on-stock ?i - ingredient ?n - number)

        (prepared ?r - recipe)
        (satisfied ?c - costumer)

        (can-accept ?c - costumer ?r - recipe)
        (num-refused-recipes ?c - costumer ?n - number)
        (num-recipes-to-refuse ?c - costumer ?n - number)
        
        (properly-added ?i - ingredient ?r - recipe)
        
        (consumed ?r - recipe)
        (thrashed ?r - recipe)
    )


    ;; move one unit of the ingredient i from the stock to the chef island chef-island
    (:action from-stock-to-chef-island
        :parameters (
            ?i - ingredient
            ?iStock ?dec-iStock ?iIsland ?inc-iIsland - number
        )
        :precondition
        (and
            (forall (?any-recipe - recipe)
                (not (prepared ?any-recipe))
            )

            ;; check numerical precedence 
            (dec ?iStock ?dec-iStock)
            (inc ?iIsland ?inc-iIsland)

            ;; check ingredient on chef's island/ kitchen's stock
            (on-stock ?i ?iStock)
            (on-chef-island ?i ?iIsland)
        )
        
        :effect 
        (and
            ;; negate previous quantities
            (not (on-stock ?i ?iStock))
            (not (on-chef-island ?i ?iIsland))
            
            ;; move ingredient from stock to chef island 
            (on-stock ?i ?dec-iStock)
            (on-chef-island ?i ?inc-iIsland)
        )
    )
    ;; move one unit of the ingredient i from the chef island chef-island to the stock
    (:action from-chef-island-to-stock
        :parameters (
            ?i - ingredient
            ?iStock ?inc-iStock ?iIsland ?dec-iIsland - number
        )
        :precondition 
        (and
            (forall (?any-recipe - recipe)
                (not (prepared ?any-recipe))
            )
            ;; check numerical precedence 
            (inc ?iStock ?inc-iStock)
            (dec ?iIsland ?dec-iIsland)

            ;; check ingredient on chef's island/ kitchen's stock
            (on-stock ?i ?iStock)
            (on-chef-island ?i ?iIsland)
        )
        :effect 
        (and
            ;; negate previous quantities
            (not (on-stock ?i ?iStock))
            (not (on-chef-island ?i ?iIsland))
            
            ;; move ingredient from chef island to stock
            (on-stock ?i ?inc-iStock)
            (on-chef-island ?i ?dec-iIsland)
        )
        
    )
    (:action select-ingredient-that-is-on-recipe
        :parameters (?i - ingredient ?n - number ?r - recipe)
        :precondition 
        (and
            (on-recipe ?i ?n ?r)
            (on-chef-island ?i ?n)
        )
        :effect
        (and
            (not (on-chef-island ?i ?n))
            (properly-added ?i ?r)
            
            ;; (on-chef-island ?i 0)
        )
    )
    (:action select-ingredient-that-is-not-on-recipe
        :parameters (?i - ingredient ?r - recipe)
        :precondition 
        (and
            (not 
                (exists (?n - number)
                    (on-recipe ?i ?n ?r)
                )
            )
            ;; (on-chef-island ?i 0)
        )
        :effect
        (and
            (properly-added ?i ?r)
        )
    )
    (:action select-recipe
        :parameters (?r - recipe)
        :precondition 
        (and
            (forall (?any-recipe - recipe)
                (not (prepared ?any-recipe))
            )
            (forall (?i - ingredient)
                (properly-added ?i ?r)
            )            
        )
        :effect 
        (and
            (prepared ?r)
        )
    )    
    (:action offer-not-refusable
        :parameters (
            ?c - costumer 
            ?r - recipe
            ?refused-recipes - number
        )
        :precondition 
        (and
            ;; number of refused recipes reached max
            (num-refused-recipes ?c ?refused-recipes)
            (num-recipes-to-refuse ?c ?refused-recipes)
        
            (can-accept ?c ?r)
            (not (satisfied ?c))

            (prepared ?r)
            (not (thrashed ?r))
            (not (consumed ?r))
        )
        :effect 
        (and
            (consumed ?r)
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

            (can-accept ?c ?r)
            (not (satisfied ?c))

            (prepared ?r)
            (not (thrashed ?r))
            (not (consumed ?r))
        )
        :effect             
        (and
            ;; either way, the recipe cannot be accepted by the client anymore
            (not (can-accept ?c ?r)) 
            (oneof
                ;; consumes the recipe normally -> the recipe is consumed and the client is satisfied
                (and 
                    (consumed ?r)
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
    (:action throw-into-trash
        :parameters (?r - recipe)
        :precondition 
        (and 
            (prepared ?r)
            (not (thrashed ?r))
            (not (consumed ?r))
        )
        :effect (and (thrashed ?r))
    )
    (:action remove-properly-added-mark
        :parameters (?i - ingredient ?r - recipe)
        :precondition 
        (and
            (or
                (thrashed ?r)
                (consumed ?r)
            )
            (properly-added ?i ?r)
        )
        :effect (and (not (properly-added ?i ?r)))
    )
    ;; recipe reached an end (being consumed by one costumer or being refused by all of them)
    ;; now the chef can prepare a new recipe,
    ;; but first they need to remove the mark of each ingredient,
    ;; so that they can add them into the new recipe.
    (:action remove-prepared-mark
        :parameters (?r - recipe)
        :precondition
        (and
            (forall (?i - ingredient)
                (not (properly-added ?i ?r))
            )
        )
        :effect 
        (and 
            (not (prepared ?r))
            (not (thrashed ?r))
            (not (consumed ?r))
        )
    )

)