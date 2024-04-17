(define (problem tw-spiky-two-1)
    (:domain tw-spiky-two)
    (:objects
        a1 a2 - location
        b1 b2 b3 b4 b5 - location
        c1 c2 c3 c4 c5 - location
        d1 d2 d3 d4 - location
        0 1 2 3 4 5 6 7 - number
    )
    (:init
        (vehicle-at a1)
        (not (flat-tire))
        (has-many-spares 0)

        (next 0 1)
        (next 1 2)
        (next 2 3)
        (next 3 4)
        (next 4 5)
        (next 5 6)
        (next 6 7)

        (normal-road a1 a2) (normal-road a2 a1)

        (spiky-road a2 b1) (spiky-road b1 a2)
        (spiky-road a2 c1) (spiky-road c1 a2)

        (normal-road b1 b2) (normal-road b2 b1)
        (normal-road b2 b3) (normal-road b3 b2)
        (normal-road b3 b4) (normal-road b4 b3)
        (spiky-road b4 b5) (spiky-road b5 b4)

        (normal-road c1 c2) (normal-road c2 c1)
        (normal-road c2 c3) (normal-road c3 c2)
        (normal-road c3 c4) (normal-road c4 c3)
        (spiky-road c4 c5) (spiky-road c5 c4)

        (spiky-road b5 d1) (spiky-road d1 b5)
        (spiky-road c5 d1) (spiky-road d1 c5)

        (spiky-road d1 d2) (spiky-road d2 d1)
        (spiky-road d2 d3) (spiky-road d3 d2)
        (normal-road d3 d4) (normal-road d4 d3)

        (tire-at a2)
        (tire-at b2)
        (tire-at b3)
        (tire-at b4)
        (tire-at c2)
        (tire-at c3)
        (tire-at c4)
    )
    (:goal (vehicle-at d4))
)