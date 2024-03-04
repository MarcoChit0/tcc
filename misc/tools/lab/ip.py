from functools import partial
import time

from attr import has
from pulp import *
import pulp
from collections import defaultdict
# input "[var0 = Atom flat-tire(), var1 = Atom has-many-spares(1), var2 = NegatedAtom tire-at(a), var3 = NegatedAtom tire-at(b), var4 = NegatedAtom tire-at(c), var5 = Atom vehicle-at(a)] -> deadend"

# states.txt file

def get_vehicle_at(domain, vehicle_at_variable, state, mapping_state_to_facts):
    vehicle_at = None
    for fact in domain[vehicle_at_variable]:
        if fact in mapping_state_to_facts[state]:
            vehicle_at = fact
            break
    if vehicle_at is None:
        print(f"State {state} does not have a fact that represents its position.")
        exit(1)
    return vehicle_at

def map_fact_to_int(fact:str, domain):
    count = 0
    for var in domain:
        if fact in domain[var]:
            return 10*count + domain[var][fact]
        else:
            count += 1    
    return float('inf')

def print_integer_programming(mapping_label_to_states, mapping_state_to_label, mapping_label_to_facts, map_state_to_facts, mapping_states_to_hash, domain):
    has_completed = False
    key_label = "difficult dead end"
    output_str = ""

    for y in range(1, len(mapping_label_to_states[key_label]) + 1):
        if has_completed:
            break

        # Create a PuLP problem
        problem = pulp.LpProblem("DeadEndDetector", pulp.LpMinimize)

        # Variables
        partial_states_facts_variables = []
        partial_states_states_variables = []

        obj = pulp.LpAffineExpression()

        # Add constraints to the y partial states
        for i in range(y):
            # minimize the selection of facts on the partal states
            facts_variables = {}
            for fact in mapping_label_to_facts[key_label]:
                var = pulp.LpVariable(f"fact_{fact}_{i}", 0, 1, pulp.LpBinary)
                facts_variables[fact] = var
                obj += var
            partial_states_facts_variables.append(facts_variables)

            states_variables = {}
            for state, label in mapping_state_to_label.items():
                if label == key_label:
                    var = pulp.LpVariable(f"{mapping_states_to_hash[state]}_{i}", 0, 1, pulp.LpBinary)
                    states_variables[state] = var
                    for fact in mapping_label_to_facts[key_label]:
                        if fact not in map_state_to_facts[state]:
                            # if deadend state does not have that fact, blocks the selection of that fact to the partial state that represents the deadend state
                            problem += facts_variables[fact] + states_variables[state] <= 1
                else:
                    # limit that the partial state represents all the states using dont care
                    exp = pulp.LpAffineExpression()
                    for fact in mapping_label_to_facts[key_label]:
                        if fact not in map_state_to_facts[state]:
                            exp += facts_variables[fact]
                    problem += (exp >= 1)
            partial_states_states_variables.append(states_variables)

        # All deadend states must be covered by at least one partial state
        # partial_state_0 = deadend_state_0 + deadend_state_1 + ... + deadend_state_n >= 1
        # partial_state_1 = deadend_state_0 + deadend_state_1 + ... + deadend_state_n >= 1
        # ...
        # partial_state_y = deadend_state_0 + deadend_state_1 + ... + deadend_state_n >= 1
        for state in mapping_label_to_states[key_label]:
            expr = pulp.LpAffineExpression()
            for i in range(y):
                expr += partial_states_states_variables[i][state]
            problem += (expr >= 1)

        problem += obj

        status = problem.solve(pulp.GUROBI_CMD())
        
        if pulp.LpStatus[status] == 'Optimal':
            has_completed = True
            for i in range(y):
                partial_state_true_facts: list[str] = []
                for fact in mapping_label_to_facts[key_label]:
                    if pulp.value(partial_states_facts_variables[i][fact]) == 1:
                        partial_state_true_facts.append(fact)
                partial_state_true_facts = sorted(partial_state_true_facts, key=lambda f: map_fact_to_int(f, domain))
                output_str += f"[{partial_state_true_facts}] -> {key_label}\n"

    assert has_completed, "The problem did not reach an optimal solution."

    return output_str


import os
domain = {}
# .sas file
# path = "misc/data/raw_results/test,v2024-02-28/max-lookup-delta-nearest,trie-star,100,facts-over-effects-mean-over-actions-mean,0.2,fsm,keep,0.1,0.7,0.9,stop,all,action-proportionality,complete/"
# instances = [
#     "tireworld-spiky-2/p3/dead-end/labels.txt", 
#     # "tireworld-spiky/p1/dead-end/labels.txt",
#     "tireworld-triangle/p1/dead-end/labels.txt"
# ]
path = "misc/data/raw_results/test,v2024-02-29/max-lookup-delta-nearest,trie-star,100,facts-over-effects-mean-over-actions-mean,0.2,fsm,keep,0.1,0.7,0.9,stop,all,action-proportionality,complete/"
instances = ["tireworld-triangle/p1/dead-end/labels.txt"]
sas_path = "res/compiled_benchmarks/"
for p in instances:
    states_file = os.path.join(path, p)
    sas_file_name = p.split("/")[0] + "," + p.split("/")[1] + ".sas"
    sas_file = os.path.join(sas_path, sas_file_name)
    with open(sas_file, "r") as file:
        while True:
            if "end_metric" in file.readline():
                break
        counter = int(file.readline())
        while counter > 0:
            counter -= 1
            assert file.readline() == "begin_variable\n"
            variable = file.readline().replace("\n", "")
            token = file.readline()
            domain_size = int(file.readline())
            facts = {}
            index = 0
            for _ in range(domain_size):
                facts[file.readline().replace("\n", "")] = index
                index += 1 
            domain[variable] = facts
            assert file.readline() == "end_variable\n"

    generated_states = 0
    class State:
        def __init__(self, variables, label):
            global generated_states
            self.variables = variables
            self.label = label
            self.id = generated_states
            generated_states += 1

        def __str__(self):
            return f"[{self.variables}] -> {self.label}"
        
    states = set()
    facts = set()
    mapping_label_to_states = defaultdict(set)
    mapping_state_to_label = {}
    mapping_label_to_facts = defaultdict(set)
    mapping_state_to_facts = defaultdict(set)
    mapping_states_to_hash = {}
    num_states = 0
    with open(states_file, "r") as file:
        for line in file.readlines():
            state, label = line.replace("\n", "").split(" -> ")
            variables = state.replace("[", "").replace("]", "").split(", ")
            v = {}
            for i in range(len(variables)):
                print(variables[i])
                variable, fact = variables[i].split(" = ")
                v[variable] = fact
            s = State(v, label)

            states.add(s)
            facts.update(v.values())

            mapping_states_to_hash[s] = f"state_{num_states}"; num_states += 1
            mapping_label_to_states[label].add(s)
            mapping_state_to_label[s] = label
            if label in mapping_label_to_facts:
                mapping_label_to_facts[label].update(v.values())
            else:
                mapping_label_to_facts[label] = set(v.values())
            mapping_state_to_facts[s] = set(v.values())
    print("mapping_label_to_states")
    print(mapping_label_to_states)
    print("mapping_state_to_label")
    print(mapping_state_to_label)
    print("mapping_label_to_facts")
    print(mapping_label_to_facts)
    print("mapping_state_to_facts")
    print(mapping_state_to_facts)
    print("mapping_states_to_hash")
    print(mapping_states_to_hash)
    print("domain")
    print(domain)
    output = print_integer_programming(mapping_label_to_states, mapping_state_to_label, mapping_label_to_facts, mapping_state_to_facts, mapping_states_to_hash, domain)
    with open(os.path.join(path, p.replace("labels.txt", "ip.txt")), "w") as file:
        file.write(output)