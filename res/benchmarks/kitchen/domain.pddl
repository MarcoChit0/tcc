(domain (kitchen)
    (:requirements :strips :typing :non-deterministic)
    (:types
        recipe ingredient costumer number - object
        island - number
    )
    (:predicates
        (inc ?op ?res - number)
        (dec ?op ?res - number)
        (finished ?isl - island)
        (on-chef-island ?i - ingredient ?n - number ?isl - island)
        (on-recipe ?i - ingredient ?n - number ?r - recipe)
        (on-stock ?i - ingredient ?n - number)
        (prepared ?r - recipe)
        (satisfied ?c - costumer)
    )
    (:action from-stock-to-chef-island
        :parameters (
            ?i - ingredient
            ?i-on-stock ?dec-i-on-stock ?i-on-chef-island ?inc-i-on-chef-island - number
            ?chef-island - island
        )
        :precondition (
            (and
                (dec ?i-on-stock ?dec-i-on-stock)
                (inc ?i-on-chef-island ?inc-i-on-chef-island ?chef-island)
                (on-stock ?i ?i-on-stock)
                (on-chef-island ?i ?i-on-chef-island ?chef-island)
                (not (finished ?chef-island))
            )
        )
        :effect (
            (and
                (on-stock ?i ?dec-i-on-stock)
                (on-chef-island ?i ?inc-i-on-chef-island ?chef-island)
            )
        )
    )
    (:action from-chef-island-to-stock
        :parameters (
            ?i - ingredient
            ?i-on-stock ?inc-i-on-stock ?i-on-chef-island ?dec-i-on-chef-island - number
            ?chef-island - island
        )
        :precondition (
            (and
                (inc ?i-on-stock ?inc-i-on-stock)
                (dec ?i-on-chef-island ?dec-i-on-chef-island ?chef-island)
                (on-stock ?i ?i-on-stock)
                (on-chef-island ?i ?i-on-chef-island ?chef-island)
                (not (finished ?chef-island))
            )
        )
        :effect (
            (and
                (on-stock ?i ?inc-i-on-stock)
                (on-chef-island ?i ?dec-i-on-chef-island ?chef-island)
            )
        )
    )
    (:action select-recipe
        :parameters (?r - recipe ?chef-island - island)
        :precondition (
            (and
                (not (finished ?chef-island))
                (forall (?i - ingredient)
                    (exists (?n - number)
                        (and 
                            (on-recipe ?i ?n ?r)
                            (on-chef-island ?i ?n ?chef-island)
                        )
                    )
                )            
            )

        )
        :effect (
            (and
                (prepared ?r)
                (finished ?chef-island)
            )
        )
    )    
    (:action offer
        :parameters (?r - recipe ?c -costumer)
        
        :precondition (
            (and 
                (prepared ?r)
            )
        )
        :effect (
            (and
                (satisfied ?c)
                (not (prepared ?r))
            )
        )
    )
)