#pragma once

#include "../lookup.hpp"
#include "../../neural_networks/state_neural_network.hpp"
#define NUMBER_OF_HIDDEN_UNITS 250
#define NUMBER_OF_EPOCHS 100
#define BATCH_SIZE 25

class NeuralNetworkLookUp : public LookUp
{
private:
    StateNetwork state_network;

public:
    const str model_path;
    NeuralNetworkLookUp(const Task &task, const State::Heuristic &state_heuristic, const SampleGenerator &samples_generator, const Sample::Treatment &sample_treatment);
    double operator[](const Policy &policy) const;
};