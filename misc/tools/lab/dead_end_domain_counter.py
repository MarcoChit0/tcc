# Metric,Count
# HardDeadEndStates,0
# SoftDeadEndStates,7
# AliveStates,9
# WeakAliveStates,0
# TotalStates,16
# GoalStates,2
# NonGoalStates,14

from hmac import new
import os
from typing import Any
import pandas as pd
import numpy as np
import csv

df = pd.DataFrame()
base_dir_path = 'dead-end-experiments'
results_header = 'domain,problem,policy_heuristic,state_heuristic,number_of_samples,length,percentage_fsm,sample_generator,sample_treatment_class,percentage_timer,percentage_time_limit,percentage_memory_limit,walker,concrete_states_generator,regressor,termination,memory_usage,time,number_of_generated_policies,number_of_inserted_policies,number_of_removed_policies,number_of_expanded_policies,solution_length,number_of_lookups,number_of_states_generated_on_state_heuristic_table,number_of_lookups,number_of_useful_lookups,number_of_hard_dead_end_lookups,number_of_easy_dead_end_lookups'

def check_whether_results_file_is_correct(results_file:str) -> bool:
    with open(results_file, 'r') as file:
        content = file.read().splitlines()
        if len(content) < 2:
            return False
        header, data = content[0], content[1]
        columns = results_header.split(',')
        for i, col in enumerate(header.split(',')):
            if col != columns[i]:
                return False
        assert len(data.split(',')) == len(header.split(','))
    return True

for detector in os.listdir(base_dir_path):
    if detector in ["README.md", 'results']:
        continue
    detector_path = os.path.join(base_dir_path, detector)
    for domain in os.listdir(detector_path):
        domain_path = os.path.join(detector_path, domain)
        for problem in os.listdir(domain_path):
            problem_path = os.path.join(domain_path, problem)
            
            results_file = os.path.join(problem_path, 'results.csv')

            if not os.path.exists(results_file) or not check_whether_results_file_is_correct(results_file):
                continue 

            new_data = pd.read_csv(results_file)
            new_data['detector'] = detector

            # check whether the dead end dir exists and if the metadata file exists inside it
            dead_end_dir = os.path.join(problem_path, 'dead-end')
            metadata_file = os.path.join(dead_end_dir, 'metadata.txt')
            if os.path.exists(dead_end_dir) and os.path.exists(metadata_file):
                # read the metadata file
                with open(metadata_file, 'r') as file:
                    content = file.read().splitlines()
                    content = [line.split(',') for line in content]
                    metadata:dict[str, Any] = {line[0]: int(line[1]) for line in content[1:-1]}

                    new_data['hard dead ends'] = metadata.get('HardDeadEndStates', 0)
                    new_data['soft dead ends'] = metadata.get('SoftDeadEndStates', 0)
            df = pd.concat([df, new_data])
            


# Process data to get required format
def process_dead_end_detector_data(group):
    domain = group['domain'].iloc[0]
    hdd = group['hard dead ends'].sum()
    sdd = group['soft dead ends'].sum()
    total_dead_ends = hdd + sdd
    
    # Get problems with hard dead ends and soft dead ends
    problems_hdd = group[group['hard dead ends'] > 0]['problem'].tolist()
    problems_total = group[(group['hard dead ends'] > 0) | (group['soft dead ends'] > 0)]['problem'].tolist()
    
    # Limit problem names to 3 and add '...' if there are more
    problems_hdd = problems_hdd[:3] + (['...'] if len(problems_hdd) > 3 else [])
    problems_total = problems_total[:3] + (['...'] if len(problems_total) > 3 else [])
    
    return pd.Series({
        'domain': domain,
        'hard dead ends': hdd,
        'problems with hard dead ends': ', '.join(problems_hdd),
        'dead ends': total_dead_ends,
        'problems with dead ends': ', '.join(problems_total)
    })

# Apply processing function and reset index
with_detector_counter_df = df[df['detector'] == 'with-detector'].groupby('domain').apply(process_dead_end_detector_data).reset_index(drop=True)

# print the result adding some formatting, i.e., "|" to indicate the spacing between columns
with open(os.path.join(base_dir_path, 'results','dead_end_domain_counter.md'), 'w') as file:
    file.write(with_detector_counter_df.to_markdown(index=False, tablefmt="pipe"))

# Perform initial grouping
grouped_df = df.groupby(['detector', 'domain', 'problem']).agg({
    'number_of_generated_policies': 'sum',
    'time': 'sum'
}).reset_index()



# Initial group by to sum up and count the values for each problem in each domain for both detectors
grouped_df = df.groupby(['detector', 'domain', 'problem']).agg({
    'number_of_generated_policies': 'sum',
    'time': 'sum',
    'problem': 'count'  # This will count the number of instances (i.e., problems solved)
}).rename(columns={'problem': 'instances_solved'}).reset_index()

# Pivot the DataFrame to compare 'with-detector' and 'without-detector' side by side
pivot_df = grouped_df.pivot_table(index=['domain', 'problem'], columns='detector', values=['number_of_generated_policies', 'time', 'instances_solved'], aggfunc='first').reset_index()

# Flatten the MultiIndex columns and rename for clarity
pivot_df.columns = ['_'.join(col).strip() if col[1] else col[0] for col in pivot_df.columns.values]

final_df = pivot_df[['domain', 'problem', 
                     'number_of_generated_policies_with-detector', 'number_of_generated_policies_without-detector', 
                     'time_with-detector', 'time_without-detector']].copy()

final_df.rename(columns={
    'number_of_generated_policies_with-detector': 'number_of_expanded_policies_with_detector',
    'number_of_generated_policies_without-detector': 'number_of_expanded_policies_without_detector',
    'time_with-detector': 'time_with_detector',
    'time_without-detector': 'time_without_detector'
}, inplace=True)

# Save the DataFrame to a CSV file
final_df.to_csv(os.path.join(base_dir_path, 'results', 'domain_problem_performance_comparison.csv'), index=False)