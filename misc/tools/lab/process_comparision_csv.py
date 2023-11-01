import seaborn as sns
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
import os
import csv

header = "domain,problem,termination,memory,time,generated,inserted,removed,expanded,solution_size,policy_heuristic,state_heuristic,number_of_samples,random_walk_length,breadth_first_search_depth,number_of_lookups"
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

print(dfs.groupby(['state_heuristic']).count())
