import seaborn as sns
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
import os
import csv

header = "domain,problem,termination,memory,time,generated,inserted,removed,expanded,solution_size,policy_heuristic,state_heuristic,number_of_samples,length,percentage,number_of_lookups"
path = './misc/data/raw_results/'
dirs = os.listdir(path)
dfs = pd.DataFrame()
for dir in dirs:
    for file in os.listdir(path + dir):
        csv_path = os.path.join(path + dir, file)
        f = open(csv_path, 'r')
        if header in f.readline():
            df = pd.read_csv(csv_path)
            dfs = dfs._append(df, ignore_index=True)

dfs['domain'] = dfs['domain'].str.replace('./res/benchmarks/', '')
dfs['domain'] = dfs['domain'].str.replace('/domain.pddl', '')

dfs['problem'] = dfs['problem'].str.replace('./res/benchmarks/', '')
dfs['problem'] = dfs['problem'].str.split('/').str[1]

del dfs['termination']
groups = dfs.groupby(['domain', 'problem', 'policy_heuristic', 'state_heuristic']).sum()
with pd.option_context('display.max_rows', None,
                       'display.max_columns', None,
                       'display.precision', 3,
                       ):
    print(groups)
