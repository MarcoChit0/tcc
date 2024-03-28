(define (domain rescue)
    (:requirements :typing :equality :negative-preconditions :disjunctive-preconditions :universal-preconditions :conditional-effects :existential-preconditions :non-deterministic)
    (:types
        location victim fire-unit medical-unit number - object
    )
    (:predicates
        ;; -- when porcessing clock --
        (clock ?t - number)
        (adjusted-clock)

        (is-greater-or-equal ?n1 ?n2 - number) ;; n1 >= n2 -> true, else false
        (inc ?op ?res - number)
        ;; ---------------------------
        ;; -- when porcessing location --
        (fire-at ?l - location)
        (water-at ?l - location)
        (hospital-at ?l - location)

        (victim-at ?v - victim ?l - location)
        (fire-unit-at ?u - fire-unit ?l - location)
        (medical-unit-at ?u - medical-unit ?l - location)

        (adjacent ?l1 ?l2 - location)

        (spreading-time ?t - number ?l - location)
        ;; ------------------------------
        ;; -- when porcessing victim --
        (healthy ?v - victim)
        (hurt ?v - victim)
        (dying ?v - victim)
        (deceased ?v - victim)
        ;; ----------------------------
        ;; -- do not appear on instance json --
        (spread-out ?t - number ?l - location)
        (adjusted-status ?t - number ?v - victim)
        (need-to-adjust-clock)
        (have-water ?u - fire-unit)
        (have-victim-in-unit ?v - victim ?u - medical-unit)
        (on-hospital ?v - victim)
        ;; ------------------------------------
    )

    (:action drive-fire-unit
        :parameters (?u - fire-unit ?from - location ?to - location)
        :precondition (and
            (fire-unit-at ?u ?from)
            (adjacent ?to ?from)
            (not (fire-at ?to))

            (adjusted-clock)
        )
        :effect (and
            (fire-unit-at ?u ?to)
            (not (fire-unit-at ?u ?from))

            (need-to-adjust-clock)
            (not (adjusted-clock))
        )
    )

    (:action drive-medical-unit
        :parameters (?u - medical-unit ?from - location ?to - location)
        :precondition (and
            (medical-unit-at ?u ?from)
            (adjacent ?to ?from)
            (not (fire-at ?to))

            (adjusted-clock)
        )
        :effect (and
            (medical-unit-at ?u ?to)
            (not (medical-unit-at ?u ?from))

            (need-to-adjust-clock)
            (not (adjusted-clock))
        )
    )

    (:action load-fire-unit
        :parameters (?u - fire-unit ?l - location)
        :precondition (and
            (fire-unit-at ?u ?l)
            (water-at ?l)

            (adjusted-clock)
        )
        :effect (and
            (have-water ?u)

            (need-to-adjust-clock)
            (not (adjusted-clock))
        )
    )

    (:action load-medical-unit
        :parameters (?u - medical-unit ?l - location ?v - victim)
        :precondition (and
            (medical-unit-at ?u ?l)
            (victim-at ?v ?l)

            (adjusted-clock)
        )
        :effect (and
            (have-victim-in-unit ?v ?u)
            (not (victim-at ?v ?l))

            (need-to-adjust-clock)
            (not (adjusted-clock))
        )
    )

    (:action unload-fire-unit
        :parameters (?u - fire-unit ?l ?l1 - location)
        :precondition (and
            (fire-unit-at ?u ?l)
            (have-water ?u)

            (adjacent ?l ?l1)
            (fire-at ?l1)

            (adjusted-clock)
        )
        :effect (and
            (not (have-water ?u))
            (not (fire-at ?l1))

            (need-to-adjust-clock)
            (not (adjusted-clock))
        )
    )

    (:action unload-medical-unit
        :parameters (?u - medical-unit ?l - location ?v - victim)
        :precondition (and
            (medical-unit-at ?u ?l)
            (have-victim-in-unit ?v ?u)

            (adjusted-clock)
        )
        :effect (and
            (victim-at ?v ?l)
            (not (have-victim-in-unit ?v ?u))

            (need-to-adjust-clock)
            (not (adjusted-clock))
        )
    )
    (:action adjust-status-helthy-to-hurt
        :parameters (?l - location ?v - victim ?t ?next_t - number)
        :precondition (and 
            (clock ?t)
            (inc ?t ?next_t)
            (need-to-adjust-clock)
            (victim-at ?v ?l)
            (fire-at ?l)
            (healthy ?v)
            (not (on-hospital ?v))
            (not (adjusted-status ?next_t ?v))
        )
        :effect (and 
            (adjusted-status ?next_t ?v)
            (oneof
                (and (hurt ?v) (not (healthy ?v)))
                (and)
            )
        )
    )
    (:action adjust-status-hurt-to-dying
        :parameters (?l - location ?v - victim ?t ?next_t - number)
        :precondition (and 
            (clock ?t)
            (inc ?t ?next_t)
            (need-to-adjust-clock)
            (victim-at ?v ?l)
            (fire-at ?l)
            (hurt ?v)
            (not (on-hospital ?v))
            (not (adjusted-status ?next_t ?v))
        )
        :effect (and 
            (adjusted-status ?next_t ?v)
            (oneof
                (and (dying ?v) (not (hurt ?v)))
                (and)
            )
        )
    )
    (:action adjust-status-dying-to-deceased
        :parameters (?l - location ?v - victim ?t ?next_t - number)
        :precondition (and 
            (clock ?t)
            (inc ?t ?next_t)
            (need-to-adjust-clock)
            (victim-at ?v ?l)
            (fire-at ?l)
            (dying ?v)
            (not (on-hospital ?v))
            (not (adjusted-status ?next_t ?v))
        )
        :effect (and 
            (adjusted-status ?next_t ?v)
            (oneof
                (and (deceased ?v) (not (dying ?v)))
                (and)
            )
        )
    )
    (:action adjust-status-no-fire-at-location
        :parameters (?l - location ?v - victim ?t ?next_t - number)
        :precondition (and 
            (clock ?t)
            (inc ?t ?next_t)
            (need-to-adjust-clock)
            (not (adjusted-status ?next_t ?v))
            (or
                (exists (?m - medical-unit) 
                    (and 
                        (have-victim-in-unit ?v ?m)
                    )
                )
                (on-hospital ?v)
                (and 
                    (not (fire-at ?l))
                    (victim-at ?v ?l)
                )
            )
        )
        :effect (and 
            (adjusted-status ?next_t ?v)
        )
    )
    (:action enter-hospital
        :parameters (?v - victim ?l - location)
        :precondition (and 
            (hospital-at ?l)
            (victim-at ?v ?l)

            (adjusted-clock)
        )
        :effect (and 
            (on-hospital ?v)

            (need-to-adjust-clock)
            (not (adjusted-clock))
        )
    )
    
    
    
    (:action spread-fire-without-fire-on-location
        :parameters (?l - location ?t ?next_t ?spreading_t - number)
        :precondition (and
            (clock ?t)
            (spreading-time ?spreading_t ?l)
            (inc ?t ?next_t)
            (is-greater-or-equal ?next_t ?spreading_t)
            (need-to-adjust-clock)
            (not (fire-at ?l))
            (exists
                (?l1 - location)
                (and
                    (adjacent ?l ?l1)
                    (fire-at ?l1)
                )
            )
            (not (spread-out ?next_t ?l))
        )
        :effect (and
            (spread-out ?next_t ?l)
            (oneof
                (and)
                (fire-at ?l)
            )
        )
    )
    (:action spread-fire-with-location-on-fire
        :parameters (?l - location ?t ?next_t ?spreading_t - number)
        :precondition (and
            (clock ?t)
            (spreading-time ?spreading_t ?l)
            (inc ?t ?next_t)
            (is-greater-or-equal ?next_t ?spreading_t)
            (need-to-adjust-clock)
            (fire-at ?l)
            (not (spread-out ?next_t ?l))
        )
        :effect (and
            (spread-out ?next_t ?l)
        )
    )
    (:action not-spread-fire
        :parameters (?l - location ?t ?next_t ?spreading_t - number)
        :precondition (and
            (clock ?t)
            (inc ?t ?next_t)
            (need-to-adjust-clock)
            (spreading-time ?spreading_t ?l)
            (not (spread-out ?next_t ?l))
            (or
                (and (is-greater-or-equal ?spreading_t ?next_t) (not (= ?spreading_t ?next_t)))
                (and
                    (is-greater-or-equal ?next_t ?spreading_t)
                    ;; there is no fire in the adjacent locations
                    (forall
                        (?l1 - location)
                        (or
                            (not (adjacent ?l ?l1))
                            (and
                                (adjacent ?l ?l1)
                                (not (fire-at ?l1))
                            )
                        )
                    )
                )
            )
        )
        :effect (and
            (spread-out ?next_t ?l)
        )

    )

    (:action adjust-clock
        :parameters (?t ?next_t - number)
        :precondition (and
            (need-to-adjust-clock)
            (clock ?t)
            (inc ?t ?next_t)
            (forall
                (?l - location)
                (spread-out ?next_t ?l)
            )
            (forall
                (?v - victim)
                (adjusted-status ?next_t ?v)
            )
        )
        :effect (and
            (not (clock ?t))
            (clock ?next_t)
            (not (need-to-adjust-clock))
            (adjusted-clock)
        )
    )

    (:action treat-dying-victim-on-hospital
        :parameters (?l - location ?v - victim)
        :precondition (and
            (hospital-at ?l)
            (victim-at ?v ?l)
            (not (fire-at ?l))
            (adjusted-clock)
            (dying ?v)
            (on-hospital ?v)
        )
        :effect (and
            (need-to-adjust-clock)
            (not (adjusted-clock))
            (oneof
                (and (healthy ?v) (not (dying ?v)))
                (and (hurt ?v) (not (dying ?v)))
            )
        )
    )
    (:action treat-hurt-victim-on-hospital
        :parameters (?l - location ?v - victim)
        :precondition (and
            (hospital-at ?l)
            (victim-at ?v ?l)
            (adjusted-clock)
            (hurt ?v)
            (on-hospital ?v)
        )
        :effect (and
            (need-to-adjust-clock)
            (not (adjusted-clock))
            (healthy ?v)
            (not (hurt ?v))
        )
    )
    (:action treat-victim-on-fire-unit
        :parameters (?f - fire-unit ?v - victim ?l - location)
        :precondition (and
            (adjusted-clock)
            (fire-unit-at ?f ?l)
            (victim-at ?v ?l)
            (hurt ?v)
        )
        :effect (and
            (not (adjusted-clock))
            (need-to-adjust-clock)
            (oneof
                (and (healthy ?v) (not (hurt ?v)))
                (and)
                (and (dying ?v) (not (hurt ?v)))
            )
        )
    )
    (:action treat-victim-on-medical-unit
        :parameters (?u - medical-unit ?v - victim ?l - location)
        :precondition (and
            (adjusted-clock)
            (medical-unit-at ?u ?l)
            (or
                (have-victim-in-unit ?v ?u)
                (victim-at ?v ?l)
            )
            (hurt ?v)
        )
        :effect (and
            (not (adjusted-clock))
            (need-to-adjust-clock)
            (oneof
                (and)
                (and (healthy ?v) (not (hurt ?v)))
            )
        )
    )

)