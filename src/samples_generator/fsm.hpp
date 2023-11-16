#pragma once

#include "sample_generator.hpp"
#include "random_walk.hpp"
#include "breadth_first_search.hpp"

class Fsm: virtual public SampleGenerator
{
    public:
        const int length;
        const float porcentage;
        const RandomWalk::Walker& walker;
        Fsm(const Task& task, const State::Heuristic &state_heuristic, const RandomWalk::Walker& walker, const int number_of_samples, const int length, const float porcentage);
        set<Sample> generate_samples() const;
};