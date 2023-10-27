#pragma once
#include "samples_generator.hpp"

class RandomWalk: public SamplesGenerator
{
public:
    RandomWalk(Task task);
    void generate_samples();
    vec<PartialState> perform_random_walk(PartialState partial_state);
    State select_state(PartialState initial_partial_state, Star h_star, set<int64_t>* states_ids);
};

extern int random_walk_length;
