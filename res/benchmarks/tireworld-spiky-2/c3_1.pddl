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
        source sink almost a1 a2 a3 a4 a5 b1 b2 b3 b4 b5 a6 b6 a7 b7 a8 b8 - location
        0 1 2 3 4 5 6 7 8 - number
    )
    (:init
        (vehicle-at source)
        (not (flat-tire))
        (has-many-spares 0)

        
        (next 0 1) (next 1 2) (next 2 3) (next 3 4) (next 4 5) (next 5 6) (next 6 7) (next 7 8) (next 8 9) (next 9 10) 

        
        (normal-road source a1) (normal-road almost sink) 
        (normal-road a1 source) (normal-road sink almost)

        (spiky-road a1 a2) (spiky-road a2 a3) (spiky-road a3 a4) (spiky-road a4 a5) (spiky-road a5 a6) (spiky-road a6 a7) (spiky-road a7 a8) (spiky-road a8 almost)
        (spiky-road a2 a1) (spiky-road a3 a2) (spiky-road a4 a3) (spiky-road a5 a4) (spiky-road a6 a5) (spiky-road a7 a6) (spiky-road a8 a7) (spiky-road almost a8)

        (spiky-road a1 b1) (spiky-road a2 b2) (spiky-road a3 b3) (spiky-road a4 b4) (spiky-road a5 b5) (spiky-road a6 b6) (spiky-road a7 b7) (spiky-road a8 b8)
        (spiky-road b1 a1) (spiky-road b2 a2) (spiky-road b3 a3) (spiky-road b4 a4) (spiky-road b5 a5) (spiky-road b6 a6) (spiky-road b7 a7) (spiky-road b8 a8)

        (normal-road b1 a2) (normal-road b2 a3) (normal-road b3 a4) (normal-road b4 a5) (normal-road b5 a6) (normal-road b6 a7) (normal-road b7 a8) (normal-road b8 almost)
        (normal-road a2 b1) (normal-road a3 b2) (normal-road a4 b3) (normal-road a5 b4) (normal-road a6 b5) (normal-road a7 b6) (normal-road a8 b7) (normal-road almost b8)

        (tire-at b1) (tire-at b2) (tire-at b3) (tire-at b4) (tire-at b5) (tire-at b6) (tire-at b7) (tire-at b8)

    )
    (:goal (vehicle-at sink))
)