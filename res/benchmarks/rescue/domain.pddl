(define (domain first-response)
    (:requirements :typing :equality :negative-preconditions :disjunctive-preconditions :universal-preconditions :conditional-effects :existential-preconditions :non-deterministic)
    (:types
        location victim status fire_unit medical_unit number - object
    )
    (:constants
        healthy hurt dying - status
        0 - number
    )
    (:predicates
        (clock ?t - number)
        (fire ?l - location)
        (victim-at ?v - victim ?l - location)
        (victim-status ?v - victim ?s - status)
        (hospital ?l - location)
        (water-at ?l - location)
        (adjacent ?l1 ?l2 - location)
        (fire-unit-at ?u - fire_unit ?l - location)
        (medical-unit-at ?u - medical_unit ?l - location)
        (have-water ?u - fire_unit)
        (have-victim-in-unit ?v - victim ?u - medical_unit)

        (is-succ ?n1 ?n2 - number)

        (inc ?op ?res - number)
        (spreading-time ?t - number ?l - location)
        (spread-out ?t - number ?l - location)
        (adjusted-clock)
        (need-to-adjust-clock)
    )

    (:action succ-app
        :parameters (?n1 ?n2 ?n3 - number)
        :precondition (and 
            (is-succ ?n1 ?n2)
            (is-succ ?n2 ?n3)
        )
        :effect (and 
            (is-succ ?n1 ?n3)
        )
    )

    (:action drive-fire-unit
        :parameters (?u - fire_unit ?from - location ?to - location)
        :precondition 
        (and 
            (fire-unit-at ?u ?from)
            (adjacent ?to ?from)
            (not (fire ?to))

            (adjusted-clock)
        )
        :effect 
        (and 
            (fire-unit-at ?u ?to) 
            (not (fire-unit-at ?u ?from))

            (need-to-adjust-clock)
            (not (adjusted-clock))
        )
    )

    (:action drive-medical-unit
        :parameters (?u - medical_unit ?from - location ?to - location)
        :precondition 
        (and 
            (medical-unit-at ?u ?from)
            (adjacent ?to ?from)
            (not (fire ?to))

            (adjusted-clock)
        )
        :effect 
        (and 
            (medical-unit-at ?u ?to) 
            (not (medical-unit-at ?u ?from))

            (need-to-adjust-clock)
            (not (adjusted-clock))
        )
    )

    (:action load-fire-unit
        :parameters (?u - fire_unit ?l - location)
        :precondition 
        (and 
            (fire-unit-at ?u ?l) 
            (water-at ?l)

            (adjusted-clock)
        )
        :effect 
        (and
            (have-water ?u)
        
            (need-to-adjust-clock)
            (not (adjusted-clock))
        )
    )

    (:action load-medical-unit
        :parameters (?u - medical_unit ?l - location ?v - victim)
        :precondition 
        (and 
            (medical-unit-at ?u ?l) 
            (victim-at ?v ?l)

            (adjusted-clock)
        )
        :effect 
        (and 
            (have-victim-in-unit ?v ?u)
            (not (victim-at ?v ?l))
        
            (need-to-adjust-clock)
            (not (adjusted-clock))
        )
    )

    (:action unload-fire-unit
        :parameters (?u - fire_unit ?l ?l1 - location)
        :precondition 
        (and 
            (fire-unit-at ?u ?l)
            (adjacent ?l1 ?l)
            (have-water ?u)
            (fire ?l1)

            (adjusted-clock)    
        )
        :effect 
        (and
            (not (have-water ?u))
            (not (fire ?l1))
        
            (need-to-adjust-clock)
            (not (adjusted-clock))
        )
    )

    (:action unload-medical-unit
        :parameters (?u - medical_unit ?l - location ?v - victim)
        :precondition 
        (and 
            (medical-unit-at ?u ?l)
            (have-victim-in-unit ?v ?u)
        
            (adjusted-clock)
        )
        :effect 
        (and 
            (victim-at ?v ?l) 
            (not (have-victim-in-unit ?v ?u))
        
            (need-to-adjust-clock)
            (not (adjusted-clock))
        )
    )

    (:action spread-fire
        :parameters (?l - location ?t ?next - number)
        :precondition (and 
            ;; TODO: improve this so that any time t' > t the fire could spread to that location provided that the fire is not extinguished nearby
            (inc ?t ?next)
            (clock ?t)
            (spreading-time ?next ?l)
            (need-to-adjust-clock)

        )            
        :effect 
        (and 
            ;; TODO: add the possibility of not spreading the fire
            (fire ?l)
            (spread-out ?next ?l)
        )
    )
    (:action adjust-clock
        :parameters (?t ?next - number)
        :precondition 
        (and 
            (need-to-adjust-clock)
            ;; all fire spread out
            (forall (?l - location)
                (or
                    (and
                        (spreading-time ?next ?l)
                        ;; change this... the fire unit could extinguish the fire before the next spreading time
                        (spread-out ?next ?l) 
                    )
                    (not (spreading-time ?next ?l))
                )
            )
        )
        :effect 
        (and 
            (not (clock ?t))
            (clock ?next)
            (not (need-to-adjust-clock))
            (adjusted-clock)
        )
    )
    

)