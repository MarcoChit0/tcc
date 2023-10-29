#pragma once

#include "samples_generator.hpp"
#include "random_walk.hpp"
#include "breadth_first_search.hpp"

class Union: virtual public SamplesGenerator
{
    public:
        BreadthFirstSearch* breadth_first_search;
        RandomWalk* random_walk;
        Union(Task task);
        void generate_samples();
        void set_samples(vec<SAMPLE> random_walk_samples, vec<SAMPLE> breadth_first_search_samples);
        vec<SAMPLE> get_samples();
};