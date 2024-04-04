; (define (problem tw-spiky-two-1)
;     (:domain tw-spiky-two)
;     (:objects
;         source n0 n1 n2 n3 n4 s0 s1 s2 s3 s4 sink - location
;         0 1 2 - number
;     )
;     (:init
;         (vehicle-at source)
;         (not (flat-tire))
;         (has-many-spares 0)

;         (next 0 1)
;         (next 1 2)

;         (normal-road source n0) (normal-road n0 n1) (normal-road n1 n2) (normal-road n2 n3) (normal-road n3 n4) (normal-road n4 source)
;         (normal-road n0 source) (normal-road n1 n0) (normal-road n2 n1) (normal-road n3 n2) (normal-road n4 n3) (normal-road source n4)
        
;         (normal-road source s0) (spiky-road s0 s1) (spiky-road s1 s2) (normal-road s2 sink)
;         (normal-road s0 source) (spiky-road s1 s0) (spiky-road s2 s1) (normal-road sink s2)

;         (spiky-road n1 s3) (spiky-road s3 s4) (spiky-road s4 s2)
;         (spiky-road s3 n1) (spiky-road s4 s3) (spiky-road s2 s4)

;         (tire-at n0)
;         (tire-at n1)
;     )
;     (:goal (vehicle-at sink))
; )

(define (problem tw-spiky-two-2)
    (:domain tw-spiky-two)
    (:objects
        source sink n1 s1 n2 s2 n3 s3 almost-sink - location
        0 1 2 3 - number
    )
    (:init
        (vehicle-at source)
        (not (flat-tire))
        (has-many-spares 0)

        (next 0 1)
        (next 1 2)
        (next 2 3)

        (normal-road source n1) (normal-road n1 n2) (normal-road n2 n3)
        (normal-road n1 source) (normal-road n2 n1) (normal-road n3 n2)

        (normal-road source s1) (spiky-road s1 s2) (spiky-road s2 s3) (spiky-road s3 almost-sink) (normal-road almost-sink sink)
        (normal-road s1 source) (spiky-road s2 s1) (spiky-road s3 s2) (spiky-road almost-sink s3) (normal-road sink almost-sink)

        (spiky-road n1 s1) (spiky-road n2 s1) (spiky-road n3 s1)
        (spiky-road s1 n1) (spiky-road s1 n2) (spiky-road s1 n3)

        (tire-at n1)
        (tire-at n2)
        (tire-at n3)
    )
    (:goal (vehicle-at sink))
)