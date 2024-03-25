;Header and description

(define (domain travelling-salesman)

    ;remove requirements that are not needed
    (:requirements :typing :strips :non-deterministic :disjunctive-preconditions :existential-preconditions)

    (:types
        state city number item person
    )
    (:constants
        0 1 2 3 4 5 - number
    )

    (:predicates ;todo: define predicates here
        ;; number predicates
        (inc ?n1 - number ?n2 - number)
        (dec ?n1 - number ?n2 - number)

        (buying-price-state-map ?n - number ?s - state)
        (selling-price-state-map ?n - number ?s - state)
        (at ?c - city ?s - state)
        
        (connected ?c1 - city ?c2 - city)
        (same-city ?c1 - city ?c2 - city)
        (has-adjacent-cities ?c - city ?n - number)

        (money ?n - number)
        (wallet ?n - number)

        (on-city ?c - city)

        (backpack-total-space ?n - number)
        (backpack-allocated-space ?n - number)

        (volumn ?i - item ?n - number)

        (has ?i - item)
        (has-state-map ?s - state)

        (is-buyer ?p - person)
        (is-seller ?p - person)
        (stock ?i - item ?n - number ?p - person)
        (buying-price ?i - item ?n - number ?p - person)
        (selling-price ?i - item ?n - number ?p - person)
        (person-at ?p - person ?c - city)

        ;; goal condition
        (number-of-visits ?c - city ?n - number)
    )

    ;; cities belong to multiple states 
    ;define actions here
    (:action move-with-map-or-without-map-1-adjacent-city
        :parameters ( ?c1 ?c2 - city ?s - state ?visits_c2 ?inc_vists_c2 - number
        )
        :precondition (and
            (connected ?c1 ?c2)

            (or
                (and
                    (has-state-map ?s)
                    (at ?c2 ?s)
                )
                (has-adjacent-cities ?c1 1)
            )

            (at ?c1 ?s)
            (on-city ?c1)

            (inc ?visits_c2 ?inc_vists_c2)
            (number-of-visits ?c2 ?visits_c2)
        )
        :effect (and
            (not (on-city ?c1))
            (on-city ?c2)
            (not (number-of-visits ?c2 ?visits_c2))
            (number-of-visits ?c2 ?inc_vists_c2)
        )
    )
    ;; not in c1
    ;; in s1 but bot in c1
    ;; next move select a city in s1 but not c1

    ;; quntidade fixa de cidades adjacentes
    ;; ou diferentes moves com diferentes quantidades de cidades adjacentes

    (:action move-without-map-2-adjacent-cities
        :parameters ( ?c1 ?c2 ?c3 - city ?s - state ?visits_c2 ?inc_vists_c2 ?visits_c3 ?inc_vists_c3 - number
        )
        :precondition (and
            (connected ?c1 ?c2)
            (connected ?c1 ?c3)

            (on-city ?c1)
            (at ?c1 ?s)
            (not (has-state-map ?s))
            (has-adjacent-cities ?c 2)

            (not (same-city ?c2 ?c3))

            (inc ?visits_c2 ?inc_vists_c2)
            (number-of-visits ?c2 ?visits_c2)

            (inc ?visits_c3 ?inc_vists_c3)
            (number-of-visits ?c3 ?visits_c3)
        )
        :effect (and
            (oneof
                (and (not (on-city ?c1)) (on-city ?c2) (not (number-of-visits ?c2 ?visits_c2)) (number-of-visits ?c2 ?inc_vists_c2))
                (and (not (on-city ?c1)) (on-city ?c3) (not (number-of-visits ?c3 ?visits_c3)) (number-of-visits ?c3 ?inc_vists_c3))
            )
        )
    )

    (:action move-without-map-3-adjacent-cities
        :parameters ( ?c1 ?c2 ?c3 ?c4 - city ?s - state ?visits_c2 ?inc_vists_c2 ?visits_c3 ?inc_vists_c3 ?visits_c4 ?inc_vists_c4 - number
        )
        :precondition (and
            (connected ?c1 ?c2)
            (connected ?c1 ?c3)
            (connected ?c1 ?c4)

            (on-city ?c1)
            (at ?c1 ?s)
            (not (has-state-map ?s))
            (has-adjacent-cities ?c 3)

            (not (same-city ?c2 ?c3))
            (not (same-city ?c2 ?c4))
            (not (same-city ?c3 ?c4))

            (inc ?visits_c2 ?inc_vists_c2)
            (number-of-visits ?c2 ?visits_c2)

            (inc ?visits_c3 ?inc_vists_c3)
            (number-of-visits ?c3 ?visits_c3)

            (inc ?visits_c4 ?inc_vists_c4)
            (number-of-visits ?c4 ?visits_c4)
        )
        :effect (and
            (oneof
                (and (not (on-city ?c1)) (on-city ?c2) (not (number-of-visits ?c2 ?visits_c2)) (number-of-visits ?c2 ?inc_vists_c2))
                (and (not (on-city ?c1)) (on-city ?c3) (not (number-of-visits ?c3 ?visits_c3)) (number-of-visits ?c3 ?inc_vists_c3))
                (and (not (on-city ?c1)) (on-city ?c4) (not (number-of-visits ?c4 ?visits_c4)) (number-of-visits ?c4 ?inc_vists_c4))
            )
        )
    )

    (:action move-without-map-4-adjacent-cities
        :parameters ( ?c1 ?c2 ?c3 ?c4 ?c5 - city ?s - state ?visits_c2 ?inc_vists_c2 ?visits_c3 ?inc_vists_c3 ?visits_c4 ?inc_vists_c4 ?visits_c5 ?inc_vists_c5 - number
        )
        :precondition (and
            (connected ?c1 ?c2)
            (connected ?c1 ?c3)
            (connected ?c1 ?c4)
            (connected ?c1 ?c5)

            (on-city ?c1)
            (at ?c1 ?s)
            (not (has-state-map ?s))
            (has-adjacent-cities ?c 4)

            (not (same-city ?c2 ?c3))
            (not (same-city ?c2 ?c4))
            (not (same-city ?c2 ?c5))
            (not (same-city ?c3 ?c4))
            (not (same-city ?c3 ?c5))
            (not (same-city ?c4 ?c5))

            (inc ?visits_c2 ?inc_vists_c2)
            (number-of-visits ?c2 ?visits_c2)

            (inc ?visits_c3 ?inc_vists_c3)
            (number-of-visits ?c3 ?visits_c3)

            (inc ?visits_c4 ?inc_vists_c4)
            (number-of-visits ?c4 ?visits_c4)

            (inc ?visits_c5 ?inc_vists_c5)
            (number-of-visits ?c5 ?visits_c5)
        )
        :effect (and
            (oneof
                (and (not (on-city ?c1)) (on-city ?c2) (not (number-of-visits ?c2 ?visits_c2)) (number-of-visits ?c2 ?inc_vists_c2))
                (and (not (on-city ?c1)) (on-city ?c3) (not (number-of-visits ?c3 ?visits_c3)) (number-of-visits ?c3 ?inc_vists_c3))
                (and (not (on-city ?c1)) (on-city ?c4) (not (number-of-visits ?c4 ?visits_c4)) (number-of-visits ?c4 ?inc_vists_c4))
                (and (not (on-city ?c1)) (on-city ?c5) (not (number-of-visits ?c5 ?visits_c5)) (number-of-visits ?c5 ?inc_vists_c5))
            )
        )
    )

    (:action move-without-map-5-adjacent-cities
        :parameters ( ?c1 ?c2 ?c3 ?c4 ?c5 ?c6 - city ?s - state ?visits_c2 ?inc_vists_c2 ?visits_c3 ?inc_vists_c3 ?visits_c4 ?inc_vists_c4 ?visits_c5 ?inc_vists_c5 ?visits_c6 ?inc_vists_c6 - number
        )
        :precondition (and
            (connected ?c1 ?c2)
            (connected ?c1 ?c3)
            (connected ?c1 ?c4)
            (connected ?c1 ?c5)
            (connected ?c1 ?c6)

            (on-city ?c1)
            (at ?c1 ?s)
            (not (has-state-map ?s))
            (has-adjacent-cities ?c 5)

            (not (same-city ?c2 ?c3))
            (not (same-city ?c2 ?c4))
            (not (same-city ?c2 ?c5))
            (not (same-city ?c2 ?c6))
            (not (same-city ?c3 ?c4))
            (not (same-city ?c3 ?c5))
            (not (same-city ?c3 ?c6))
            (not (same-city ?c4 ?c5))
            (not (same-city ?c4 ?c6))
            (not (same-city ?c5 ?c6))

            (inc ?visits_c2 ?inc_vists_c2)
            (number-of-visits ?c2 ?visits_c2)

            (inc ?visits_c3 ?inc_vists_c3)
            (number-of-visits ?c3 ?visits_c3)

            (inc ?visits_c4 ?inc_vists_c4)
            (number-of-visits ?c4 ?visits_c4)

            (inc ?visits_c5 ?inc_vists_c5)
            (number-of-visits ?c5 ?visits_c5)
        )
        :effect (and
            (oneof
                (and (not (on-city ?c1)) (on-city ?c2) (not (number-of-visits ?c2 ?visits_c2)) (number-of-visits ?c2 ?inc_vists_c2))
                (and (not (on-city ?c1)) (on-city ?c3) (not (number-of-visits ?c3 ?visits_c3)) (number-of-visits ?c3 ?inc_vists_c3))
                (and (not (on-city ?c1)) (on-city ?c4) (not (number-of-visits ?c4 ?visits_c4)) (number-of-visits ?c4 ?inc_vists_c4))
                (and (not (on-city ?c1)) (on-city ?c5) (not (number-of-visits ?c5 ?visits_c5)) (number-of-visits ?c5 ?inc_vists_c5))
                (and (not (on-city ?c1)) (on-city ?c6) (not (number-of-visits ?c6 ?visits_c6)) (number-of-visits ?c6 ?inc_vists_c6))
            )
        )
    )

    ;; TODO: make sense to the salesman to possibly buy other item that it already has?
    (:action buy
        :parameters ( ?i - item ?item_price ?itens_on_stock ?itens_on_stock_after_sale ?item_capacity - number ?p - person ?c - city)
        :precondition (and
            (is-seller ?p)
            (buying-price ?i ?item_price ?p)
            (wallet ?item_price)

            (stock ?i ?itens_on_stock ?p)
            (dec ?itens_on_stock ?itens_on_stock_after_sale)

            (on-city ?c)
            (person-at ?p ?c)

            (volumn ?i ?item_capacity)
            (backpack-allocated-space ?item_capacity)
        )
        :effect (and
            (not (wallet ?item_price))
            (wallet 0)

            (not (stock ?i ?itens_on_stock ?p))
            (stock ?i ?itens_on_stock_after_sale ?p)

            (has ?i)

            (not (backpack-allocated-space ?item_capacity))
            (backpack-allocated-space 0)
        )
    )

    (:action sell
        :parameters ( ?i - item ?item_price ?itens_on_stock ?itens_on_stock_after_purchase ?item_capacity - number ?p - person ?c - city)
        :precondition (and
            (is-buyer ?p)
            (selling-price ?i ?item_price ?p)
            (wallet 0)

            (stock ?i ?itens_on_stock ?p)
            (inc ?itens_on_stock ?itens_on_stock_after_purchase)

            (on-city ?c)
            (person-at ?p ?c)

            (has ?i)
            (volumn ?i ?item_capacity)
            (backpack-allocated-space 0)
        )
        :effect (and
            (not (wallet 0))
            (wallet ?item_price)

            (not (stock ?i ?itens_on_stock ?p))
            (stock ?i ?itens_on_stock_after_purchase ?p)

            (not (has ?i))
            (not (backpack-allocated-space 0))
            (backpack-allocated-space ?item_capacity)
        )
    )

    (:action deallocate-backpack-space
        :parameters ( ?a1 ?a2 ?b1 ?b2 - number)
        :precondition (and
            (backpack-allocated-space ?a1)
            (dec ?a1 ?a2)

            (backpack-total-space ?b1)
            (inc ?b1 ?b2)
        )
        :effect (and
            (not (backpack-allocated-space ?a1))
            (backpack-allocated-space ?a2)

            (not (backpack-total-space ?b1))
            (backpack-total-space ?b2)
        )
    )

    (:action allocate-backpack-space
        :parameters (?a1 ?a2 ?b1 ?b2 - number)
        :precondition (and
            (backpack-allocated-space ?a1)
            (inc ?a1 ?a2)

            (backpack-total-space ?b1)
            (dec ?b1 ?b2)
        )
        :effect (and
            (not (backpack-allocated-space ?a1))
            (backpack-allocated-space ?a2)

            (not (backpack-total-space ?b1))
            (backpack-total-space ?b2)
        )
    )

    (:action buy-state-map
        :parameters (?c - city ?s - state ?map_price - number)
        :precondition (and
            (at ?c ?s)
            (not (has-state-map ?s))
            (wallet ?map_price)
            (buying-price-state-map ?map_price ?s)
        )
        :effect (and
            (has-state-map ?s)
            (not (wallet ?map_price))
            (wallet 0)
        )
    )

    (:action sell-state-map
        :parameters (?c - city ?s - state ?map_price - number)
        :precondition (and
            (at ?c ?s)
            (has-state-map ?s)
            (selling-price-state-map ?map_price ?s)
            (wallet 0)
        )
        :effect (and
            (not (has-state-map ?s))
            (not (wallet 0))
            (wallet ?map_price)
        )
    )

    (:action inc-wallet
        :parameters (?w1 ?w2 ?m1 ?m2 - number)
        :precondition (and
            (wallet ?w1)
            (money ?m1)

            (inc ?w1 ?w2)
            (dec ?m1 ?m2)
        )
        :effect (and
            (not (wallet ?w1))
            (wallet ?w2)

            (not (money ?m1))
            (money ?m2)
        )
    )

    (:action dec-wallet
        :parameters (?w1 ?w2 ?m1 ?m2 - number)
        :precondition (and
            (wallet ?w1)
            (money ?m1)

            (dec ?w1 ?w2)
            (inc ?m1 ?m2)
        )
        :effect (and
            (not (wallet ?w1))
            (wallet ?w2)

            (not (money ?m1))
            (money ?m2)
        )
    )
)