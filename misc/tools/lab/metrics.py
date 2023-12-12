from random import sample
import seaborn as sns
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
import os
import csv

results_header = "domain,problem,policy_heuristic,state_heuristic,number_of_samples,length,percentage_fsm,sample_generator,sample_treatment_class,percentage_timer,percentage_time_limit,percentage_memory_limit,walker,concrete_states_generator,regressor,termination,memory_usage,time,number_of_generated_policies,number_of_inserted_policies,number_of_removed_policies,number_of_expanded_policies,solution_length,number_of_lookups,number_of_states_generated_on_state_heuristic_table"
#samples_header = 'state_id,state,h_nd,h_d,policy_type'
samples_header = 'state_id,h_nd,h_d,policy_type'
raw_results_path = './experiments/02_and_03/'
metrics_path = './misc/data/metrics/'
policy_heuristics = ['lookup-on-delta-nearest', 'max-lookup-delta-nearest']

def plot_data(data, domain, minimum_point, maximum_point, params, x, y, number_of_points=100):
    global metrics_path
    # comparision between h*nd and h*d
    ax = sns.scatterplot(data=data, x=x, y=y, hue='instance')
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
    
def check_if_csv_file_was_correctly_generated(csv_path:str, header:str):
    f = open(csv_path, 'r')
    content = ""
    for line in f.readlines():
        content += line
    content = content.replace('\n', '')
    if header in content:
        content = content.replace(header, '')
        return not content == ""
    else:
        return False

if __name__ == "__main__":
    for base_dir in os.listdir(raw_results_path):
        print("base_dir: " + base_dir)
        param_dirs = sorted(os.listdir(raw_results_path + base_dir))
        for param_dir in param_dirs:
            print("param_dir: " + param_dir)
            policy_heuristic = param_dir.split(',')[0]
            if policy_heuristic not in policy_heuristics: 
                continue
            elif policy_heuristic == 'max-lookup-delta-nearest' or 'lookup-on-delta-nearest':
                for domain_dir in os.listdir(raw_results_path + base_dir + '/' + param_dir):
                    print("max-lookup-delta-nearest metric")
                    print("domain_dir: " + domain_dir)
                    df = pd.DataFrame([], columns=['n', 'k', 'instance'])
                    min_h = float('inf')
                    max_h = float('-inf')
                    for problem_dir in sorted(os.listdir(raw_results_path + base_dir + '/' + param_dir + '/' + domain_dir), key = lambda problem_name: problem_name_to_float(problem_name)):
                        print("problem_dir: " + problem_dir)
                        results_csv_path = os.path.join(raw_results_path + base_dir + '/' + param_dir + '/' + domain_dir + '/' + problem_dir, "results.csv")
                        samples_csv_path = os.path.join(raw_results_path + base_dir + '/' + param_dir + '/' + domain_dir + '/' + problem_dir, "samples.csv")
                        if not (os.path.exists(results_csv_path) and os.path.exists(samples_csv_path)): 
                            continue
                        if check_if_csv_file_was_correctly_generated(results_csv_path, results_header) and check_if_csv_file_was_correctly_generated(samples_csv_path, samples_header):
                            results_df = pd.read_csv(results_csv_path)
                            if results_df['termination'][0] != 'optimal': 
                                continue
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
                    print(df)
                    plot_data(df, domain_dir, min_h, max_h, x='n', y='k', params=param_dir.replace('lookup-on-delta-nearest','max-lookup-delta-nearest'))
            if policy_heuristic == 'lookup-on-delta-nearest':
                print("lookup-on-delta-nearest metric")
                delta_nearest_param = param_dir.replace('lookup-on-delta-nearest','delta-nearest')
                if delta_nearest_param not in param_dirs:
                    print("delta-nearest param not found")
                    continue
                for domain_dir in os.listdir(raw_results_path + base_dir + '/' + param_dir):
                    print("domain_dir: " + domain_dir)
                    if domain_dir not in os.listdir(raw_results_path + base_dir + '/' + delta_nearest_param):
                        continue
                    df = pd.DataFrame([], columns=['policies-lookup-on-delta-nearest', 'policies-delta-nearest', 'instance'])
                    min_h = float('inf')
                    max_h = float('-inf')
                    for problem_dir in sorted(os.listdir(raw_results_path + base_dir + '/' + param_dir + '/' + domain_dir), key = lambda problem_name: problem_name_to_float(problem_name)):
                        print("problem_dir: " + problem_dir)
                        if problem_dir not in os.listdir(raw_results_path + base_dir + '/' + delta_nearest_param + '/' + domain_dir):
                            continue
                        results_csv_path = os.path.join(raw_results_path + base_dir + '/' + param_dir + '/' + domain_dir + '/' + problem_dir, "results.csv")
                        delta_nearest_csv_path = os.path.join(raw_results_path + base_dir + '/' + delta_nearest_param + '/' + domain_dir + '/' + problem_dir, "results.csv")
                        if not (os.path.exists(results_csv_path) and os.path.exists(delta_nearest_csv_path)): 
                            continue
                        if check_if_csv_file_was_correctly_generated(results_csv_path, results_header) and check_if_csv_file_was_correctly_generated(delta_nearest_csv_path, results_header):
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
                    print(df)
                    plot_data(df, domain_dir, min_h, max_h, x='policies-lookup-on-delta-nearest', y='policies-delta-nearest', params=param_dir)

