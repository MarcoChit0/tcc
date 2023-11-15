#pragma once
#include "sample_generator.hpp"
#include <queue>

class BreadthFirstSearch: virtual public SampleGenerator
{
public:
    class BFSReturn
    {
    public:
        set<State> sampled;
        set<PartialState> border;
        set<Sample> samples;
        BFSReturn(set<PartialState> border, set<State> sampled, set<Sample> samples) : sampled(sampled), border(border), samples(samples) {}
        void update(PartialState partial_state, State state, Sample sample)
        {
            sampled.insert(state);
            border.insert(partial_state);
            samples.insert(sample);
        }
        void explored(PartialState partial_state)
        {
            border.erase(partial_state);
        }
    };
    BreadthFirstSearch(const Task& task, const State::Heuristic &state_heuristic, int number_of_samples);
    set<Sample> generate_samples() const;
    BFSReturn bfs() const;
};