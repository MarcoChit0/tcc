# # n = 8 -> x = 2
# def generate_instance(n):
#     x = n // 4
#     instance = f'''
# (define (problem tw-spiky-two-{n})
#     (:domain tw-spiky-two)
#     (:objects
#         {' '.join(f'b{i}' for i in range(n+1))} t - location
#         {' '.join(str(i) for i in range(x+1))} - number
#     )
#     (:init
#         (vehicle-at b{x})
#         (not (flat-tire))
#         (has-many-spares {x})

#         {generate_road_connections(n)}

#     )
#     (:goal (and (vehicle-at t) (not (flat-tire))))
# )
# '''
#     return instance

# def generate_road_connections(n):
#     connections = []
#     for i in range(n//4):
#         connections.append(f'(next {i} {i+1})')

#     for i in range(n+1):
#         if i == 0:
#             connections.append(f'(normal-road t b{i})')
#             connections.append(f'(spiky-road b{i} t)')
#         elif i == n:
#             connections.append(f'(normal-road b{i} t)')
#             connections.append(f'(spiky-road t b{i})')
#         else:
#             connections.append(f'(normal-road b{i-1} b{i})')
#             connections.append(f'(spiky-road b{i} b{i-1})')
#     return '\n'.join(connections)

# n = 24
# instance = generate_instance(n)

import sys
n = int(sys.argv[1])
m = int(sys.argv[2])

nodes = ['source', 'aux_0', 'aux_1','aux_2', 'target'] +  [f'n{i}' for i in range(n)] + [f'm{i}' for i in range(m)] + [f's{i}' for i in range(n+m+1)]
instance = f'''
(define (problem tw-spiky-two-4-{n}-{m})
    (:domain tw-spiky-two)
    (:objects
        {' '.join(nodes)}  - location
        {' '.join(str(i) for i in range(n+m+1))} - number
    )
    (:init
        (vehicle-at source)
        (not (flat-tire))
        (has-many-spares 0)

        {' '.join(f'(next {i} {i+1})' for i in range(n+m))}

        (spiky-road source aux_0)
        (normal-road aux_0 target)

        (normal-road source aux_1)
        (normal-road aux_1 aux_2)

        (normal-road aux_1 n0)
        (normal-road n{n-1} aux_1)

        (normal-road aux_2 m0)
        (normal-road m{m-1} aux_2)

        (normal-road aux_2 s0)
        (normal-road s{n+m} target)
        
        {' '.join(f'(normal-road n{i} n{i+1})' for i in range(n-1))}
        
        {' '.join(f'(normal-road m{i} m{i+1})' for i in range(m-1))}

        {' '.join(f'(spiky-road s{i} s{i+1})' for i in range(n+m))}

        {' '.join(f'(tire-at n{i})' for i in range(n))}

        {' '.join(f'(tire-at m{i})' for i in range(m))}

    )
    (:goal (and (vehicle-at target) (not (flat-tire))))
)
'''
print(instance)