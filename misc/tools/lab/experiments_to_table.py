import pandas as pd
import os
instances = {
    "tireworld-spiky-2" : {
        "c1" : {
            "pr2" : "0",
            "and2" : "0",
            "marker": "0",
            "dfs" : "0",
            "dfs+soft": "0",
            "dfs+marker": "0",
        },
        "c2" : {
            "pr2" : "0",
            "and2" : "0",
            "marker": "0",
            "dfs" : "0",
            "dfs+soft": "0",
            "dfs+marker": "0",
        },
        "c3" : {
            "pr2" : "0",
            "and2" : "0",
            "marker": "0",
            "dfs" : "0",
            "dfs+soft": "0",
            "dfs+marker": "0",
        },
        "c4" : {
            "pr2" : "0",
            "and2" : "0",
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
            "marker": "0",
            "dfs" : "0",
            "dfs+soft": "0",
            "dfs+marker": "0",
        },
        "c2" : {
            "pr2" : "0",
            "and2" : "0",
            "marker": "0",
            "dfs" : "0",
            "dfs+soft": "0",
            "dfs+marker": "0",
        },
        "c3" : {
            "pr2" : "0",
            "and2" : "0",
            "marker": "0",
            "dfs" : "0",
            "dfs+soft": "0",
            "dfs+marker": "0",
        },
        "c4" : {
            "pr2" : "0",
            "and2" : "0",
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
            "marker": "0",
            "dfs" : "0",
            "dfs+soft": "0",
            "dfs+marker": "0",
        },
        "c2" : {
            "pr2" : "0",
            "and2" : "0",
            "marker": "0",
            "dfs" : "0",
            "dfs+soft": "0",
            "dfs+marker": "0",
        },
        "c3" : {
            "pr2" : "0",
            "and2" : "0",
            "marker": "0",
            "dfs" : "0",
            "dfs+soft": "0",
            "dfs+marker": "0",
        },
        "c4" : {
            "pr2" : "0",
            "and2" : "0",
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
            "marker": "0",
            "dfs" : "0",
            "dfs+soft": "0",
            "dfs+marker": "0",
        },
        "c2" : {
            "pr2" : "0",
            "and2" : "0",
            "marker": "0",
            "dfs" : "0",
            "dfs+soft": "0",
            "dfs+marker": "0",
        },
        "c3" : {
            "pr2" : "0",
            "and2" : "0",
            "marker": "0",
            "dfs" : "0",
            "dfs+soft": "0",
            "dfs+marker": "0",
        },
        "c4" : {
            "pr2" : "0",
            "and2" : "0",
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
            "marker": "0",
            "dfs" : "0",
            "dfs+soft": "0",
            "dfs+marker": "0",
        },
        "c2" : {
            "pr2" : "1",
            "and2" : "0",
            "marker": "0",
            "dfs" : "0",
            "dfs+soft": "0",
            "dfs+marker": "0",
        },
        "c3" : {
            "pr2" : "1",
            "and2" : "0",
            "marker": "0",
            "dfs" : "0",
            "dfs+soft": "0",
            "dfs+marker": "0",
        },
        "c4" : {
            "pr2" : "1",
            "and2" : "0",
            "marker": "0",
            "dfs" : "0",
            "dfs+soft": "0",
            "dfs+marker": "0",
        },
    }
}

def update_pr2_cells(df, domain):
    path = "../pr2/RESULTS"
    final = "_2" if domain == "tireworld-spiky-2" else "_1"
    for instance in df:
        with open(f"{path}/pr2.{domain}__{instance}{final}.out") as f:
            if "Strong cyclic solution found." in f.read():
                df[instance]["pr2"] = "1"
    return df

def update_and2_cells(df, domain):
    path = "../and-star-2/And-Star-Project/outputs"
    final = "_2" if domain == "tireworld-spiky-2" else "_1"
    for instance in df:
        with open(f"{path}/{domain}_{instance}{final}.txt") as f:
            if "Termination: Solved." in f.read():
                df[instance]["and2"] = "1"
    return df

def update_marker_cells(df, domain):
    path = f"../Desktop/run-all-02-07-2024/marker/{domain}"
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
    path = f"../Desktop/run-all-02-07-2024/{dfs_type}/{domain}"
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



def dataframe_to_latex_table(df, output_path):
    with open(output_path, 'w') as f:
        # f.write('\\begin{table}[h]\n')
        # f.write('\\centering\n')
        # f.write('\\begin{tabular}{|l|l|l|l|l|l|l|}\n')
        # f.write('\\hline\n')
        # f.write('\\experimentHeaderStyle{Ins} & \\experimentHeaderStyle{PR2} & \\experimentHeaderStyle{AND$^{*}$2} & \\experimentHeaderStyle{Marker} & \\experimentHeaderStyle{DFS} & \\experimentHeaderStyle{DFS+S} & \\experimentHeaderStyle{DFS+M} \\\\\n')
        # f.write('\\hline\n')
        # for instance in df:
        #     f.write(f"\\experimentInstanceStyle{{{instance}}} & {send_correct_style_to_table(df[instance]['pr2'])} & {send_correct_style_to_table(df[instance]['and2'])} & {send_correct_style_to_table(df[instance]['marker'])} & {send_correct_style_to_table(df[instance]['dfs'])} & {send_correct_style_to_table(df[instance]['dfs+soft'])} & {send_correct_style_to_table(df[instance]['dfs+marker'])} \\\\\n")
        # f.write('\\hline\n')
        # f.write('\\end{tabular}\n')
        # f.write('\\end{table}\n')
        def write_line(f, df, column_index, to_table_column_name):
            f.write(f"\\experimentHeaderStyle{{{to_table_column_name}}}")
            for instance in df:
                f.write(f" & {send_correct_style_to_table(df[instance][column_index])}")
            f.write("\\\\\n")

        f.write('\\begin{table}[h]\n')
        f.write('\\centering\n')
        f.write('\\begin{tabular}{|l|l|l|l|l|l|l|}\n')
        f.write('\\hline\n')
        header = "\\experimentHeaderStyle{Algorithm} & "
        for instance in df:
            header += f"\\experimentHeaderStyle{{{instance}}} & "
        header = header[:-3] + "\\\\\n"
        f.write(header)
        f.write('\\hline\n')

        write_line(f, df, "pr2", "PR2")
        write_line(f, df, "and2", "AND$^{*}$EP")
        write_line(f, df, "marker", "Marker")
        write_line(f, df, "dfs", "DFSND")
        write_line(f, df, "dfs+soft", "DFSND+Soft")
        write_line(f, df, "dfs+marker", "DFSND+Marker")
       
        f.write('\\hline\n')
        f.write('\\end{tabular}\n')
        f.write('\\end{table}\n')

for domain in instances:
    df = pd.DataFrame(instances[domain])
    df = update_pr2_cells(instances[domain], domain)
    df = update_and2_cells(instances[domain], domain)
    df = update_marker_cells(instances[domain], domain)
    for dfs in ["dfs", "dfs+soft", "dfs+marker"]:
        df = update_dfs_cells(instances[domain], domain, dfs)
    dataframe_to_latex_table(df, f"./tables/experiments-{domain}.tex")