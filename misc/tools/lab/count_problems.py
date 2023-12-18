import os
base_dir_path = 'experiments/07/test,v2023-12-15'
from metrics import check_if_csv_file_was_correctly_generated

data = {}
counter = {}
for policy_heuristic_dir in os.listdir(base_dir_path):
    policy_heuristic_dir_path = os.path.join(base_dir_path, policy_heuristic_dir)
    policy_heuristic = policy_heuristic_dir.split(',')[0]
    for domain_dir in os.listdir(policy_heuristic_dir_path):
        domain_dir_path = os.path.join(policy_heuristic_dir_path, domain_dir)
        for problem_dir in os.listdir(domain_dir_path):
            problem_dir_path = os.path.join(domain_dir_path, problem_dir)
            if check_if_csv_file_was_correctly_generated(f'{problem_dir_path}/results.csv', 'results'):
                if domain_dir not in data:
                    data[domain_dir] = {}
                if problem_dir not in data[domain_dir]:
                    data[domain_dir][problem_dir] = {}
                if policy_heuristic not in data[domain_dir][problem_dir]:
                    data[domain_dir][problem_dir][policy_heuristic] = []
                data[domain_dir][problem_dir][policy_heuristic].append(problem_dir_path)

                if policy_heuristic not in counter:
                    counter[policy_heuristic] = {}
                if domain_dir not in counter[policy_heuristic]:
                    counter[policy_heuristic][domain_dir] = 0
                if 'total' not in counter[policy_heuristic]:
                    counter[policy_heuristic]['total'] = 0
                counter[policy_heuristic][domain_dir] += 1
                counter[policy_heuristic]['total'] += 1

print(data)
print(counter)
for policy_heuristic in counter:
    print(policy_heuristic)
    for domain_dir in counter[policy_heuristic]:
        if domain_dir == 'total':
            continue
        print(f'\t{domain_dir}: {counter[policy_heuristic][domain_dir]}')
    print(f'\ttotal: {counter[policy_heuristic]["total"]}')