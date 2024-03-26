import json 
from res.benchmarks.sokoban.parser import write_instance
import os


# {
#     "victim": {
#         "v1": "dying"
#     },
#     "fire_unit": ["f1"],
#     "medical_unit": [],
#     "location": {
#         "l1": {
#             "objects": {
#                 "fire_unit":["f1"]
#             },
#             "predicates": ["fire-at", "water-at"],
#             "adjacent": ["l2"],
#             "spreading-time": "0"
#         },
#         "l2": {
#             "objects": {
#                 "victim": ["v1"]
#             },
#             "predicates": ["hospital-at"],
#             "adjacent": ["l1"],
#             "spreading-time": "1"
#         }
#     },
#     "clock": ["0", "5"]
# }
if __name__ == "__main__":
    path = "res/benchmarks/rescue/"
    instances_dir = "jsons"
    for json_file in os.listdir(os.path.join(path, instances_dir)):
        with open(os.path.join(path, instances_dir, json_file)) as file:
            instance = json.load(file)

            objets_predicates = [f"{i} - number" for i in range(int(instance["clock"][0]), int(instance["clock"][1] )+ 1)]
            objets_predicates += [f"{l} - location" for l in instance["location"].keys()]
            objets_predicates += [f"{v} - victim" for v in instance["victim"].keys()]
            objets_predicates += [f"{f} - fire-unit" for f in instance["fire-unit"]]
            objets_predicates += [f"{m} - medical-unit" for m in instance["medical-unit"]]

            goal_predicates = [f"(healthy {v})" for v in instance["victim"].keys()]

            initial_predicates = [f"(clock {instance['clock'][0]})", "(adjusted-clock)"]

            for i in range(int(instance["clock"][0]), int(instance["clock"][1]) + 1):

                for j in range(int(instance["clock"][0]), i+1):
                    initial_predicates.append(f"(is-greater-or-equal  {i} {j})")
                
                if i < int(instance["clock"][1]):
                    initial_predicates.append(f"(inc {i} {i+1})")
                
            for l, data in instance["location"].items():
                if "objects" in data:
                    for obj_type in data["objects"]:
                        for obj in data["objects"][obj_type]:
                            initial_predicates.append(f"({obj_type}-at {obj} {l})")
                if "predicates" in data:
                    for p in data["predicates"]:
                        initial_predicates.append(f"({p} {l})")
                if "adjacent" in data:
                    for adj in data["adjacent"]:
                        initial_predicates.append(f"(adjacent {l} {adj})")
                initial_predicates.append(f"(adjacent {l} {l})")
                if "spreading-time" in data:
                    initial_predicates.append(f"(spreading-time {data['spreading-time']} {l})")
        
            for v, status in instance["victim"].items():
                initial_predicates.append(f"({status} {v})")

            write_instance("rescue", path, json_file.replace(".json", ""), objets_predicates, initial_predicates, goal_predicates)