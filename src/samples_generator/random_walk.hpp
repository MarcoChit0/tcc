#pragma once
#include "sample_generator.hpp"

class RandomWalk: virtual public SampleGenerator
{
public:
    const int length;
    RandomWalk(const Task& task, const State::Heuristic &state_heuristic, const int number_of_samples, const int length);
    set<Sample> generate_samples() const;
    PartialState perform_random_walk(PartialState partial_state) const;
    State select_state(PartialState initial_partial_state, set<int64_t>* states_ids) const;
};
