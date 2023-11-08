#pragma once
#include "sample.hpp"
#include "../task.hpp"
#include "../state_heuristics/star.hpp"
#include "../task_solvers/and_star.hpp"
#include "../policy_heuristics/delta_nearest.hpp"

class SamplesGenerator
{
    public:
        vec<Sample> samples;
        const Task& task;
        const State::Heuristic &state_heuristic;
        int number_of_samples;
        
        SamplesGenerator(const Task& task, const State::Heuristic &state_heuristic, int number_of_samples);
        virtual void generate_samples() = 0;
        void print_samples() const;
        bool add_sample(State new_initial_state);
};

extern int number_of_samples;