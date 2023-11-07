#pragma once
#include "samples_generator.hpp"
#include <queue>

class BreadthFirstSearch: virtual public SamplesGenerator
{
public:
    class BFSReturn
    {
    public:
        set<State> sampled;
        set<PartialState> border;
        BFSReturn(set<PartialState> border, set<State> sampled) : sampled(sampled), border(border) {}
        void update(PartialState partial_state, State state)
        {
            sampled.insert(state);
            border.insert(partial_state);
        }
        void explored(PartialState partial_state)
        {
            border.erase(partial_state);
        }
    };
    BreadthFirstSearch(const Task& task, const State::Heuristic &state_heuristic, int number_of_samples);
    void generate_samples();
    BFSReturn bfs();
};

extern int breadth_first_search_depth;