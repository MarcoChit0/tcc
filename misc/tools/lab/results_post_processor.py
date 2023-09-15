import os
import re
import statistics
import math

def mean(l):
    if len(l) == 0: return '-'
    else: return f'{statistics.geometric_mean(l):,.2f}'

def stdev(l):
    if len(l) == 0: return '-'
    else: return f'{math.exp(statistics.stdev(map(math.log, l))):,.2f}'

ipc_fond_domains = (
    'acrobatics',
    'beam-walk',
    'blocksworld-original',
    'blocksworld-advanced',
    'chain-of-rooms',
    'earth-observation',
    'elevators',
    'faults',
    'first-responders',
    'tireworld-triangle',
    'zenotravel'
)
new_fond_domains = (
    'doors',
    'islands',
    'miner',
    'tireworld-spiky',
    'tireworld-truck'
)
domains = ipc_fond_domains + new_fond_domains

input_label_pattern = input('Label Pattern: ')
configurations = [file[:-4] for file in os.listdir('./misc/data/processed_results') if re.search(input_label_pattern, file) != None]
print(configurations)
all_results = {configuration: [line.split(',') for line in open(f'./misc/data/processed_results/{configuration}.csv').read().split('\n')] for configuration in configurations}

post_processed_results: list[list[str]] = []
post_processed_results.append(['', '', ''] + sum(([configuration] + ['' for _ in range(6 - 1)] for configuration in configurations), start=[]))
post_processed_results.append(['domain', '#instances', '%intersection'] + sum((['%S', '%T', '%M', 'Time (s)', '# Gen.', '|π|'] for configuration in configurations), start=[]))

for domain in domains:
    configurations_runned_instancess = {configuration: {line[1] for line in all_results[configuration] if line[0] == domain} for configuration in configurations}
    intersection_runned_instances = set.intersection(*configurations_runned_instancess.values())
    if len(intersection_runned_instances) == 0: continue

    configurations_solved_instancess = {configuration: {line[1] for line in all_results[configuration] if line[0] == domain and line[1] in intersection_runned_instances and line[2] == 'S'} for configuration in configurations}
    configurations_time_out_instancess = {configuration: {line[1] for line in all_results[configuration] if line[0] == domain and line[1] in intersection_runned_instances and line[2] == 'T'} for configuration in configurations}
    configurations_memory_out_instancess = {configuration: {line[1] for line in all_results[configuration] if line[0] == domain and line[1] in intersection_runned_instances and line[2] == 'M'} for configuration in configurations}
    intersection_solved_instances = set.intersection(*configurations_solved_instancess.values())
    intersection_time_out_instances = set.intersection(*configurations_time_out_instancess.values())
    intersection_memory_out_instances = set.intersection(*configurations_memory_out_instancess.values())

    post_processed_results.append([])
    post_processed_results[-1].append(f'{domain}')
    post_processed_results[-1].append(f'{len(intersection_runned_instances)}')
    post_processed_results[-1].append(f'{len(intersection_solved_instances) / len(intersection_runned_instances):.2f}')

    for configuration in configurations:
        memory_used = []
        time_used = []
        number_of_generated_policies = []
        number_of_inserted_policies = []
        number_of_removed_policies = []
        number_of_expanded_policies = []
        uncompressed_size = []

        for line in all_results[configuration]:
            if line[0] == domain and line[1] in intersection_solved_instances:
                memory_used.append(float(line[3]))
                time_used.append(float(line[4]))
                number_of_generated_policies.append(int(line[5]))
                number_of_inserted_policies.append(int(line[6]))
                number_of_removed_policies.append(int(line[7]))
                number_of_expanded_policies.append(int(line[8]))
                uncompressed_size.append(int(line[9]))

        post_processed_results[-1].append(f'{len(configurations_solved_instancess[configuration]) / len(intersection_runned_instances):.2f}')
        post_processed_results[-1].append(f'{len(configurations_time_out_instancess[configuration]) / len(intersection_runned_instances):.2f}')
        post_processed_results[-1].append(f'{len(configurations_memory_out_instancess[configuration]) / len(intersection_runned_instances):.2f}')
        post_processed_results[-1].append(f'{mean(time_used)}')
        post_processed_results[-1].append(f'{mean(number_of_generated_policies)}')
        post_processed_results[-1].append(f'{mean(uncompressed_size)}')

open('./misc/data/post_processed_results.tsv','w').write('\n'.join('\t'.join(line) for line in post_processed_results))
