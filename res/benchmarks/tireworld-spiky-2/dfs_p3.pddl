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
        source sink almost-sink n1 s1 n2 s2 n3 s3 n4 s4 n5 s5 n6 s6 - location
        0 1 2 3 4 5 6 - number
    )
    (:init
        (vehicle-at source)
        (not (flat-tire))
        (has-many-spares 0)

        (next 0 1)
        (next 1 2)
        (next 2 3)
        (next 3 4)
        (next 4 5)
        (next 5 6)

        (normal-road source n1) (normal-road n1 n2) (normal-road n2 n3) (normal-road n3 n4) (normal-road n4 n5) (normal-road n5 n6)
        (normal-road n1 source) (normal-road n2 n1) (normal-road n3 n2) (normal-road n4 n3) (normal-road n5 n4) (normal-road n6 n5)

        (normal-road source s1) (normal-road almost-sink sink) (spiky-road s6 almost-sink) 
        (normal-road s1 source) (normal-road sink almost-sink) (spiky-road almost-sink s6)

        (spiky-road s1 s2) (spiky-road s2 s3) (spiky-road s3 s4) (spiky-road s4 s5) (spiky-road s5 s6)
        (spiky-road s2 s1) (spiky-road s3 s2) (spiky-road s4 s3) (spiky-road s5 s4) (spiky-road s6 s5)

        (spiky-road n1 s1) (spiky-road n2 s1) (spiky-road n3 s1) (spiky-road n4 s1) (spiky-road n5 s1) (spiky-road n6 s1)
        (spiky-road s1 n1) (spiky-road s1 n2) (spiky-road s1 n3) (spiky-road s1 n4) (spiky-road s1 n5) (spiky-road s1 n6)

        (tire-at n1)
        (tire-at n2)
        (tire-at n3)
        (tire-at n4)
        (tire-at n5)
        (tire-at n6)
    )
    (:goal (vehicle-at sink))
)