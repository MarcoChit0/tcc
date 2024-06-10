#pragma once

#include <torch/torch.h>
#include <iostream>
#include "../task.hpp"

class DeadEndNeuralNetwork : public torch::nn::Module
{
    public:
        // TODO: curretly training method is not working as expected, due to difference on expect input and real input on neural network
        /*
            trying to solve the problem, I ended up with the following error:
            [ CPUDoubleType{1212,29} ]
            LOG::StateNetwork::train::test_targets_tensor.size(): [0, 1]
            LOG::StateNetwork::train::test_targets_tensor:
            [ CPUDoubleType{0,1} ]
            LOG::forward::before linear: x.size(): [1212, 29]
            LOG::forward::after linear: x.size(): [1212, 256]
            LOG::forward::after final layer: x.size(): [1212, 1]
            terminate called after throwing an instance of 'c10::Error'
              what():  The size of tensor a (1212) must match the size of tensor b (0) at non-singleton dimension 0
            Exception raised from infer_size_impl at ../aten/src/ATen/ExpandUtils.cpp:31 (most recent call first):
            frame #0: c10::Error::Error(c10::SourceLocation, std::string) + 0x57 (0x71ad12a7ab57 in /home/macsilva/libtorch/lib/libc10.so)
            frame #1: c10::detail::torchCheckFail(char const*, char const*, unsigned int, std::string const&) + 0x64 (0x71ad12a2ae8b in /home/macsilva/libtorch/lib/libc10.so)
            frame #2: at::infer_size_dimvector(c10::ArrayRef<long>, c10::ArrayRef<long>) + 0x3a4 (0x71acfcc71304 in /home/macsilva/libtorch/lib/libtorch_cpu.so)
            frame #3: at::TensorIteratorBase::compute_shape(at::TensorIteratorConfig const&) + 0xb0 (0x71acfcd1da70 in /home/macsilva/libtorch/lib/libtorch_cpu.so)
            frame #4: at::TensorIteratorBase::build(at::TensorIteratorConfig&) + 0x59 (0x71acfcd1ee29 in /home/macsilva/libtorch/lib/libtorch_cpu.so)
            frame #5: at::TensorIteratorBase::build_borrowing_binary_op(at::TensorBase const&, at::TensorBase const&, at::TensorBase const&) + 0xe9 (0x71acfcd1fe89 in /home/macsilva/libtorch/lib/libtorch_cpu.so)
            frame #6: at::meta::structured_mse_loss::meta(at::Tensor const&, at::Tensor const&, long) + 0x2e (0x71acfd1c304e in /home/macsilva/libtorch/lib/libtorch_cpu.so)
            frame #7: <unknown function> + 0x2ce3973 (0x71acfe0e3973 in /home/macsilva/libtorch/lib/libtorch_cpu.so)
            frame #8: <unknown function> + 0x2ce3a13 (0x71acfe0e3a13 in /home/macsilva/libtorch/lib/libtorch_cpu.so)
            frame #9: at::_ops::mse_loss::redispatch(c10::DispatchKeySet, at::Tensor const&, at::Tensor const&, long) + 0x7e (0x71acfda8dfbe in /home/macsilva/libtorch/lib/libtorch_cpu.so)
            frame #10: <unknown function> + 0x45c23e4 (0x71acff9c23e4 in /home/macsilva/libtorch/lib/libtorch_cpu.so)
            frame #11: <unknown function> + 0x45c2f06 (0x71acff9c2f06 in /home/macsilva/libtorch/lib/libtorch_cpu.so)
            frame #12: at::_ops::mse_loss::call(at::Tensor const&, at::Tensor const&, long) + 0x166 (0x71acfdad1786 in /home/macsilva/libtorch/lib/libtorch_cpu.so)
            frame #13: <unknown function> + 0x7a394 (0x5fe1c7873394 in ./build/and_star)
            frame #14: <unknown function> + 0x4cbe1 (0x5fe1c7845be1 in ./build/and_star)
            frame #15: <unknown function> + 0x7251f (0x5fe1c786b51f in ./build/and_star)
            frame #16: <unknown function> + 0x229f2 (0x5fe1c781b9f2 in ./build/and_star)
            frame #17: <unknown function> + 0x28150 (0x71acfb028150 in /lib/x86_64-linux-gnu/libc.so.6)
            frame #18: __libc_start_main + 0x89 (0x71acfb028209 in /lib/x86_64-linux-gnu/libc.so.6)
            frame #19: <unknown function> + 0x2d819 (0x5fe1c7826819 in ./build/and_star)
        */
        void training(
            const std::vector<long int> &states_ids,
            const std::vector<double> &targets,
            float clip_norm = 1.0);
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