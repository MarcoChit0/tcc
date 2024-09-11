import os

label_file_1 = "./misc/data/raw_results/test,v2024-09-09/gpm,delta-nearest,star,100,facts-over-effects-mean-over-actions-mean,0.2,fsm,keep,0.1,0.7,0.9,stop,all,action-proportionality,set/tireworld-truck/p12/star_pdb.txt" 
label_file_2 = "./misc/data/raw_results/test,v2024-09-09/gpm,delta-nearest,star,100,facts-over-effects-mean-over-actions-mean,0.2,fsm,keep,0.1,0.7,0.9,stop,all,action-proportionality,reachable/tireworld-truck/p12/star_pdb.txt"

map1 = {}
map2 = {}

with open(label_file_1, "r") as f:
    for line in f:
        line = line.strip().split(" -> ")
        map1[line[0]] = int(line[1])

with open(label_file_2, "r") as f:
    for line in f:
        line = line.strip().split(" -> ")
        map2[line[0]] = int(line[1])

print("--------------------")
for key in map1:
    if key not in map2:
        print(key, map1[key], "MISSING")
    elif map1[key] != map2[key]:
        print(key, map1[key], map2[key])
print("--------------------")
for key in map2:
    if key not in map1:
        print(key, map2[key], "MISSING")
    elif map1[key] != map2[key]:
        print(key, map1[key], map2[key])
print("--------------------")   