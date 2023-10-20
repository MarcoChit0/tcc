#include "samples_generator.hpp"
#include <queue>

class BreadthFirstSearch: public SamplesGenerator
{
public:
    int depth;
    BreadthFirstSearch(Task task, int number_of_samples, int depth);
    void generate_samples();
};