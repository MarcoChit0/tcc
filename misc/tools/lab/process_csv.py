import seaborn as sns
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
import os
import csv

def plot_data(data, domain, minimum_point, maximum_point, number_of_points=100):
    # comparision between h*nd and h*d
    ax = sns.scatterplot(data=data, x='h_nd', y='h_d', hue='instance')
    # diagonal line
    points = np.linspace(minimum_point, maximum_point, number_of_points)
    ax = sns.lineplot(x=points, y=points, color='black', alpha=0.2)
    # logarithm scale
    plt.xscale('symlog', linthresh = 9)
    plt.yscale('symlog', linthresh = 9)
    plt.savefig('./misc/data/png_results/' + domain + '.png')
    plt.clf()


files = os.listdir('./misc/data/csv_results/')
dfs = pd.DataFrame()
min_h = float('inf')
max_h = float('-inf')
last_domain = None

for file in sorted(files):
    f = open('./misc/data/csv_results/' + file, 'r')
    if 'state_id,h_nd,h_d' in f.readline():
        df = pd.read_csv('./misc/data/csv_results/' + file)
        current_domain, instance = file.split(',')
        if last_domain is None:
            last_domain = current_domain
        
        if current_domain != last_domain:        
            plot_data(dfs, last_domain, min_h, max_h)
            # reset variables
            dfs = pd.DataFrame()
            max_h = float('-inf')
            min_h = float('inf')
            last_domain = current_domain
        
        df['instance'] = instance.replace(".txt", "")
        max_h = max(max_h, max(df['h_d'].max(), df['h_nd'].max()))
        min_h = min(min_h, min(df['h_d'].min(), df['h_nd'].min()))
        dfs = dfs.append(df, ignore_index=True)
plot_data(dfs, last_domain, min_h, max_h)
        
