import json 
from res.benchmarks.sokoban.parser import write_instance
import os

if __name__ == "__main__":
    path = "res/benchmarks/travelling-salesman/"
    instances_dir = "jsons"
    for json_file in os.listdir(os.path.join(path, instances_dir)):
        with open(os.path.join(path, instances_dir, json_file)) as file:
            instance = json.load(file)

            objets_predicates = [f"{i} - city" for i in instance["city"].keys()]
            objets_predicates += [f"{i} - state" for i in instance["state"].keys()]
            objets_predicates += [f"{i} - item" for i in instance["item"].keys()]
            objets_predicates += [f"{i} - person" for i in instance["person"].keys()]
            if int(instance["biggest-number"]) + 1 > 5:
                objets_predicates += [f"{i} - number" for i in range(6, int(instance["biggest-number"]) + 1)]
            
            initial_predicates = []
            for i in range(int(instance["biggest-number"]) + 1):
                if i > 0:
                    initial_predicates.append(f"(dec {i} {i-1})")
                if i < int(instance["biggest-number"]):
                    initial_predicates.append(f"(inc {i} {i+1})")

            # (buying-price-state-map ?n - number ?s - state)
            # (selling-price-state-map ?n - number ?s - state)
            # (at ?c - city ?s - state)
            for state in instance["state"]:
                initial_predicates.append(f"(buying-price-state-map {instance['state'][state]['map']['buying-price']} {state})")
                initial_predicates.append(f"(selling-price-state-map {instance['state'][state]['map']['selling-price']} {state})")
                for city in instance["state"][state]["city"]:
                    initial_predicates.append(f"(at {city} {state})")
            
            # (connected ?c1 - city ?c2 - city)
            # (has-adjacent-cities ?c - city ?n - number)
            # (number-of-visits ?c - city ?n - number)
            for city in instance["city"]:
                initial_predicates.append(f"(has-adjacent-cities {city} {len(instance['city'][city])})")
                for adj in instance["city"][city]:
                    initial_predicates.append(f"(connected {city} {adj})")
            
            # (money ?n - number)
            # (wallet ?n - number)
            initial_predicates.append(f"(money {instance['money']})")
            initial_predicates.append(f"(wallet 0)")

            # (on-city ?c - city)
            initial_predicates.append(f"(on-city {instance['initial-city']})")

            # (backpack-total-space ?n - number)
            # (backpack-allocated-space ?n - number)
            initial_predicates.append(f"(backpack-total-space {instance['backpack']['total-space']})")
            initial_predicates.append(f"(backpack-allocated-space 0)")

            # (volumn ?i - item ?n - number)
            # (buying-price ?n - number ?i - item)
            # (selling-price ?n - number ?i - item)
            for item in instance["item"]:
                initial_predicates.append(f"(volumn {item} {instance['item'][item]['volumn']})")
                initial_predicates.append(f"(buying-price {item} {instance['item'][item]['buying-price']})")
                initial_predicates.append(f"(selling-price {item} {instance['item'][item]['selling-price']})")

            # (is-buyer ?p - person)
            # (is-seller ?p - person)
            # (person-at ?p - person ?c - city)
            # (is-buying ?p - person ?i - item)
            # (is-selling ?p - person ?i - item)
            for person in instance["person"]:
                for intention in instance["person"][person]["is"]:
                    if intention == "buying":
                        initial_predicates.append(f"(is-buyer {person})")
                        for item in instance["person"][person]["is"]["buying"]:
                            initial_predicates.append(f"(is-buying {person} {item})")
                    if intention == "selling":
                        initial_predicates.append(f"(is-seller {person})")
                        for item in instance["person"][person]["is"]["selling"]:
                            initial_predicates.append(f"(is-selling {person} {item})")

                initial_predicates.append(f"(person-at {person} {instance['person'][person]['at']})")

            if "cities-to-visit" not in instance or instance["cities-to-visit"] == "all":
                goal_predicates = [f"(visited-once {city})" for city in instance["city"].keys()]
            else:
                goal_predicates = [f"(visited-once {city})" for city in instance["cities-to-visit"]]
            write_instance("travelling-salesman", path, json_file.replace(".json", ""), objets_predicates, initial_predicates, goal_predicates)