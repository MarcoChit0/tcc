
(define (problem tw-spiky-two-4-2-3)
    (:domain tw-spiky-two)
    (:objects
        source aux_0 aux_1 aux_2 target n0 n1 m0 m1 m2 s0 s1 s2 s3 s4 s5  - location
        0 1 2 3 4 5 - number
    )
    (:init
        (vehicle-at source)
        (not (flat-tire))
        (has-many-spares 0)

        (next 0 1) (next 1 2) (next 2 3) (next 3 4) (next 4 5)

        (spiky-road source aux_0)
        (normal-road aux_0 target)

        (normal-road source aux_1)
        (normal-road aux_1 aux_2)

        (normal-road aux_1 n0)
        (normal-road n1 aux_1)

        (normal-road aux_2 m0)
        (normal-road m2 aux_2)

        (normal-road aux_2 s0)
        (normal-road s5 target)
        
        (normal-road n0 n1)
        
        (normal-road m0 m1) (normal-road m1 m2)

        (spiky-road s0 s1) (spiky-road s1 s2) (spiky-road s2 s3) (spiky-road s3 s4) (spiky-road s4 s5)

        (tire-at n0) (tire-at n1)

        (tire-at m0) (tire-at m1) (tire-at m2)

    )
    (:goal (and (vehicle-at target) (not (flat-tire))))
)

