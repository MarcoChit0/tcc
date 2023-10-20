#pragma once
#include "samples_generator.hpp"

class RandomWalk: public SamplesGenerator
{
public:
    int length;
    RandomWalk(Task task, int number_of_samples, int length);
    void generate_samples();
};