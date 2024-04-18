n = 4
json = {
    "city" : {},
    "state" : {},
}

for i in range(n):
    json["city"][f"city_{i}"] = [f"city_{j}" for j in range(n) if i != j]

for i in range(n):
    for j in range(n):
        