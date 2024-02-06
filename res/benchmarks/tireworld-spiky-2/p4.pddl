(define (problem tw-spiky-two-2)
    (:domain tw-spiky-two)
    (:objects
        a b c d e - location
        0 1 2 - number
    )
    (:init
        (vehicle-at a)
        (not (flat-tire))
        (has-many-spares 0)

        (next 0 1)
        (next 1 2)

        (normal-road a b) (normal-road b a)
        (normal-road a c) (normal-road c a)

        (spiky-road b d) (spiky-road d b)
        (spiky-road c d) (spiky-road d c)
        (spiky-road e d) (spiky-road d e)

        (tire-at b)
        (tire-at c)
    )
    (:goal (vehicle-at e))
)