#pragma once

#include <torch/torch.h>
#include <iostream>
#include "../task.hpp"

class DeadEndNeuralNetwork : public torch::nn::Module
{
    public:
        void training(
            const std::vector<long int> &states_ids,
            const std::vector<double> &targets,
            float clip_norm = 1.0,
            float train_ratio = 0.8);
        double predict(const long int &state_id) const;
        void save_model(const std::string &file_path) const;
        void load_model(const std::string &file_path);
        torch::Tensor make_tensor(const long int &state_id) const;
        torch::Tensor forward(torch::Tensor x);
        DeadEndNeuralNetwork(
            const Task &task, 
            std::optional<int> hidden_size = std::nullopt, 
            std::optional<int> batch_size = std::nullopt, 
            std::optional<int> epochs = std::nullopt,
            std::optional<torch::TensorOptions> options = std::nullopt,
            std::optional<torch::optim::Optimizer*> optimizer = std::nullopt
            ) : 
            task(task),
            hidden_size(hidden_size.value_or(DeadEndNeuralNetwork::DEFAULT_HIDDEN_SIZE)),
            batch_size(batch_size.value_or(DeadEndNeuralNetwork::DEFAULT_BATCH_SIZE)),
            epochs(epochs.value_or(DeadEndNeuralNetwork::DEFAULT_EPOCHS)),
            linear1(register_module("linear1", torch::nn::Linear(task.bitset_size, this->hidden_size))),
            options(options.value_or(torch::TensorOptions().dtype(torch::kFloat64).device(torch::kCPU))),
            final_layer(register_module("final_layer", torch::nn::Linear(this->hidden_size, 1)))
        {
            // Tensorflow equivalent "kernel_initializer='he_normal'"
            torch::nn::init::kaiming_normal_(linear1->weight, 0.0, torch::kFanIn, torch::kReLU);
            torch::nn::init::kaiming_normal_(final_layer->weight, 0.0, torch::kFanIn, torch::kReLU);
            this->optimizer = optimizer.value_or(new torch::optim::Adam(this->parameters(), torch::optim::AdamOptions(1e-5)));
            this->to(torch::kFloat64);
        }

    protected:
        const Task &task;
        const int batch_size;
        const int epochs;
        const int hidden_size;
        torch::optim::Optimizer* optimizer;
        const torch::TensorOptions options;

    private:
        static const int DEFAULT_EPOCHS = 100;
        static const int DEFAULT_BATCH_SIZE = 32;
        static const int DEFAULT_HIDDEN_SIZE = 256;
        torch::nn::Linear linear1{nullptr};
        torch::nn::Linear final_layer{nullptr};
};