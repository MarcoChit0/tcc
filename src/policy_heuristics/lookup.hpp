#pragma once

#include "../policy.hpp"
#include "../samples_generator/sample_generator.hpp"
#include "delta_nearest.hpp"
class LookUp : public Policy::Heuristic
{
public:
    static map<int64_t, int> table;
    const State::Heuristic &state_heuristic;
    static int number_of_lookups;
    const SampleGenerator& samples_generator;
    const Sample::Treatment& sample_treatment;

    LookUp(const Task &task, const State::Heuristic &state_heuristic, const SampleGenerator& samples_generator, const Sample::Treatment& sample_treatment);
    int operator[](const Policy &policy) const;
};
