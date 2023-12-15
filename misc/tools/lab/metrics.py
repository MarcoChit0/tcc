from random import sample
from xml import dom
import seaborn as sns
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
import os
import csv

results_header = "domain,problem,policy_heuristic,state_heuristic,number_of_samples,length,percentage_fsm,sample_generator,sample_treatment_class,percentage_timer,percentage_time_limit,percentage_memory_limit,walker,concrete_states_generator,regressor,termination,memory_usage,time,number_of_generated_policies,number_of_inserted_policies,number_of_removed_policies,number_of_expanded_policies,solution_length,number_of_lookups,number_of_states_generated_on_state_heuristic_table"
#samples_header = 'state_id,state,h_nd,h_d,policy_type'
samples_header1 = 'state_id,h_nd,h_d,policy_type'
samples_header2 = 'state_id,state,h_nd,h_d,policy_type'
raw_results_path = './experiments/05/'
metrics_path = './misc/data/metrics/'
policy_heuristics = ['lookup-on-delta-nearest', 'max-lookup-delta-nearest']

def plot_data(data, domain, minimum_point, maximum_point, params, x, y, palette, number_of_points=100):
    global metrics_path
    # comparision between h*nd and h*d
    ax = sns.scatterplot(data=data, x=x, y=y, hue='instance', palette=palette)
    # diagonal line
    points = np.linspace(minimum_point, maximum_point, number_of_points)
    ax = sns.lineplot(x=points, y=points, color='black', alpha=0.2)
    # logarithm scale
    plt.xscale('symlog', linthresh = 9)
    plt.yscale('symlog', linthresh = 9)
    # save plot
    save_folder_path = metrics_path + params + '/'
    if not os.path.exists(save_folder_path): os.makedirs(save_folder_path)
    plt.savefig(save_folder_path + domain + '.png')
    plt.clf()

def problem_name_to_float(problem_name:str):
    if 'fr-p_' in problem_name: 
        return float(problem_name.replace('fr-p_', '').replace('_', '.')[1:])
    else:
        return float(problem_name.replace('_', '.')[1:])
    
def check_if_csv_file_was_correctly_generated(csv_path:str, header_type:str):
    f = open(csv_path, 'r')
    content = ""
    for line in f.readlines():
        content += line
    content = content.replace('\n', '')
    if header_type == 'results':
        header = results_header
        if header in content:
            content = content.replace(header, '')
            return not content == ""
        else:
            return False
    elif header_type == 'samples':
        header1 = samples_header1
        header2 = samples_header2
        if header1 in content:
            content = content.replace(header1, '')
            return not content == ""
        elif header2 in content:
            content = content.replace(header2, '')
            return not content == ""
        else:
            return False
    else:
        return False

if __name__ == "__main__":
    for base_dir in os.listdir(raw_results_path):
        param_dirs = sorted(os.listdir(raw_results_path + base_dir))
        data = {}
        for param_dir in param_dirs:
            policy_heuristic = param_dir.split(',')[0]
            if policy_heuristic not in policy_heuristics: 
                continue
            if policy_heuristic == 'max-lookup-delta-nearest' or 'lookup-on-delta-nearest':
                for domain_dir in os.listdir(raw_results_path + base_dir + '/' + param_dir):
                    metric = "max-lookup-delta-nearest-metric"
                    if metric not in data:
                        data[metric] = {}
                    if domain_dir not in data[metric]:
                        data[metric][domain_dir] = {}
                        data[metric][domain_dir][param_dir] = {}
                        data[metric][domain_dir]['min_h'] = float('inf')
                        data[metric][domain_dir]['max_h'] = float('-inf')
                        data[metric][domain_dir]['palette'] = {}
                        data[metric][domain_dir]['x'] = 'n'
                        data[metric][domain_dir]['y'] = 'k'
                    df = pd.DataFrame([], columns=['n', 'k', 'instance'])
                    min_h = float('inf')
                    max_h = float('-inf')
                    for problem_dir in sorted(os.listdir(raw_results_path + base_dir + '/' + param_dir + '/' + domain_dir), key = lambda problem_name: problem_name_to_float(problem_name)):
                        results_csv_path = os.path.join(raw_results_path + base_dir + '/' + param_dir + '/' + domain_dir + '/' + problem_dir, "results.csv")
                        samples_csv_path = os.path.join(raw_results_path + base_dir + '/' + param_dir + '/' + domain_dir + '/' + problem_dir, "samples.csv")
                        if not (os.path.exists(results_csv_path) and os.path.exists(samples_csv_path)): 
                            continue
                        if check_if_csv_file_was_correctly_generated(results_csv_path, 'results') and check_if_csv_file_was_correctly_generated(samples_csv_path, 'samples'):
                            results_df = pd.read_csv(results_csv_path)
                            if results_df['termination'][0] != 'optimal': 
                                continue
                            if problem_dir not in data[metric][domain_dir]['palette']:
                                # select a color to represent the problem
                                data[metric][domain_dir]['palette'][problem_dir] = np.random.rand(3)
                            samples_df = pd.read_csv(samples_csv_path)
                            k = 0
                            c:int = int(results_df['solution_length'].at[0])
                            n:int = int(results_df['number_of_states_generated_on_state_heuristic_table'].at[0])
                            for i in range(len(samples_df)):
                                if samples_df['h_d'][i] <= c and  samples_df['h_nd'][i] > c:
                                    k += 1
                            new_row = {'n': n, 'k': k, 'instance': problem_dir}
                            print(new_row)
                            print(c)
                            max_h = max([max_h, k, n])
                            min_h = min([min_h, k, n])
                            df = df._append(new_row, ignore_index=True)
                    # save data
                    data[metric][domain_dir][param_dir] = df
                    data[metric][domain_dir]['min_h'] = min(min_h, data[metric][domain_dir]['min_h'])
                    data[metric][domain_dir]['max_h'] = max(max_h, data[metric][domain_dir]['max_h'])
            if policy_heuristic == 'lookup-on-delta-nearest':
                delta_nearest_param = param_dir.replace('lookup-on-delta-nearest','delta-nearest')
                if delta_nearest_param not in param_dirs:
                    print(param_dirs)
                    print("LOG::lookup-on-delta-nearest::delta-nearest dir not found")
                    continue
                for domain_dir in os.listdir(raw_results_path + base_dir + '/' + param_dir):
                    if domain_dir not in os.listdir(raw_results_path + base_dir + '/' + delta_nearest_param):
                        print(f"LOG::lookup-on-delta-nearest::{domain_dir} not found on delta-nearest dir")
                        continue
                    metric = "lookup-on-delta-nearest-metric"
                    if metric not in data:
                        data[metric] = {}
                    if domain_dir not in data[metric]:
                        data[metric][domain_dir] = {}
                        data[metric][domain_dir][param_dir] = {}
                        data[metric][domain_dir]['min_h'] = float('inf')
                        data[metric][domain_dir]['max_h'] = float('-inf')
                        data[metric][domain_dir]['palette'] = {}
                        data[metric][domain_dir]['x'] = 'policies-lookup-on-delta-nearest'
                        data[metric][domain_dir]['y'] = 'policies-delta-nearest'
                    df = pd.DataFrame([], columns=['policies-lookup-on-delta-nearest', 'policies-delta-nearest', 'instance'])
                    min_h = float('inf')
                    max_h = float('-inf')
                    for problem_dir in sorted(os.listdir(raw_results_path + base_dir + '/' + param_dir + '/' + domain_dir), key = lambda problem_name: problem_name_to_float(problem_name)):
                        if problem_dir not in os.listdir(raw_results_path + base_dir + '/' + delta_nearest_param + '/' + domain_dir):
                            print(f"LOG::lookup-on-delta-nearest::{domain_dir}/{problem_dir} not found on delta-nearest dir")
                            continue
                        results_csv_path = os.path.join(raw_results_path + base_dir + '/' + param_dir + '/' + domain_dir + '/' + problem_dir, "results.csv")
                        delta_nearest_csv_path = os.path.join(raw_results_path + base_dir + '/' + delta_nearest_param + '/' + domain_dir + '/' + problem_dir, "results.csv")
                        if not (os.path.exists(results_csv_path) and os.path.exists(delta_nearest_csv_path)): 
                            continue
                        if check_if_csv_file_was_correctly_generated(results_csv_path, 'results') and check_if_csv_file_was_correctly_generated(delta_nearest_csv_path, 'results'):
                            if problem_dir not in data[metric][domain_dir]['palette']:
                                # select a color to represent the problem
                                data[metric][domain_dir]['palette'][problem_dir] = np.random.rand(3)
                            results_df = pd.read_csv(results_csv_path)
                            delta_nearest_df = pd.read_csv(delta_nearest_csv_path)
                            policies_lookup_on_delta_nearest = int(results_df['number_of_generated_policies'].at[0])
                            policies_delta_nearest = int(delta_nearest_df['number_of_generated_policies'].at[0])
                            new_row = {
                                'policies-lookup-on-delta-nearest': policies_lookup_on_delta_nearest,
                                'policies-delta-nearest': policies_delta_nearest, 
                                'instance': problem_dir
                                }
                            print(new_row)
                            max_h = max([max_h, policies_lookup_on_delta_nearest, policies_delta_nearest])
                            min_h = min([min_h, policies_lookup_on_delta_nearest, policies_delta_nearest])
                            df = df._append(new_row, ignore_index=True)
                    # save data
                    data[metric][domain_dir][param_dir] = df
                    data[metric][domain_dir]['min_h'] = min(min_h, data[metric][domain_dir]['min_h'])
                    data[metric][domain_dir]['max_h'] = max(max_h, data[metric][domain_dir]['max_h'])
        for metric in data:
            for domain_dir in data[metric]:
                param_dirs = [key for key in data[metric][domain_dir] if key != 'min_h' and key != 'max_h' and key != 'palette' and key != 'x' and key != 'y']
                for param_dir in param_dirs:
                    print(f"{domain_dir}::{param_dir}")
                    print(data[metric][domain_dir][param_dir])
                    if metric == "max-lookup-delta-nearest-metric":
                        params = param_dir.replace('lookup-on-delta-nearest', 'max-lookup-delta-nearest')
                    else:
                        params = param_dir
                    plot_data(
                        data = data[metric][domain_dir][param_dir],
                        domain = domain_dir,
                        minimum_point = data[metric][domain_dir]['min_h'],
                        maximum_point = data[metric][domain_dir]['max_h'],
                        params = params,
                        x=data[metric][domain_dir]['x'],
                        y=data[metric][domain_dir]['y'],
                        palette=data[metric][domain_dir]['palette'],)

