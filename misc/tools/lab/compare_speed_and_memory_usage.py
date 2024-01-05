import os
import pandas as pd
import seaborn as sns

basedir_path = "misc/data/raw_results/test,v2024-01-04"
header = "domain,problem,policy_heuristic,state_heuristic,number_of_samples,length,percentage_fsm,sample_generator,sample_treatment_class,percentage_timer,percentage_time_limit,percentage_memory_limit,walker,concrete_states_generator,regressor,termination,memory_usage,time,number_of_generated_policies,number_of_inserted_policies,number_of_removed_policies,number_of_expanded_policies,solution_length,number_of_lookups,number_of_states_generated_on_state_heuristic_table"
results = "results.csv"


dfs = pd.DataFrame()
for params in os.listdir(basedir_path):
    params_path = os.path.join(basedir_path, params)
    if params.split(",")[0] == "delta-nearest": continue
    for domain in os.listdir(params_path):
        domain_path = os.path.join(params_path, domain)
        for instance in os.listdir(domain_path):
            instance_path = os.path.join(domain_path, instance)
            if results in os.listdir(instance_path):
                results_path = os.path.join(instance_path, results)
                with open(results_path, "r") as f:
                    content = "".join(f.readlines())
                    if header not in content:
                        print(f"Missing header in {instance_path}")
                    else:
                        df = pd.read_csv(results_path)
                        if "trie-star" in params:
                            df["params"] = "trie"
                        else:
                            df["params"] = "hash"
                        print(df)
                        dfs = dfs._append(df[["domain", "problem", "memory_usage", "time", "params"]])

print(dfs)
print(dfs.groupby(["domain", "problem", "params"]).mean())
                

