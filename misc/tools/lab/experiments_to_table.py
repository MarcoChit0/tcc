import readline
import pandas as pd
import os
instances = {
    "tireworld-spiky-2" : {
        "c1" : {
            "pr2" : "0",
            "and2" : "0",
            "idfsp": "0",
            "marker": "0",
            "dfs" : "0",
            "dfs+soft": "0",
            "dfs+marker": "0",
        },
        "c2" : {
            "pr2" : "0",
            "and2" : "0",
            "idfsp": "0",
            "marker": "0",
            "dfs" : "0",
            "dfs+soft": "0",
            "dfs+marker": "0",
        },
        "c3" : {
            "pr2" : "0",
            "and2" : "0",
            "idfsp": "0",
            "marker": "0",
            "dfs" : "0",
            "dfs+soft": "0",
            "dfs+marker": "0",
        },
        "c4" : {
            "pr2" : "0",
            "and2" : "0",
            "idfsp": "0",
            "marker": "0",
            "dfs" : "0",
            "dfs+soft": "0",
            "dfs+marker": "0",
        },
    },
    "sokoban" : {
        "c1" : {
            "pr2" : "0",
            "and2" : "0",
            "idfsp": "0",
            "marker": "0",
            "dfs" : "0",
            "dfs+soft": "0",
            "dfs+marker": "0",
        },
        "c2" : {
            "pr2" : "0",
            "and2" : "0",
            "idfsp": "0",
            "marker": "0",
            "dfs" : "0",
            "dfs+soft": "0",
            "dfs+marker": "0",
        },
        "c3" : {
            "pr2" : "0",
            "and2" : "0",
            "idfsp": "0",
            "marker": "0",
            "dfs" : "0",
            "dfs+soft": "0",
            "dfs+marker": "0",
        },
        "c4" : {
            "pr2" : "0",
            "and2" : "0",
            "idfsp": "0",
            "marker": "0",
            "dfs" : "0",
            "dfs+soft": "0",
            "dfs+marker": "0",
        },
    },
    "travelling-salesman" : {
        "c1" : {
            "pr2" : "0",
            "and2" : "0",
            "idfsp": "0",
            "marker": "0",
            "dfs" : "0",
            "dfs+soft": "0",
            "dfs+marker": "0",
        },
        "c2" : {
            "pr2" : "0",
            "and2" : "0",
            "idfsp": "0",
            "marker": "0",
            "dfs" : "0",
            "dfs+soft": "0",
            "dfs+marker": "0",
        },
        "c3" : {
            "pr2" : "0",
            "and2" : "0",
            "idfsp": "0",
            "marker": "0",
            "dfs" : "0",
            "dfs+soft": "0",
            "dfs+marker": "0",
        },
        "c4" : {
            "pr2" : "0",
            "and2" : "0",
            "idfsp": "0",
            "marker": "0",
            "dfs" : "0",
            "dfs+soft": "0",
            "dfs+marker": "0",
        },
    },
    "rescue" : {
        "c1" : {
            "pr2" : "0",
            "and2" : "0",
            "idfsp": "0",
            "marker": "0",
            "dfs" : "0",
            "dfs+soft": "0",
            "dfs+marker": "0",
        },
        "c2" : {
            "pr2" : "0",
            "and2" : "0",
            "idfsp": "0",
            "marker": "0",
            "dfs" : "0",
            "dfs+soft": "0",
            "dfs+marker": "0",
        },
        "c3" : {
            "pr2" : "0",
            "and2" : "0",
            "idfsp": "0",
            "marker": "0",
            "dfs" : "0",
            "dfs+soft": "0",
            "dfs+marker": "0",
        },
        "c4" : {
            "pr2" : "0",
            "and2" : "0",
            "idfsp": "0",
            "marker": "0",
            "dfs" : "0",
            "dfs+soft": "0",
            "dfs+marker": "0",
        },
    },
    "kitchen" : {
        "c1" : {
            "pr2" : "1",
            "and2" : "0",
            "idfsp": "0",
            "marker": "0",
            "dfs" : "0",
            "dfs+soft": "0",
            "dfs+marker": "0",
        },
        "c2" : {
            "pr2" : "1",
            "and2" : "0",
            "idfsp": "0",
            "marker": "0",
            "dfs" : "0",
            "dfs+soft": "0",
            "dfs+marker": "0",
        },
        "c3" : {
            "pr2" : "1",
            "and2" : "0",
            "idfsp": "0",
            "marker": "0",
            "dfs" : "0",
            "dfs+soft": "0",
            "dfs+marker": "0",
        },
        "c4" : {
            "pr2" : "1",
            "and2" : "0",
            "idfsp": "0",
            "marker": "0",
            "dfs" : "0",
            "dfs+soft": "0",
            "dfs+marker": "0",
        },
    }
}

def update_pr2_cells(df, domain):
    path = "../Desktop/run-all-19-07-2024/pr2"
    final = "_2" if domain == "tireworld-spiky-2" else "_1"
    for instance in df:
        with open(f"{path}/pr2.{domain}__{instance}{final}.out") as f:
            if "Strong cyclic solution found." in f.read():
                df[instance]["pr2"] = "1"
    return df

def update_idfsp_cells(df, domain):
    path = "../Desktop/run-all-19-07-2024/idfsp"
    final = "_2" if domain == "tireworld-spiky-2" else "_1"
    for instance in df:
        with open(f"{path}/{domain},{instance}{final}.txt") as f:
            for line in f.readlines():
                if "Result: Policy successfully found." in line:
                    df[instance]["idfsp"] = "1"
                    break
    return df

def update_and2_cells(df, domain):
    path = "../Desktop/run-all-19-07-2024/and_ep"
    final = "_2" if domain == "tireworld-spiky-2" else "_1"
    for instance in df:
        with open(f"{path}/{domain}_{instance}{final}.txt") as f:
            if "Termination: Solved." in f.read():
                df[instance]["and2"] = "1"
    return df

def update_marker_cells(df, domain):
    path = f"../Desktop/run-all-19-07-2024/bfded/{domain}"
    final = "_2" if domain == "tireworld-spiky-2" else "_1"
    for instance in df:
        
        if  os.path.exists(path) and\
            os.path.exists(f"{path}/{instance}{final}") and\
            os.path.exists(f"{path}/{instance}{final}/dead-end/") and\
            os.path.exists(f"{path}/{instance}{final}/dead-end/metadata.txt") and\
            os.path.exists(f"{path}/{instance}{final}/dead-end/log.txt"):
            if "Metric,Count" in open(f"{path}/{instance}{final}/dead-end/metadata.txt").read() and\
                "Ended at" in open(f"{path}/{instance}{final}/dead-end/log.txt").read():
                df[instance]["marker"] = "1"
    return df

def update_dfs_cells(df, domain, dfs_type="dfs"):
    path = f"../Desktop/run-all-19-07-2024/{dfs_type}/{domain}"
    # print(path)
    final = "_2" if domain == "tireworld-spiky-2" else "_1"
    header = "solver,domain,problem,policy_heuristic,state_heuristic,number_of_samples,length,percentage_fsm,sample_generator,sample_treatment_class,percentage_timer,percentage_time_limit,percentage_memory_limit,walker,concrete_states_generator,regressor,termination,memory_usage,time,number_of_generated_policies,number_of_inserted_policies,number_of_removed_policies,number_of_expanded_policies,solution_length,number_of_lookups,number_of_states_generated_on_state_heuristic_table"
    for instance in df:
        if not os.path.exists(path):
            print(f"Path [{path}] does not exist"); continue
        
        if not os.path.exists(f"{path}/{instance}{final}"):
            print(f"Path [{path}/{instance}{final}] does not exist"); continue

        if not os.path.exists(f"{path}/{instance}{final}/results.csv"):
            print(f"Path [{path}/{instance}{final}/results.csv] does not exist"); continue
        
        header_found = False
        for line in open(f"{path}/{instance}{final}/results.csv").readlines():
            if header in line:
                header_found = True
                break
        
        if header_found:
            csv_df = pd.read_csv(f"{path}/{instance}{final}/results.csv")
            if not csv_df.empty:
                # check the first row on column termination if it is "optimal"
                if csv_df["termination"].iloc[0] == "optimal":
                    df[instance][dfs_type] = "1"

    return df


def send_correct_style_to_table(cell_value):
    if cell_value == "0":
        return f"\\experimentFailStyle"
    elif cell_value == "1":
        return f"\\experimentSuccessStyle"
    else:
        exit("Invalid cell value")


def write_combined_table(instances, output_path):
    with open(output_path, 'w') as f:
        def write_line(f, df, column_index, to_table_column_name):
            f.write(f"\\experimentHeaderStyle{{{to_table_column_name}}}")
            for instance in df:
                f.write(f" & {send_correct_style_to_table(df[instance][column_index])}")
            f.write("\\\\\n")

        f.write('\\begin{table}[t!]\n')
        f.write('\\centering\n')
        f.write('\\begin{tabular}{l|l|l|l|l}\n')

        # Write headers for each domain
        count = 0
        # for domain in sorted(instances.keys(), key=lambda x: x.lower()):
        for domain in ["rescue", "tireworld-spiky-2", "travelling-salesman", "sokoban", "kitchen"]:
            count += 1
            if count > 1:
                f.write("\\multicolumn{5}{c}{\\large } \\\\[-4pt]\n")
            f.write(f"\\multicolumn{{5}}{{c}}{{\\large \\textbf{{{domain.capitalize()}}}}} \\\\\n")
            f.write('\\toprule\n')
            df = instances[domain]
            header = "\\experimentHeaderStyle{Algorithm} & "
            for instance in df:
                header += f"\\experimentHeaderStyle{{{instance}}} & "
            header = header[:-3] + "\\\\\n"
            f.write(header)
            f.write('\\midrule\n')

            write_line(f, df, "pr2", "PR2")
            write_line(f, df, "and2", "AND$^{*}$EP")
            write_line(f, df, "idfsp", "IDFSP")
            f.write('\\midrule\n')
            write_line(f, df, "dfs", "GPM$_1$")
            write_line(f, df, "dfs+soft", "GPM$_2$ w/ D.DE")
            write_line(f, df, "dfs+marker", "GPM$_2$ w/ DE")
            f.write('\\midrule\n')
            write_line(f, df, "marker", "BFDED")
            if count < len(instances):
                f.write('\\midrule\n')

        f.write('\\bottomrule\n')
        f.write('\\end{tabular}\n')
        f.write('\\caption{Experimental analysis of four instances of each domain. (\\experimentSuccessStyle) indicates successful algorithm completion within time and memory constraints, while (\\experimentFailStyle) denotes failure to meet these limits.}\n')
        f.write('\\label{tab:experiments}\n')
        f.write('\\end{table}\n')

# sort domains for alphabetical order
for domain in instances:
    df = pd.DataFrame(instances[domain])
    df = update_pr2_cells(instances[domain], domain)
    df = update_and2_cells(instances[domain], domain)
    df = update_marker_cells(instances[domain], domain)
    df = update_idfsp_cells(instances[domain], domain)
    for dfs in ["dfs", "dfs+soft", "dfs+marker"]:
        df = update_dfs_cells(instances[domain], domain, dfs)
    # dataframe_to_latex_table(df, f"./tables/experiments-{domain}.tex")
write_combined_table(instances,  f"./tables/experiments.tex")