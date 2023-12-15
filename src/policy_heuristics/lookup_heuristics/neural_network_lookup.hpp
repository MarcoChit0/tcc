#pragma onece

#include "../lookup.hpp"

class NeuralNetworkLookUp : public LookUp
{

public:
    NeuralNetworkLookUp(const Task &task, const State::Heuristic &state_heuristic, const SampleGenerator& samples_generator, const Sample::Treatment& sample_treatment, str file_name);
    double operator[](const Policy &policy) const;
    double consult_neural_network(const vec<State>& states) const;
};