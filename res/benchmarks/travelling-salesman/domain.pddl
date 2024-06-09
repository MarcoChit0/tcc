;Header and description

(define (domain travelling-salesman)

    ;remove requirements that are not needed
    (:requirements :typing :strips :non-deterministic :disjunctive-preconditions :existential-preconditions :equality)

    (:types
        state city number item person
    )
    (:constants
        0 1 2 3 4 5 - number
    )

    (:predicates
        (inc ?n1 ?n2 - number)
        (dec ?n1 ?n2 - number)

        (buying-price-state-map ?n - number ?s - state)
        (selling-price-state-map ?n - number ?s - state)
        (at ?c - city ?s - state)
        
        (connected ?c1 ?c2 - city)
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
        (is-selling ?p - person ?i - item)
        (is-buying ?p - person ?i - item)

        (buying-price ?i - item ?n - number)
        (selling-price ?i - item ?n - number)
        (person-at ?p - person ?c - city)

        (visiting ?c - city)
        (visited-once ?c - city)
        (visited-more-than-once ?c - city)
    )

    ;; cities belong to multiple states 
    ;define actions here
    (:action move-with-map-inside-state
        :parameters (?c1 ?c2 - city ?s - state)
        :precondition (and
            (at ?c1 ?s)
            (at ?c2 ?s)

            (on-city ?c1)
            (not (visiting ?c1))

            (connected ?c1 ?c2)
            (has-state-map ?s)
        )
        :effect (and
            (not (on-city ?c1))
            (on-city ?c2)
            (visiting ?c2)
        )
    )

    (:action move-without-map-1-adjacent-cities
        :parameters (?c1 ?c2 - city)
        :precondition (and
            (on-city ?c1)
            (not (visiting ?c1))

            (connected ?c1 ?c2)
            (has-adjacent-cities ?c1 1)
        )
        :effect (and
            (not (on-city ?c1))
            (on-city ?c2)
            (visiting ?c2)
        )
    )
    ;; not in c1
    ;; in s1 but bot in c1
    ;; next move select a city in s1 but not c1

    ;; quntidade fixa de cidades adjacentes
    ;; ou diferentes moves com diferentes quantidades de cidades adjacentes

    (:action move-without-map-2-adjacent-cities
        :parameters (?c1 ?c2 ?c3 - city)
        :precondition (and
            (connected ?c1 ?c2)
            (connected ?c1 ?c3)

            (on-city ?c1)
            (not (visiting ?c1))
            (has-adjacent-cities ?c1 2)

            (not (= ?c2 ?c3))
        )
        :effect (and
            (oneof
                (and (not (on-city ?c1)) (on-city ?c2) (visiting ?c2))
                (and (not (on-city ?c1)) (on-city ?c3) (visiting ?c3))
            )
        )
    )
    (:action move-without-map-3-adjacent-cities
        :parameters (?c1 ?c2 ?c3 ?c4 - city)
        :precondition (and 
            (connected ?c1 ?c2)
            (connected ?c1 ?c3)
            (connected ?c1 ?c4)

            (on-city ?c1)
            (not (visiting ?c1))
            (has-adjacent-cities ?c1 3)

            (not (= ?c2 ?c3))
            (not (= ?c2 ?c4))
            (not (= ?c3 ?c4))
        )
        :effect (and 
            (oneof
                (and (not (on-city ?c1)) (on-city ?c2) (visiting ?c2))
                (and (not (on-city ?c1)) (on-city ?c3) (visiting ?c3))
                (and (not (on-city ?c1)) (on-city ?c4) (visiting ?c4))
            )
        )
    )
    
    (:action move-without-map-4-adjacent-cities
        :parameters (?c1 ?c2 ?c3 ?c4 ?c5 - city)
        :precondition (and 
            (connected ?c1 ?c2)
            (connected ?c1 ?c3)
            (connected ?c1 ?c4)
            (connected ?c1 ?c5)

            (on-city ?c1)
            (not (visiting ?c1))
            (has-adjacent-cities ?c1 4)

            (not (= ?c2 ?c3))
            (not (= ?c2 ?c4))
            (not (= ?c2 ?c5))
            (not (= ?c3 ?c4))
            (not (= ?c3 ?c5))
            (not (= ?c4 ?c5))
        )
        :effect (and 
            (oneof
                (and (not (on-city ?c1)) (on-city ?c2) (visiting ?c2))
                (and (not (on-city ?c1)) (on-city ?c3) (visiting ?c3))
                (and (not (on-city ?c1)) (on-city ?c4) (visiting ?c4))
                (and (not (on-city ?c1)) (on-city ?c5) (visiting ?c5))
            )
        )
    )

    (:action move-without-map-5-adjacent-cities
        :parameters (?c1 ?c2 ?c3 ?c4 ?c5 ?c6 - city)
        :precondition (and 
            (connected ?c1 ?c2)
            (connected ?c1 ?c3)
            (connected ?c1 ?c4)
            (connected ?c1 ?c5)
            (connected ?c1 ?c6)

            (on-city ?c1)
            (not (visiting ?c1))
            (has-adjacent-cities ?c1 5)

            (not (= ?c2 ?c3))
            (not (= ?c2 ?c4))
            (not (= ?c2 ?c5))
            (not (= ?c2 ?c6))
            (not (= ?c3 ?c4))
            (not (= ?c3 ?c5))
            (not (= ?c3 ?c6))
            (not (= ?c4 ?c5))
            (not (= ?c4 ?c6))
            (not (= ?c5 ?c6))
        )
        :effect (and 
            (oneof
                (and (not (on-city ?c1)) (on-city ?c2) (visiting ?c2))
                (and (not (on-city ?c1)) (on-city ?c3) (visiting ?c3))
                (and (not (on-city ?c1)) (on-city ?c4) (visiting ?c4))
                (and (not (on-city ?c1)) (on-city ?c5) (visiting ?c5))
                (and (not (on-city ?c1)) (on-city ?c6) (visiting ?c6))
            )
        )
    )
    
    

    (:action visit-city-first-visit
        :parameters (?c - city)
        :precondition (and 
            (visiting ?c)
            (on-city ?c)
            (not (visited-once ?c))
            (not (visited-more-than-once ?c))
        )
        :effect (and 
            (not (visiting ?c))
            (visited-once ?c)
        )
    )
    (:action visit-city-visited-again
        :parameters (?c - city)
        :precondition (and 
            (visiting ?c)
            (on-city ?c)
            (visited-once ?c)
            (not (visited-more-than-once ?c))
        )
        :effect (and 
            (not (visiting ?c))
            (not (visited-once ?c))
            (visited-more-than-once ?c)
        )
    )
    
    (:action visit-city-multiple-visits
        :parameters (?c - city)
        :precondition (and 
            (on-city ?c)
            (visiting ?c)
            (not (visited-once ?c))
            (visited-more-than-once ?c)
        )
        :effect (and 
            (not (visiting ?c))
        )
    )
    
    

    ;; TODO: make sense to the salesman to possibly buy other item that it already has?
    (:action seller-sells-item-to-travelling-salesman
        :parameters (?i - item ?price ?capacity - number ?p - person ?c - city)
        :precondition (and
            (not (visiting ?c))
            (on-city ?c)
            
            (is-seller ?p)
            (buying-price ?i ?price)
            (is-selling ?p ?i)
            (person-at ?p ?c)

            (wallet ?price)
            (volumn ?i ?capacity)
            (backpack-allocated-space ?capacity)
        )
        :effect (and
            (not (wallet ?price))
            (wallet 0)

            (has ?i)

            (not (backpack-allocated-space ?capacity))
            (backpack-allocated-space 0)
        )
    )

    (:action buyer-buys-item-from-travelling-salesman
        :parameters (?i - item ?price ?capacity - number ?p - person ?c - city)
        :precondition (and
            (not (visiting ?c))
            (on-city ?c)

            (is-buyer ?p)
            (selling-price ?i ?price)
            (is-buying ?p ?i)
            (person-at ?p ?c)

            (wallet 0)
            (has ?i)
            (volumn ?i ?capacity)
            (backpack-allocated-space 0)
        )
        :effect (and
            (not (wallet 0))
            (wallet ?price)

            (not (has ?i))
            (not (backpack-allocated-space 0))
            (backpack-allocated-space ?capacity)
        )
    )

    (:action deallocate-backpack-space
        :parameters (?a1 ?a2 ?b1 ?b2 - number ?c - city)
        :precondition (and
            (not (visiting ?c))
            (on-city ?c)

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
        :parameters (?a1 ?a2 ?b1 ?b2 - number ?c - city)
        :precondition (and
            (not (visiting ?c))
            (on-city ?c)

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
        :parameters (?s - state ?price - number ?c - city)
        :precondition (and
            (not (visiting ?c))
            (on-city ?c)

            (not (has-state-map ?s))
            (wallet ?price)
            (buying-price-state-map ?price ?s)
        )
        :effect (and
            (has-state-map ?s)
            (not (wallet ?price))
            (wallet 0)
        )
    )

    (:action sell-state-map
        :parameters (?s - state ?price - number ?c - city)
        :precondition (and
            (not (visiting ?c))
            (on-city ?c)

            (has-state-map ?s)
            (selling-price-state-map ?price ?s)
            (wallet 0)
        )
        :effect (and
            (not (has-state-map ?s))
            (not (wallet 0))
            (wallet ?price)
        )
    )

    (:action inc-wallet
        :parameters (?w1 ?w2 ?m1 ?m2 - number ?c - city)
        :precondition (and
            (not (visiting ?c))
            (on-city ?c)

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
        :parameters (?w1 ?w2 ?m1 ?m2 - number ?c - city)
        :precondition (and
            (not (visiting ?c))
            (on-city ?c)

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