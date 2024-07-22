;;;  Authors: Michael Littman and David Weissman  ;;;
;;;  Modified: Blai Bonet for IPC 2006 ;;;
;;;  Modified: Christian Muise to make it a FOND domain
;;;  Modified: Frederico Messa, Marco Chitolina and André Pereira for deadend analysis ;;;

(define (domain tw-spiky-two)
    (:requirements :typing :strips :non-deterministic)
    (:types
        location
        number
    )
    (:predicates
        (vehicle-at ?loc - location)
        (tire-at ?loc - location)
        (normal-road ?from ?to - location)
        (spiky-road ?from ?to - location)
        (flat-tire)
        (has-many-spares ?count - number)
        (next ?n ?m - number)
    )

    (:action move-car-normal
        :parameters (?from ?to - location)
        :precondition (and (vehicle-at ?from) (normal-road ?from ?to) (not (flat-tire)))
        :effect (and (not (vehicle-at ?from)) (vehicle-at ?to))
    )

    (:action move-car-spiky
        :parameters (?from ?to - location)
        :precondition (and (vehicle-at ?from) (spiky-road ?from ?to) (not (flat-tire)))
        :effect (and (not (vehicle-at ?from)) (vehicle-at ?to) (oneof (and) (flat-tire)))
    )

    (:action load-tire
        :parameters (?loc - location ?n ?m - number)
        :precondition (and (vehicle-at ?loc) (tire-at ?loc) (has-many-spares ?n) (next ?n ?m))
        :effect (and (not (tire-at ?loc)) (not (has-many-spares ?n)) (has-many-spares ?m))
    )

    (:action drop-tire
        :parameters (?loc - location ?n ?m - number)
        :precondition (and (vehicle-at ?loc) (not (tire-at ?loc)) (has-many-spares ?m) (next ?n ?m))
        :effect (and (tire-at ?loc) (not (has-many-spares ?m)) (has-many-spares ?n))
    )

    (:action fix
        :parameters (?n ?m - number)
        :precondition (and (flat-tire) (has-many-spares ?m) (next ?n ?m))
        :effect (and (not (flat-tire)) (not (has-many-spares ?m)) (has-many-spares ?n))
    )
)