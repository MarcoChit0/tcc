#pragma once
#include "samples_generator.hpp"

class RandomWalk: virtual public SamplesGenerator
{
public:
    int length;
    RandomWalk(const Task& task, const State::Heuristic &state_heuristic, int number_of_samples, int length);
    void generate_samples();
    vec<PartialState> perform_random_walk(PartialState partial_state);
    State select_state(PartialState initial_partial_state, set<int64_t>* states_ids);
};

extern int random_walk_length;
