
(define (problem tw-spiky-two-c3-1)
    (:domain tw-spiky-two)
    (:objects
        source sink t_11 p_1 - location
        0 1 - number
    )
    (:init
    (vehicle-at source)
    (not (flat-tire))
    (has-many-spares 0)


	;; nexts
	(next 0 1)


	;; source to goal
	(spiky-road source p_1)
	(normal-road p_1 sink)


	;; goal to source
	(normal-road sink p_1)
	(spiky-road p_1 source)


	;;collecting tires
	(normal-road source t_11)
	(normal-road t_11 source)


	;; tires
	(tire-at t_11)
    )
    (:goal (and (vehicle-at sink)))
)
