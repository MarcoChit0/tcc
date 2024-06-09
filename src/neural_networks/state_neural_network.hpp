#pragma once

#include <torch/torch.h>
#include <iostream>
#include "../task.hpp"

class StateNetwork : public torch::nn::Module
{
public:
    StateNetwork(const Task &task, int hidden_size);
    torch::Tensor forward(torch::Tensor x);
    double predict(const long int &state_id) const;
    torch::Tensor make_tensor(const long int &state_id) const;
    void training(torch::optim::Optimizer &optimizer, const vec<long int>& states_ids, vec<double> targets, int epochs, int batch_size);

private:
    const Task &task;
    torch::nn::Linear linear1;
    torch::nn::Linear linear2;
    torch::nn::Linear residual1;
    torch::nn::Linear residual2;
    torch::nn::Linear final_layer;
    torch::nn::BatchNorm1d batch_norm_linear1;
    torch::nn::BatchNorm1d batch_norm_linear2;
    torch::nn::BatchNorm1d batch_norm_residual1;
    torch::nn::BatchNorm1d batch_norm_residual2;
    torch::TensorOptions options;
};