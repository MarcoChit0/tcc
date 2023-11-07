#pragma once

#include "samples_generator.hpp"
#include "random_walk.hpp"
#include "breadth_first_search.hpp"

class Fsm: virtual public SamplesGenerator
{
    public:
        int length;
        float porcentage;
        Fsm(const Task& task, const State::Heuristic &state_heuristic, int number_of_samples, int length, float porcentage);
        void generate_samples();
};