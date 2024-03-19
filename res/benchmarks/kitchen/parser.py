import json 
from res.benchmarks.sokoban.parser import write_instance
import os


# optimal solution:
# 1st - offer cake to John. 
# 2nd - offer cake to Bob.
# 3rd - offer cookies to Bob. 
# 4th - offer cookies to Alice.
# 5th - offer pancakes to John.

# total ingredient cost worst case scenario:
# 1 cake that nobody wants
# 2 cookeis that everybody wants
# 1 pancake that John wants

# flour = 2*1 + 2*2 + 1*1 = 7
# sugar = 1*1 + 2*2 = 5
# eggs = 3*1 + 2*2 = 7
# butter = 1*1 + 2*2 = 5
# milk = 1*1 = 1
if __name__ == "__main__":
    path = "res/benchmarks/kitchen/"
    instances_dir = "jsons"
    for json_file in os.listdir(os.path.join(path, instances_dir)):
        with open(os.path.join(path, instances_dir, json_file)) as file:
            instance = json.load(file)

            max_num = int(instance["islands"])
            for ingredient, quantity in instance["stock"].items():
                max_num = max(max_num, int(quantity))
            for recipe in instance["recipes"]:
                for ingredient, quantity in instance["recipes"][recipe].items():
                    max_num = max(max_num, int(quantity))

            objets_predicates = [f"{i} - number" for i in range(max_num+1)]
            objets_predicates += [f"ingredient-{ingredient} - ingredient" for ingredient, quantity in instance["stock"].items()]
            objets_predicates += [f"recipe-{recipe} - recipe" for recipe in instance["recipes"]]
            objets_predicates += [f"costumer-{costumer} - costumer" for costumer in instance["costumers"]]

            goal_predicates = [f"(satisfied costumer-{costumer})" for costumer in instance["costumers"]]

            initial_predicates = []
            for i in range(0, max_num+1):
                if i > 0:
                    initial_predicates.append(f"(dec {i} {i-1})")
                if i < max_num:
                    initial_predicates.append(f"(inc {i} {i+1})")
                initial_predicates.append(f"(equal {i} {i})")

            # (on-chef-island ?ing - ingredient ?n - number ?isl - number)
            for i in range(int(instance["islands"])):
                # start all islands empty
                initial_predicates.append(f"(not (finished {i}))")
                for ingredient, quantity in instance["stock"].items():
                    initial_predicates.append(f"(on-chef-island ingredient-{ingredient} {0} {i})")

            # (on-recipe ?ing - ingredient ?n - number ?r - recipe)
            for recipe in instance["recipes"]:
                for ingredient, quantity in instance["recipes"][recipe].items():
                    initial_predicates.append(f"(on-recipe ingredient-{ingredient} {quantity} recipe-{recipe})")

            # (on-stock ?ing - ingredient ?n - number)
            for ingredient, quantity in instance["stock"].items():
                initial_predicates.append(f"(on-stock ingredient-{ingredient} {quantity})")

            # (can-accept ?c - costumer ?r - recipe)
            # (num-refused-recipes ?c - costumer ?n - number)
            # (num-recipes-to-refuse ?c - costumer ?n - number)
            for costumer, recipes in instance["costumers"].items():
                for recipe in recipes:
                    initial_predicates.append(f"(can-accept costumer-{costumer} recipe-{recipe})")
                # each time the costumer refuses a recipe, the number of refused recipes increases by 1
                # so it need to start at 0 and end at the number of recipes - 1,
                # because the costumer can refuse all recipes but one
                initial_predicates.append(f"(num-refused-recipes costumer-{costumer} 0)")
                initial_predicates.append(f"(num-recipes-to-refuse costumer-{costumer} {len(recipes) - 1})")


            write_instance("kitchen", path, json_file.replace(".json", ""), objets_predicates, initial_predicates, goal_predicates)