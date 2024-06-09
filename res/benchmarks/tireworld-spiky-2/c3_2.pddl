
(define (problem tw-spiky-two-c3-2)
    (:domain tw-spiky-two)
    (:objects
        source sink t_11 t_21 t_22 nt_11 p_1 p_2 - location
        0 1 2 - number
    )
    (:init
    (vehicle-at source)
    (not (flat-tire))
    (has-many-spares 0)


	;; nexts
	(next 0 1)
	(next 1 2)


	;; source to goal
	(spiky-road source p_1)
	(spiky-road p_1 p_2)
	(normal-road p_2 sink)


	;; goal to source
	(normal-road sink p_2)
	(spiky-road p_2 p_1)
	(spiky-road p_1 source)


	;;collecting tires
	(normal-road source t_11)
	(normal-road t_11 source)
	(spiky-road source nt_11)
	(normal-road nt_11 t_21)
	(normal-road t_21 t_22)
	(normal-road t_22 source)


	;; tires
	(tire-at t_11)
	(tire-at t_21)
	(tire-at t_22)
    )
    (:goal (and (vehicle-at sink)))
)
