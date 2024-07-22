;;; Authors: Marco Chitolina, Frederico Messa and  André Pereira ;;;


(define (domain rescue)
    (:requirements :typing :equality :negative-preconditions :disjunctive-preconditions :universal-preconditions :conditional-effects :existential-preconditions :non-deterministic)
    (:types
        location victim fire-unit medical-unit number
    )
    (:predicates
        (clock ?t - number)
        (adjusted-clock)

        (is-greater-or-equal ?n1 ?n2 - number)
        (inc ?op ?res - number)
        (fire-at ?l - location)
        (water-at ?l - location)
        (hospital-at ?l - location)

        (victim-at ?v - victim ?l - location)
        (fire-unit-at ?u - fire-unit ?l - location)
        (medical-unit-at ?u - medical-unit ?l - location)

        (adjacent ?l1 ?l2 - location)

        (spreading-time ?t - number ?l - location)
        (healthy ?v - victim)
        (hurt ?v - victim)
        (dying ?v - victim)
        (deceased ?v - victim)
        (spread-out ?t - number ?l - location)
        (adjusted-status ?t - number ?v - victim)
        (need-to-adjust-clock)
        (have-water ?u - fire-unit)
        (have-victim-in-unit ?v - victim ?u - medical-unit)
        (on-hospital ?v - victim)

        (predecessor-victim ?v1 ?v2 - victim)
        (predecessor-location ?l1 ?l2 - location)
        (all-locations-spread-out ?t - number)
        (all-victims-adjusted ?t - number)
        (first-victim ?v - victim)
        (first-location ?l - location)
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
        :parameters (?l - location ?v - victim ?t1 ?t2 - number)
        :precondition (and

            (clock ?t1)
            (inc ?t1 ?t2)
            (need-to-adjust-clock)
            (all-locations-spread-out ?t2)
            (or
                (first-victim ?v)
                (exists
                    (?v1 - victim)
                    (and (predecessor-victim ?v1 ?v) (adjusted-status ?t2 ?v1)))
            )
            (victim-at ?v ?l)
            (fire-at ?l)
            (healthy ?v)
            (not (on-hospital ?v))
            (not (adjusted-status ?t2 ?v))
        )
        :effect (and
            (adjusted-status ?t2 ?v)
            (oneof
                (and (hurt ?v) (not (healthy ?v)))
                (and)
            )
        )
    )
    (:action adjust-status-hurt-to-dying
        :parameters (?l - location ?v - victim ?t1 ?t2 - number)
        :precondition (and
            (clock ?t1)
            (inc ?t1 ?t2)
            (need-to-adjust-clock)
            (all-locations-spread-out ?t2)
            (or
                (first-victim ?v)
                (exists
                    (?v1 - victim)
                    (and (predecessor-victim ?v1 ?v) (adjusted-status ?t2 ?v1)))
            )
            (victim-at ?v ?l)
            (fire-at ?l)
            (hurt ?v)
            (not (on-hospital ?v))
            (not (adjusted-status ?t2 ?v))
        )
        :effect (and
            (adjusted-status ?t2 ?v)
            (oneof
                (and (dying ?v) (not (hurt ?v)))
                (and)
            )
        )
    )
    (:action adjust-status-dying-to-deceased
        :parameters (?l - location ?v - victim ?t1 ?t2 - number)
        :precondition (and
            (clock ?t1)
            (inc ?t1 ?t2)
            (need-to-adjust-clock)
            (all-locations-spread-out ?t2)
            (or
                (first-victim ?v)
                (exists
                    (?v1 - victim)
                    (and (predecessor-victim ?v1 ?v) (adjusted-status ?t2 ?v1)))
            )
            (victim-at ?v ?l)
            (fire-at ?l)
            (dying ?v)
            (not (on-hospital ?v))
            (not (adjusted-status ?t2 ?v))
        )
        :effect (and
            (adjusted-status ?t2 ?v)
            (oneof
                (and (deceased ?v) (not (dying ?v)))
                (and)
            )
        )
    )
    (:action adjust-status-no-fire-at-location
        :parameters (?l - location ?v - victim ?t1 ?t2 - number)
        :precondition (and
            (clock ?t1)
            (inc ?t1 ?t2)
            (need-to-adjust-clock)
            (not (adjusted-status ?t2 ?v))
            (all-locations-spread-out ?t2)
            (or
                (first-victim ?v)
                (exists
                    (?v1 - victim)
                    (and (predecessor-victim ?v1 ?v) (adjusted-status ?t2 ?v1)))
            )
            (and
                (not (fire-at ?l))
                (victim-at ?v ?l)
            )
        )
        :effect (and
            (adjusted-status ?t2 ?v)
        )
    )
    (:action adjust-status-victim-on-hospital
        :parameters (?v - victim ?t1 ?t2 - number)
        :precondition (and
            (clock ?t1)
            (inc ?t1 ?t2)
            (need-to-adjust-clock)
            (not (adjusted-status ?t2 ?v))
            (all-locations-spread-out ?t2)
            (or
                (first-victim ?v)
                (exists
                    (?v1 - victim)
                    (and (predecessor-victim ?v1 ?v) (adjusted-status ?t2 ?v1)))
            )
            (on-hospital ?v)
        )
        :effect (and
            (adjusted-status ?t2 ?v)
        )
    )
    (:action adjust-status-victim-on-medical-unit
        :parameters (?v - victim ?t1 ?t2 - number)
        :precondition (and
            (clock ?t1)
            (inc ?t1 ?t2)
            (need-to-adjust-clock)
            (not (adjusted-status ?t2 ?v))
            (all-locations-spread-out ?t2)
            (or
                (first-victim ?v)
                (exists
                    (?v1 - victim)
                    (and (predecessor-victim ?v1 ?v) (adjusted-status ?t2 ?v1)))
            )
            (exists
                (?m - medical-unit)
                (and
                    (have-victim-in-unit ?v ?m)
                )
            )
        )
        :effect (and
            (adjusted-status ?t2 ?v)
        )
    )

    (:action adjust-status-deceased-stays-deceased
        :parameters (?v - victim ?t1 ?t2 - number)
        :precondition (and
            (clock ?t1)
            (inc ?t1 ?t2)
            (need-to-adjust-clock)
            (all-locations-spread-out ?t2)
            (deceased ?v)
            (not (on-hospital ?v))
            (not (adjusted-status ?t2 ?v))
            (or
                (first-victim ?v)
                (exists
                    (?v1 - victim)
                    (and (predecessor-victim ?v1 ?v) (adjusted-status ?t2 ?v1)))
            )
        )
        :effect (and
            (adjusted-status ?t2 ?v)
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
        )
    )

    (:action spread-fire-without-fire-on-location
        :parameters (?l - location ?t1 ?t2 ?st - number)
        :precondition (and
            (clock ?t1)
            (spreading-time ?st ?l)
            (inc ?t1 ?t2)
            (is-greater-or-equal ?t2 ?st)
            (need-to-adjust-clock)
            (not (fire-at ?l))
            (exists
                (?l1 - location)
                (and
                    (adjacent ?l ?l1)
                    (fire-at ?l1)
                )
            )
            (not (spread-out ?t2 ?l))
            (or
                (first-location ?l)
                (exists
                    (?l1 - location)
                    (and (predecessor-location ?l1 ?l) (spread-out ?t2 ?l1)))
            )
        )
        :effect (and
            (spread-out ?t2 ?l)
            (oneof
                (and)
                (fire-at ?l)
            )
        )
    )
    (:action spread-fire-with-location-on-fire
        :parameters (?l - location ?t1 ?t2 ?st - number)
        :precondition (and
            (clock ?t1)
            (spreading-time ?st ?l)
            (inc ?t1 ?t2)
            (is-greater-or-equal ?t2 ?st)
            (need-to-adjust-clock)
            (fire-at ?l)
            (not (spread-out ?t2 ?l))
            (or
                (first-location ?l)
                (exists
                    (?l1 - location)
                    (and (predecessor-location ?l1 ?l) (spread-out ?t2 ?l1)))
            )
        )
        :effect (and
            (spread-out ?t2 ?l)
        )
    )
    (:action not-spread-fire
        :parameters (?l - location ?t1 ?t2 ?st - number)
        :precondition (and
            (clock ?t1)
            (inc ?t1 ?t2)
            (need-to-adjust-clock)
            (spreading-time ?st ?l)
            (not (spread-out ?t2 ?l))
            (or
                (first-location ?l)
                (exists
                    (?l1 - location)
                    (and (predecessor-location ?l1 ?l) (spread-out ?t2 ?l1)))
            )
            (or
                (and (is-greater-or-equal ?st ?t2) (not (= ?st ?t2)))
                (and
                    (is-greater-or-equal ?t2 ?st)
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
            (spread-out ?t2 ?l)
        )

    )

    (:action adjust-clock
        :parameters (?t1 ?t2 - number)
        :precondition (and
            (need-to-adjust-clock)
            (clock ?t1)
            (inc ?t1 ?t2)
            (all-victims-adjusted ?t2)
        )
        :effect (and
            (not (clock ?t1))
            (clock ?t2)
            (not (need-to-adjust-clock))
            (adjusted-clock)
        )
    )
    (:action get-all-victims-adjusted
        :parameters (?t1 ?t2 - number)
        :precondition (and
            (need-to-adjust-clock)
            (clock ?t1)
            (inc ?t1 ?t2)
            (all-locations-spread-out ?t2)
            (forall
                (?v - victim)
                (adjusted-status ?t2 ?v)
            )
        )
        :effect (and (all-victims-adjusted ?t2))
    )

    (:action get-all-locations-spread-out
        :parameters (?t1 ?t2 - number)
        :precondition (and
            (need-to-adjust-clock)
            (clock ?t1)
            (inc ?t1 ?t2)
            (forall
                (?l - location)
                (spread-out ?t2 ?l)
            )
        )
        :effect (and (all-locations-spread-out ?t2))
    )

    (:action treat-dying-victim-on-hospital
        :parameters (?l - location ?v - victim)
        :precondition (and
            (hospital-at ?l)
            (victim-at ?v ?l)
            (adjusted-clock)
            (dying ?v)
            (on-hospital ?v)
        )
        :effect (and

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
            (need-to-adjust-clock)
            (not (adjusted-clock))
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
            (need-to-adjust-clock)
            (not (adjusted-clock))
            (oneof
                (and)
                (and (healthy ?v) (not (hurt ?v)))
            )
        )
    )

)