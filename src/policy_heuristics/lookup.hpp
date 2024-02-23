#pragma once

#include "../policy.hpp"
#include "../samples_generator/sample_generator.hpp"
#include "delta_nearest.hpp"

#define SAMPLES_FILE_NAME "samples.csv"

class LookUp : public Policy::Heuristic
{
public:
    static map<int64_t, double> table_nd;
    const State::Heuristic &state_heuristic;
    static int number_of_lookups;
    const SampleGenerator& samples_generator;
    const Sample::Treatment& sample_treatment;
    

    LookUp(const Task &task, const State::Heuristic &state_heuristic, const SampleGenerator& samples_generator, const Sample::Treatment& sample_treatment);
    virtual double operator[](const Policy &policy) const = 0;
private:
    const str file_name;
};
