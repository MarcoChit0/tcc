#pragma once

#include <torch/torch.h>
#include <iostream>

class StateNetwork : public torch::nn::Module
{
    public:
        StateNetwork(int input_size, int hidden_size);
        torch::Tensor forward(torch::Tensor x);
    private:
        torch::nn::Linear linear1;
        torch::nn::Linear linear2;
        torch::nn::Linear residual1;
        torch::nn::Linear residual2;
        torch::nn::Linear final_layer;
};

void train_state_network(StateNetwork &state_network, torch::optim::Optimizer &optimizer, torch::Tensor &states, torch::Tensor &values, int epochs, int batch_size, int verbose = 0);