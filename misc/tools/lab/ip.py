import pulp
from collections import defaultdict
# input "[var0 = Atom flat-tire(), var1 = Atom has-many-spares(1), var2 = NegatedAtom tire-at(a), var3 = NegatedAtom tire-at(b), var4 = NegatedAtom tire-at(c), var5 = Atom vehicle-at(a)] -> deadend"

domain = {}
# .sas file
with open("./res/compiled_benchmarks/tireworld-spiky-2,p4.sas", "r") as file:
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
map_state_to_facts = defaultdict(set)

# states.txt file
with open("./states.txt", "r") as file:
    for line in file.readlines():
        state, label = line.replace("\n", "").split(" -> ")
        variables = state.replace("[", "").replace("]", "").split(", ")
        v = {}
        for i in range(len(variables)):
            variable, fact = variables[i].split(" = ")
            v[variable] = fact
        s = State(v, label)

        states.add(s)
        facts.update(v.values())

        mapping_label_to_states[label].add(s)
        mapping_state_to_label[s] = label
        if label in mapping_label_to_facts:
            mapping_label_to_facts[label].update(v.values())
        else:
            mapping_label_to_facts[label] = set(v.values())
        map_state_to_facts[s] = set(v.values())

def print_integer_programming(mapping_label_to_states, mapping_state_to_label, mapping_label_to_facts, map_state_to_facts):
    has_completed = False
    key_label = "deadend"
    output_str = ""

    for y in range(1, len(mapping_label_to_states[key_label]) + 1):
        if has_completed:
            break

        # Create a PuLP problem
        problem = pulp.LpProblem("DeadEndDetector", pulp.LpMinimize)

        # Variables
        partial_states_facts_variables = []
        partial_states_states_variables = []

        objective_expr = 0

        # Add constraints to the y partial states
        for i in range(y):
            # minimize the selection of facts on the partal states
            facts_variables = {}
            for fact in mapping_label_to_facts[key_label]:
                var = pulp.LpVariable(f"fact_{fact}_{i}", 0, 1, pulp.LpBinary)
                facts_variables[fact] = var
                objective_expr += var
            partial_states_facts_variables.append(facts_variables)

            states_variables = {}
            for state, label in mapping_state_to_label.items():
                if label == key_label:
                    var = pulp.LpVariable(f"state_{state}_{i}", 0, 1, pulp.LpBinary)
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

        # Objective
        problem += objective_expr

        # Solve the problem
        status = problem.solve()

        if pulp.LpStatus[status] == 'Optimal':
            has_completed = True
            for i in range(y):
                partial_state_true_facts = []
                for fact in mapping_label_to_facts[key_label]:
                    if pulp.value(partial_states_facts_variables[i][fact]) == 1:
                        partial_state_true_facts.append(fact)
                # Output the partial state and its label
                output_str += f"[{partial_state_true_facts}] -> {key_label}\n"

                # Further processing and output formatting here
                # Note: The original C++ version's output formatting is quite specific and involves
                # custom classes and methods not defined here, so you'll need to adapt it to Python.

    assert has_completed, "The problem did not reach an optimal solution."

    return output_str


output = print_integer_programming(mapping_label_to_states, mapping_state_to_label, mapping_label_to_facts, map_state_to_facts)
print(output)