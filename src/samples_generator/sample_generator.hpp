#pragma once
#include "sample.hpp"
#include "../task.hpp"
#include "../state_heuristics/star.hpp"
#include "../task_solvers/and_star.hpp"
#include "../policy_heuristics/delta_nearest.hpp"

class SampleGenerator
{
    public:
        const Task& task;
        const State::Heuristic &state_heuristic;
        const int number_of_samples;
        
        SampleGenerator(const Task& task, const State::Heuristic &state_heuristic, const int number_of_samples);
        virtual set<Sample> generate_samples() const = 0;
        void print_samples(set<Sample> samples) const;
        Sample get_sample(State new_initial_state) const;
};