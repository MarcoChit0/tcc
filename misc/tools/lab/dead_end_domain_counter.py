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

dfs = pd.DataFrame()
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

            # add the metadata to the dataframe
            data = {}
            data['domain'] = domain
            data['problem'] = problem
            # data['sum'] = metadata['HardDeadEndStates'] + metadata['SoftDeadEndStates']
            data['sum'] = metadata['HardDeadEndStates']

            df = pd.DataFrame(data, index=[0])
            dfs = pd.concat([dfs, df])

# print the dataframe
print(dfs.groupby('domain').agg({
    'sum' : 'sum',
    'problem' : lambda x : ', '.join(x)
}))
