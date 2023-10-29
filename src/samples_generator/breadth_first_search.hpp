#pragma once
#include "samples_generator.hpp"
#include <queue>

class BreadthFirstSearch: virtual public SamplesGenerator
{
public:
    BreadthFirstSearch(Task task);
    void generate_samples();
    std::map<int, vec<PartialState>> bfs();
};

extern int breadth_first_search_depth;