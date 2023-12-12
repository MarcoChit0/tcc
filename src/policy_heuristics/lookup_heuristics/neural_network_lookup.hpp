#pragma onece

#include "../lookup.hpp"

class NeuralNetworkLookUp : public LookUp
{

public:
    NeuralNetworkLookUp(const Task &task, const State::Heuristic &state_heuristic, const SampleGenerator& samples_generator, const Sample::Treatment& sample_treatment, str file_name);
    int operator[](const Policy &policy) const;
    int consult_neural_network(const vec<State>& states) const;
};