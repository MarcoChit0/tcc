import seaborn as sns
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
import os
import csv

header = "domain,problem,policy_heuristic,state_heuristic,number_of_samples,length,percentage_fsm,sample_generator,sample_treatment_class,percentage_timer,percentage_time_limit,percentage_memory_limit,walker,concrete_states_generator,regressor,termination,memory_usage,time,number_of_generated_policies,number_of_inserted_policies,number_of_removed_policies,number_of_expanded_policies,solution_length,number_of_lookups,number_of_states_generated_on_state_heuristic_table"
raw_results_path = './misc/data/raw_results/'
dfs = pd.DataFrame()
for base_dir in os.listdir(raw_results_path):
    for param_dir in os.listdir(raw_results_path + base_dir):
        for domain_dir in os.listdir(raw_results_path + base_dir + '/' + param_dir):
            for problem_dir in os.listdir(raw_results_path + base_dir + '/' + param_dir + '/' + domain_dir):
                csv_path = os.path.join(raw_results_path + base_dir + '/' + param_dir + '/' + domain_dir + '/' + problem_dir, "results.csv")
                print(csv_path)
                if not os.path.exists(csv_path): continue
                f = open(csv_path, 'r')
                if header in f.readline():
                    df = pd.read_csv(csv_path)
                    dfs = dfs._append(df, ignore_index=True)

del dfs['termination']
groups = dfs.groupby(['domain', 'problem', 'policy_heuristic', 'state_heuristic']).sum()
with pd.option_context('display.max_rows', None,
                       'display.max_columns', None,
                       'display.precision', 3,
                       ):
    print(groups)
