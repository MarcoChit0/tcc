import seaborn as sns
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
import os
import csv

header = 'state_id,h_nd,h_d,policy_type'
raw_results_path = './misc/data/raw_results/'
png_path = './misc/data/png_results/'

def plot_data(data, domain, minimum_point, maximum_point, params, number_of_points=100):
    global png_path
    # comparision between h*nd and h*d
    ax = sns.scatterplot(data=data, x='h_nd', y='h_d', hue='instance')
    # diagonal line
    points = np.linspace(minimum_point, maximum_point, number_of_points)
    ax = sns.lineplot(x=points, y=points, color='black', alpha=0.2)
    # logarithm scale
    plt.xscale('symlog', linthresh = 9)
    plt.yscale('symlog', linthresh = 9)
    # save plot
    save_folder_path = png_path + params + '/'
    if not os.path.exists(f'{save_folder_path}'): os.makedirs(f'{save_folder_path}')
    plt.savefig(save_folder_path + domain + '.png')
    plt.clf()

for base_dir in os.listdir(raw_results_path):
    for param_dir in os.listdir(raw_results_path + base_dir):
        for domain_dir in os.listdir(raw_results_path + base_dir + '/' + param_dir):
            dfs = pd.DataFrame()
            min_h = float('inf')
            max_h = float('-inf')
            for problem_dir in os.listdir(raw_results_path + base_dir + '/' + param_dir + '/' + domain_dir):
                csv_path = os.path.join(raw_results_path + base_dir + '/' + param_dir + '/' + domain_dir + '/', "samples.csv")
                if not os.path.exists(csv_path): continue
                f = open(csv_path, 'r')
                if header in f.readline():
                    df = pd.read_csv(csv_path)
                    df['instance'] = problem_dir
                    max_h = max(max_h, max(df['h_d'].max(), df['h_nd'].max()))
                    min_h = min(min_h, min(df['h_d'].min(), df['h_nd'].min()))
                    dfs = dfs._append(df, ignore_index=True)
            plot_data(dfs, domain_dir, min_h, max_h, params=param_dir)
