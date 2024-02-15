#include "state.hpp"

StateNetwork::StateNetwork(int input_size, int hidden_size)
    : linear1(register_module("linear1", torch::nn::Linear(input_size, hidden_size))),
      linear2(register_module("linear2", torch::nn::Linear(hidden_size, hidden_size))),
      residual1(register_module("residual1", torch::nn::Linear(hidden_size, hidden_size))),
      residual2(register_module("residual2", torch::nn::Linear(hidden_size, hidden_size))),
      final_layer(register_module("final_layer", torch::nn::Linear(hidden_size, 1))) /* output size = 1, because it only returns a float value representing the state's value */
{
}

torch::Tensor StateNetwork::forward(torch::Tensor x)
{
    auto identity = x;
    x = torch::relu(linear1->forward(x));
    x = torch::relu(linear2->forward(x));

    auto residual = torch::relu(residual1->forward(x));
    residual = torch::relu(residual2->forward(residual));

    x = torch::add(x, residual);
    x = torch::relu(x);
    x = final_layer->forward(x);

    return x;
}

/*
void train_model(Net& model, torch::optim::Optimizer& optimizer, size_t epochs, const std::string& model_path) {
    // Placeholder for your data loader
    // Assume you have a DataLoader class that handles your dataset

    for (size_t epoch = 0; epoch < epochs; ++epoch) {
        size_t batch_index = 0;
        // Iterate over data.
        for (auto& batch : data_loader) {
            auto data = batch.data;
            auto targets = batch.targets;

            optimizer.zero_grad();
            auto output = model->forward(data);
            auto loss = torch::mse_loss(output, targets);
            loss.backward();
            optimizer.step();

            if (++batch_index % 10 == 0) {
                std::cout << "Train Epoch: " << epoch << " [" << batch_index * data.size(0)
                          << "/" << data_loader.dataset().size() << "]\tLoss: " << loss.item<float>() << std::endl;
            }
        }
    }

    // Save the model
    torch::save(model, model_path);
}
*/