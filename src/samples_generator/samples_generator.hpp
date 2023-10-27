#pragma once
#include "../task.hpp"
#include "../state_heuristics/star.hpp"
#include "../task_solvers/and_star.hpp"
#include "../policy_heuristics/delta_nearest.hpp"
#define SAMPLE std::tuple<State, int, int, Policy>

class SamplesGenerator : public Object
{
    using Object::Object;
    public:
        Task task;
        vec<SAMPLE> samples;
        SamplesGenerator(Task task);
        virtual void generate_samples() = 0;
        void print_samples() const;
        SAMPLE get_sample(State new_initial_state);
};

extern int number_of_samples;