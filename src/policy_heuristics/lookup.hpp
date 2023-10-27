#pragma once

#include "../policy.hpp"
#include "../samples_generator/random_walk.hpp"
#include "delta_nearest.hpp"
class LookUp : public Policy::Heuristic
{
public:
    static map<int64_t, int> table;
    const State::Heuristic &state_heuristic;
    static int number_of_lookups;
    SamplesGenerator *samples_generator;

    LookUp(const Task &task, const State::Heuristic &state_heuristic, SamplesGenerator *samples_generator);
    int operator[](const Policy &policy) const;
};
