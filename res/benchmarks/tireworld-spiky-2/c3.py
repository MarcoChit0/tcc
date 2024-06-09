
from operator import le


n = 2
locations = ["source", "sink"] +\
    [f"t_{i}{j}" for i in range(1,n+1) for j in range(1,i+1)] +\
    [f"nt_{i}{j}" for i in range(1,n) for j in range(1,i+1)] +\
    [f"p_{i}" for i in range(1, n+1)]

nexts = [f"\t(next {i} {i+1})" for i in range(n)]
source_to_goal = ["\t(spiky-road source p_1)"] + [f"\t(spiky-road p_{i-1} p_{i})" for i in range (2, n+1)] + [ f"\t(normal-road p_{n} sink)"]
goal_to_source = [f"\t(normal-road sink p_{n})"] + [f"\t(spiky-road p_{i} p_{i-1})" for i in range(n, 1, -1)] + [f"\t(spiky-road p_1 source)"]
# any_node_to_source = [f"\t(normal-road {l} source)" for l in locations if l != "source"]


collecting_tires = []
tires = []

leveling = {}

# for i in range(1, n+1):
#     for j in range(1, i+1):
#         if j == i:
#             colleting_tires.append(f"(normal-road t_{i}{j} source)")
#         if j == 1 and i - 1 > 0:
#             colleting_tires.append(f"(spiky-road source nt_{(i-1)}{j})")
#             colleting_tires.append(f"(normal-road nt_{i-1}{i-1} t_{i}{j})")
#         if j < i:
#             colleting_tires.append(f"(normal-road t_{i}{j} t_{i}{j+1})")
#             if i - 1 > 0 and j - 1 > 0:
#                 colleting_tires.append(f"(spiky-road nt_{i-1}{j} nt_{i-1}{j+1})")

for i in range(1, n + 1):
    leveling[i] = {
        "t": [f"t_{i}{j}" for j in range(1, i + 1)],
        "nt": [f"nt_{i-1}{j}" for j in range(1, i)]
    }
    leveling[i]["sequence"] = leveling[i]["nt"] + leveling[i]["t"]

for i in range(1, n+1):
    for t in leveling[i]["t"]:
        tires.append(f"\t(tire-at {t})")
    if i == 1:
        collecting_tires.append(f"\t(normal-road source {leveling[i]['sequence'][0]})")
    else:
        collecting_tires.append(f"\t(spiky-road source {leveling[i]['sequence'][0]})")
        for j in range(1, i-1):
            collecting_tires.append(f"\t(spiky-road {leveling[i]['sequence'][j-1]} {leveling[i]['sequence'][j]})")
            # collecting_tires.append(f"\t(spiky-road {leveling[i]['sequence'][j]} {leveling[i]['sequence'][j-1]})")
        for j in range(i-1, len(leveling[i]["sequence"])):
            collecting_tires.append(f"\t(normal-road {leveling[i]['sequence'][j-1]} {leveling[i]['sequence'][j]})")
            # collecting_tires.append(f"\t(normal-road  {leveling[i]['sequence'][j]} {leveling[i]['sequence'][j-1]})")
    collecting_tires.append(f"\t(normal-road {leveling[i]['sequence'][-1]} source)")


nexts_str = "\n\t;; nexts\n" + "\n".join(nexts)
source_to_goal_str = "\n\t;; source to goal\n" + "\n".join(source_to_goal)
goal_to_source_str = "\n\t;; goal to source\n" + "\n".join(goal_to_source)
# any_node_to_source_str = "\n\t;; any node back to goal\n" + "\n".join(any_node_to_source)
colleting_tires_str = "\n\t;;collecting tires\n" + '\n'.join(collecting_tires)
tires_str = "\n\t;; tires\n" + '\n'.join(tires)
instance = f'''
(define (problem tw-spiky-two-c3-{n})
    (:domain tw-spiky-two)
    (:objects
        {' '.join(locations)} - location
        {' '.join(str(i) for i in range(n+1))} - number
    )
    (:init
    (vehicle-at source)
    (not (flat-tire))
    (has-many-spares 0)

{nexts_str}

{source_to_goal_str}

{goal_to_source_str}

{colleting_tires_str}

{tires_str}
    )
    (:goal (and (vehicle-at sink)))
)'''

print(instance)