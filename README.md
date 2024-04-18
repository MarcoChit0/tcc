# AND\* Project

**AND\* is an uncomplicated FOND planning algorithm with strong theoretical guarantees**.

Messa and Pereira, *"A Best-First Search Algorithm for FOND Planning and Heuristic Functions to Optimize Decompressed Solution Size"*, ICAPS 2023.

---

This project version was mainly tested in **Linux Mint 21.2**.

You will need **[Boost](https://www.boost.org/)** and **[GMP](https://gmplib.org/)**.

*Note:* A newer version of AND* Project might be available at **[GitHub](https://github.com/Frederico-Messa/And-Star-Project)**.

---

## Build:
```
conda env create -f environment.yml
conda activate and-star
bash build.sh
```

## Run:
```
python3 ./misc/tools/lab/experiment_runner.py
```

The results will appear in `./misc/data/raw_results` directory.

Create `./white-list.txt` to define which instances will be used. (one `<domain-label,instance-label>` per line).

## Problems
### Problem
```
ModuleNotFoundError: No module named 'res'
```
### Solution
```
export PYTHONPATH="${PYTHONPATH}:$(pwd)"
```
### Problem
```
CMake Error at CMakeLists.txt:17 (find_package): By not providing "FindTorch.cmake" in CMAKE_MODULE_PATH this project has asked CMake to find a package configuration file provided by "Torch", but CMake did not find one.
```
### Solution
```
```