import os
from metrics import check_if_csv_file_was_correctly_generated, results_header, samples_header

path = "./experiments/02_and_03/test,v2023-12-08/"
folders = [basename for basename in sorted(os.listdir(path)) if os.path.isdir(f'{path}/{basename}') and not basename.split(',')[0].replace('delta-nearest', 'nearest') == ""]

solved_instances = {}
# print(folders)

for folder in folders:
    # print(f"folder: {folder}")
    for domain in sorted(os.listdir(f'{path}/{folder}')):
        # print(f"domain: {domain}")
        solved_instances[domain] = []
        for instance in sorted(os.listdir(f'{path}/{folder}/{domain}')):
            # print(f"instance: {instance}")
            results_path = f'{path}/{folder}/{domain}/{instance}/results.csv'
            samples_path = f'{path}/{folder}/{domain}/{instance}/samples.csv'
            if (os.path.exists(samples_path) and check_if_csv_file_was_correctly_generated(samples_path, samples_header)):
                solved_instances[domain].append(instance)

for domain in solved_instances:
    for instance in solved_instances[domain]:
        print(f"{domain},{instance}")
                