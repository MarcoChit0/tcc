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
        source sink s1 s2 s3 s4 s5 s6 s7 s8 n1 n2 n3 n4 n5 n6 n7 n8 - location
        0 1 2 3 4 5 6 7 8 - number
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
        (next 6 7)
        (next 7 8)

        
        (normal-road source n1) (normal-road n1 source)
        (normal-road source n2) (normal-road n2 source)
        (normal-road source n3) (normal-road n3 source)
        (normal-road source n4) (normal-road n4 source)
        (normal-road source n5) (normal-road n5 source)
        (normal-road source n6) (normal-road n6 source)
        (normal-road source n7) (normal-road n7 source)
        (normal-road source n8) (normal-road n8 source)
    
        (tire-at n1)
        (tire-at n2)
        (tire-at n3)
        (tire-at n4)
        (tire-at n5)
        (tire-at n6)
        (tire-at n7)
        (tire-at n8)
        
        (spiky-road source s1) (spiky-road s1 source)
        (spiky-road s1 s2) (spiky-road s2 s1)
        (spiky-road s2 s3) (spiky-road s3 s2)
        (spiky-road s3 s4) (spiky-road s4 s3)
        (spiky-road s4 s5) (spiky-road s5 s4)
        (spiky-road s5 s6) (spiky-road s6 s5)
        (spiky-road s6 s7) (spiky-road s7 s6)
        (spiky-road s7 s8) (spiky-road s8 s7)
        (spiky-road s8 sink) (spiky-road sink s8)
    )
    (:goal (vehicle-at sink))
)