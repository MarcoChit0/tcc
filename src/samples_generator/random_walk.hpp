#pragma once
#include "sample_generator.hpp"

class RandomWalk: virtual public SampleGenerator
{
    public:
        class Walker;
        const int length;
        const str type;
        const Walker& walker;
        RandomWalk(const Task& task, const State::Heuristic &state_heuristic, const Walker& walker, const int number_of_samples, const int length);
        set<Sample> generate_samples() const;
        PartialState perform_random_walk(PartialState partial_state) const;
        State select_state(PartialState initial_partial_state, set<int64_t>* states_ids) const;
};

class RandomWalk::Walker
{
    public:
        virtual PartialState operator()( PartialState partial_state, const Task& task, const int length) const = 0;
};

class BackTracking : public RandomWalk::Walker
{
    public:
        PartialState operator()( PartialState partial_state, const Task& task, const int length) const;
};

class Stop : public RandomWalk::Walker
{
    public:
        PartialState operator()( PartialState partial_state, const Task& task, const int length) const;
};

class Restart : public RandomWalk::Walker
{
    public:
        PartialState operator()( PartialState partial_state, const Task& task, const int length) const;
};