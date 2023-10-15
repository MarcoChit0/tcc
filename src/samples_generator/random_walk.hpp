#pragma once
#include "../task.hpp"
#include "../state_heuristics/star.hpp"
#include "../task_solvers/and_star.hpp"
#include "../policy_heuristics/delta_nearest.hpp"
#include <random>
#include <time.h>

class RandomWalk
{
public:
    RandomWalk();

    vec<std::pair<State, int>> generate_samples(const Task &task, const int number_of_samples, const int length);
};