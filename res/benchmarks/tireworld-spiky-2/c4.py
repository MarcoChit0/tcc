# n = 8 -> x = 2
def generate_instance(n):
    x = n // 4
    instance = f'''
(define (problem tw-spiky-two-{n})
    (:domain tw-spiky-two)
    (:objects
        {' '.join(f'b{i}' for i in range(n+1))} t - location
        {' '.join(str(i) for i in range(x+1))} - number
    )
    (:init
        (vehicle-at b{x})
        (not (flat-tire))
        (has-many-spares {x})

        {generate_road_connections(n)}

    )
    (:goal (and (vehicle-at t) (not (flat-tire))))
)
'''
    return instance

def generate_road_connections(n):
    connections = []
    for i in range(n//4):
        connections.append(f'(next {i} {i+1})')

    for i in range(n+1):
        if i == 0:
            connections.append(f'(normal-road t b{i})')
            connections.append(f'(spiky-road b{i} t)')
        elif i == n:
            connections.append(f'(normal-road b{i} t)')
            connections.append(f'(spiky-road t b{i})')
        else:
            connections.append(f'(normal-road b{i-1} b{i})')
            connections.append(f'(spiky-road b{i} b{i-1})')
    return '\n'.join(connections)

n = 24
instance = generate_instance(n)
print(instance)
# (define (problem tw-spiky-two-2)
#     (:domain tw-spiky-two)
#     (:objects
#         b0 b1 b2 b3 b4 b5 b6 b7 b8 t - location
#         0 1 2 - number
#     )
#     (:init
#         (vehicle-at b2)
#         (not (flat-tire))
#         (has-many-spares 2)

        
#         (next 0 1) (next 1 2)

#         (normal-road t b0)(normal-road b0 b1) (normal-road b1 b2) (normal-road b2 b3) (normal-road b3 b4) (normal-road b4 b5) (normal-road b5 b6) (normal-road b6 b7) (normal-road b7 b8) (normal-road b8 t)
#         (spiky-road b0 t) (spiky-road b1 b0) (spiky-road b2 b1) (spiky-road b3 b2) (spiky-road b4 b3) (spiky-road b5 b4) (spiky-road b6 b5) (spiky-road b7 b6) (spiky-road b8 b7) (spiky-road t b8)
#     )
#     (:goal (and (vehicle-at t) (not (flat-tire))))
# )