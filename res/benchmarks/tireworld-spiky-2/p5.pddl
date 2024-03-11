(define (problem tw-spiky-two-5)
    (:domain tw-spiky-two)
    (:objects
        a1 - location
        b1 b2 - location
        c1 c2 - location
        d1 d2 d3 - location
        0 1 2 3 - number
    )
    (:init
        (vehicle-at a1)
        (not (flat-tire))
        (has-many-spares 0)

        (next 0 1)
        (next 1 2)
        (next 2 3)

        (spiky-road a1 b1) (spiky-road b1 a1)
        (spiky-road b1 c1) (spiky-road c1 b1)
        (spiky-road c1 a1) (spiky-road a1 c1)

        (normal-road b1 b2) (normal-road b2 b1)
        (normal-road c1 c2) (normal-road c2 c1)

        (spiky-road b2 d1) (spiky-road d1 b2)
        (spiky-road c2 d1) (spiky-road d1 c2)

        (spiky-road d1 d2) (spiky-road d2 d1)
        (spiky-road d2 d3) (spiky-road d3 d2)

        (tire-at a1)
        (tire-at b1)
        (tire-at b2)
        (tire-at c1)
        (tire-at c2)
    )
    (:goal (vehicle-at d3))
)
