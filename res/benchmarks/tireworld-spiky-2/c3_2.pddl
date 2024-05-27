
(define (problem tw-spiky-two-c3-4)
    (:domain tw-spiky-two)
    (:objects
        source sink t_11 t_21 t_22 t_31 t_32 t_33 t_41 t_42 t_43 t_44 nt_11 nt_21 nt_22 nt_31 nt_32 nt_33 p_1 p_2 p_3 p_4 - location
        0 1 2 3 4 - number
    )
    (:init
    (vehicle-at source)
    (not (flat-tire))
    (has-many-spares 0)


	;; nexts
	(next 0 1)
	(next 1 2)
	(next 2 3)
	(next 3 4)


	;; source to goal
	(spiky-road source p_1)
	(spiky-road p_1 p_2)
	(spiky-road p_2 p_3)
	(spiky-road p_3 p_4)
	(normal-road p_4 sink)


	;; goal to source
	(normal-road sink p_4)
	(spiky-road p_4 p_3)
	(spiky-road p_3 p_2)
	(spiky-road p_2 p_1)
	(spiky-road p_1 source)


	;;collecting tires
	(normal-road source t_11)
	(normal-road t_11 source)
	(spiky-road source nt_11)
	(normal-road nt_11 t_21)
	(normal-road t_21 t_22)
	(normal-road t_22 source)
	(spiky-road source nt_21)
	(spiky-road nt_21 nt_22)
	(normal-road nt_22 t_31)
	(normal-road t_31 t_32)
	(normal-road t_32 t_33)
	(normal-road t_33 source)
	(spiky-road source nt_31)
	(spiky-road nt_31 nt_32)
	(spiky-road nt_32 nt_33)
	(normal-road nt_33 t_41)
	(normal-road t_41 t_42)
	(normal-road t_42 t_43)
	(normal-road t_43 t_44)
	(normal-road t_44 source)


	;; tires
	(tire-at t_11)
	(tire-at t_21)
	(tire-at t_22)
	(tire-at t_31)
	(tire-at t_32)
	(tire-at t_33)
	(tire-at t_41)
	(tire-at t_42)
	(tire-at t_43)
	(tire-at t_44)
    )
    (:goal (and (vehicle-at sink)))
)
