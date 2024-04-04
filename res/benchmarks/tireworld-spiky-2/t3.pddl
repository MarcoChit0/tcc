(define (problem tw-spiky-two-3)
    (:domain tw-spiky-two)
    (:objects
        a b c - location
        0 1 - number
    )
    (:init
        (vehicle-at a)
        (not (flat-tire))
        (has-many-spares 0)

        (next 0 1)

        (spiky-road a b) (spiky-road b a)
        (normal-road b c) (normal-roda c b)

        (tire-at a)
    )
    (:goal (vehicle-at c))
)