(define (domain rescue)
    (:requirements :typing :equality :negative-preconditions :disjunctive-preconditions :universal-preconditions :conditional-effects :existential-preconditions :non-deterministic)
    (:types
        location victim status fire_unit medical_unit number - object
    )
    (:constants
        healthy hurt dying - status
    )
    (:predicates
        ;; -- when porcessing clock --
        (clock ?t - number)
        (adjusted-clock)

        (is-greater-or-equal ?n1 ?n2 - number) ;; n1 >= n2 -> true, else false
        (is-equal ?n1 ?n2 - number) ;; n1 == n2 -> true, else false
        (inc ?op ?res - number)
        ;; ---------------------------
        ;; -- when porcessing location --
        (fire-at ?l - location)
        (water-at ?l - location)
        (hospital-at ?l - location)

        (victim-at ?v - victim ?l - location)
        (fire-unit-at ?u - fire_unit ?l - location)
        (medical-unit-at ?u - medical_unit ?l - location)

        (adjacent ?l1 ?l2 - location)

        (spreading-time ?t - number ?l - location)
        ;; ------------------------------
        ;; -- when porcessing victim --
        (victim-status ?v - victim ?s - status)
        ;; ----------------------------
        ;; -- do not appear on instance json --
        (spread-out ?t - number ?l - location)
        (need-to-adjust-clock)
        (have-water ?u - fire_unit)
        (have-victim-in-unit ?v - victim ?u - medical_unit)
        ;; ------------------------------------
    )

    (:action drive-fire-unit
        :parameters (?u - fire_unit ?from - location ?to - location)
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
        :parameters (?u - medical_unit ?from - location ?to - location)
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
        :parameters (?u - fire_unit ?l - location)
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
        :parameters (?u - medical_unit ?l - location ?v - victim)
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
        :parameters (?u - fire_unit ?l ?l1 - location)
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
        :parameters (?u - medical_unit ?l - location ?v - victim)
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

    (:action spread-fire
        :parameters (?l - location ?t ?next_t ?spreading_t - number)
        :precondition (and
            (clock ?t)
            (spreading-time ?spreading_t ?l)
            (inc ?t ?next_t)
            (is-greater-or-equal ?next_t ?spreading_t)
            (need-to-adjust-clock)
            (exists
                (?l1 - location)
                (and
                    (adjacent ?l ?l1)
                    (fire-at ?l1)
                )
            )
        )
        :effect (and
            (spread-out ?next_t ?l)
            (oneof
                (and)
                (fire-at ?l)
            )
        )
    )
    ;; TODO: ACTION BELLOW IS RESPONSIBLE FOR MAKING THE PROGRAM IMPOSSIBLE TO SOLVE
    (:action not-spread-fire
        :parameters (?l - location ?t ?next_t ?spreading_t - number)
        :precondition (and
            (clock ?t)
            (inc ?t ?next_t)
            (need-to-adjust-clock)
            (spreading-time ?spreading_t ?l)
            (or
                (and (is-greater-or-equal ?spreading_t ?next_t) (not (is-equal ?spreading_t ?next_t)))
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

    ;; TODO: action responsible for the following error: Unbound effect variables: Adding @object predicat
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
            (victim-status ?v dying)
        )
        :effect (and
            (need-to-adjust-clock)
            (not (adjusted-clock))
            (oneof
                (and (victim-status ?v healthy) (not (victim-status ?v hurt)))
                (and)
            )
        )
    )
    (:action treat-hurt-victim-on-hospital
        :parameters (?l - location ?v - victim)
        :precondition (and
            (hospital-at ?l)
            (victim-at ?v ?l)
            (not (fire-at ?l))
            (adjusted-clock)
            (victim-status ?v hurt)
        )
        :effect (and
            (need-to-adjust-clock)
            (not (adjusted-clock))
            (victim-status ?v healthy)
            (not (victim-status ?v hurt))
        )
    )
    (:action treat-victim-on-medical-unit
        :parameters (?u - medical_unit ?v - victim ?l - location)
        :precondition (and
            (not (fire-at ?l))
            (adjusted-clock)
            (or
                (have-victim-in-unit ?v ?u)
                (and
                    (medical-unit-at ?u ?l)
                    (victim-at ?v ?l)
                )
            )
            (victim-status ?v hurt)
        )
        :effect (and
            (not (adjusted-clock))
            (need-to-adjust-clock)
            (oneof
                (and (victim-status ?v healthy) (not (victim-status ?v hurt)))
                (and)
                (and (victim-status ?v dying) (not (victim-status ?v hurt)))
            )
        )
    )

)