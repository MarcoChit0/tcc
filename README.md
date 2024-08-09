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


## New benchmark

To explore the instances of the new FOND benchmark we're developing, please navigate to the `./new-benchmark/` directory.

If you wish to test these instances, you'll find them available in the `./res/benchmarks` directory. 


## Experiments

The data from our runs is available in the compresse file `.experiments.zip`.

## Algorithms

The implementations of GPM1, GPM2 w/D.DE, and GPM2 w/DE can be found in the `./src/task_solvers/and_star.cpp` file. All algorithms use the `DEPTH_FIRST_THEORETICAL` parameter for the comparator variable and employ the h* heuristic, located in `./src/state_heuristic/star.cpp`.

Additionally, GPM2 w/D.DE and GPM2 w/DE utilize dead-end information to refine their heuristic estimates:

For GPM2 w/D.DE, the dead-end information is sourced from `./src/dead_end_detectors/easy_reachable_dead_end_detector.cpp`.

For GPM2 w/DE, the dead-end information is sourced from `./src/dead_end_detectors/reachable_dead_end_detector.cpp`.

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