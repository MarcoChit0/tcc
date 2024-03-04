# Metric,Count
# HardDeadEndStates,0
# SoftDeadEndStates,7
# AliveStates,9
# WeakAliveStates,0
# TotalStates,16
# GoalStates,2
# NonGoalStates,14

import os
from typing import Any
import pandas as pd
import numpy as np

all_data = []
base_dir_path = 'misc/data/raw_results/test,v2024-02-28/max-lookup-delta-nearest,trie-star,100,facts-over-effects-mean-over-actions-mean,0.2,fsm,keep,0.1,0.7,0.9,stop,all,action-proportionality,reachable/'
for domain in os.listdir(base_dir_path):
    domain_path = os.path.join(base_dir_path, domain)
    for problem in os.listdir(domain_path):
        problem_path = os.path.join(domain_path, problem)
        
        # check whether the dead end dir exists and if the metadata file exists inside it
        dead_end_dir = os.path.join(problem_path, 'dead-end')
        if not os.path.exists(dead_end_dir):
            continue

        metadata_file = os.path.join(dead_end_dir, 'metadata.txt')
        if not os.path.exists(metadata_file):
            continue

        # read the metadata file
        with open(metadata_file, 'r') as file:
            content = file.read().splitlines()
            content = [line.split(',') for line in content]
            metadata:dict[str, Any] = {line[0]: int(line[1]) for line in content[1:-1]}

            all_data.append({
                'domain': domain,
                'problem': problem,
                'hard dead ends': metadata.get('HardDeadEndStates', 0),
                'soft dead ends': metadata.get('SoftDeadEndStates', 0)
            })



# Convert all_data to DataFrame
df = pd.DataFrame(all_data)

# Process data to get required format
def process_data(group):
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
result_df = df.groupby('domain').apply(process_data).reset_index(drop=True)

# print the result adding some formatting, i.e., "|" to indicate the spacing between columns
print(result_df.to_markdown(index=False, tablefmt="pipe"))