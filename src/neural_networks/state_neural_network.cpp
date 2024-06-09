#include "./state_neural_network.hpp"

StateNetwork::StateNetwork(const Task &task, int hidden_size)
    : task(task),
      linear1(register_module("linear1", torch::nn::Linear(task.bitset_size, hidden_size))),
      linear2(register_module("linear2", torch::nn::Linear(hidden_size, hidden_size))),
      residual1(register_module("residual1", torch::nn::Linear(hidden_size, hidden_size))),
      residual2(register_module("residual2", torch::nn::Linear(hidden_size, hidden_size))),
      final_layer(register_module("final_layer", torch::nn::Linear(hidden_size, 1))),
      batch_norm_linear1(register_module("batch_norm_linear1", torch::nn::BatchNorm1d(hidden_size))),
      batch_norm_linear2(register_module("batch_norm_linear2", torch::nn::BatchNorm1d(hidden_size))),
      batch_norm_residual1(register_module("batch_norm_residual1", torch::nn::BatchNorm1d(hidden_size))),
      batch_norm_residual2(register_module("batch_norm_residual2", torch::nn::BatchNorm1d(hidden_size)))
{
    // TODO: send device into the constructor
    // Tensorflow equivalent "kernel_initializer='he_normal'"
    torch::nn::init::kaiming_normal_(linear1->weight, 0.0, torch::kFanIn, torch::kReLU);
    torch::nn::init::kaiming_normal_(linear2->weight, 0.0, torch::kFanIn, torch::kReLU);
    torch::nn::init::kaiming_normal_(residual1->weight, 0.0, torch::kFanIn, torch::kReLU);
    torch::nn::init::kaiming_normal_(residual2->weight, 0.0, torch::kFanIn, torch::kReLU);
    torch::nn::init::kaiming_normal_(final_layer->weight, 0.0, torch::kFanIn, torch::kReLU);
    options = torch::TensorOptions().dtype(torch::kFloat64).device(torch::kCPU);
    this->to(torch::kFloat64);
}

torch::Tensor StateNetwork::forward(torch::Tensor x)
{
    x = torch::relu(batch_norm_linear1(linear1(x)));
    x = torch::relu(batch_norm_linear2(linear2(x)));
    auto identity = x;
    x = torch::relu(batch_norm_residual1(residual1(x)));
    x = torch::relu(batch_norm_residual2(residual2(x)));
    x = torch::add(x, identity);
    x = final_layer(x);
    return x;
}

torch::Tensor StateNetwork::make_tensor(const long int &state_id) const
{
    State state;
    state.id = state_id;
    vec<double> bitvector_state = task.bitvector_representation_of_state(state);
    torch::Tensor tensor = torch::from_blob(bitvector_state.data(), bitvector_state.size(), options);
    return tensor.clone();
}

void StateNetwork::training(torch::optim::Optimizer &optimizer, const vec<long int> &states_ids, vec<double> targets, int epochs, int batch_size)
{
    int train_size = std::ceil(states_ids.size() * 0.8);
    int num_batches = std::max(static_cast<int>(std::ceil(train_size / batch_size)), 1);
    std::cout << "LOG::StateNetwork::train::states size : " << states_ids.size() << std::endl;

    for (int epoch = 0; epoch < epochs; epoch++)
    {
        this->train();
        float total_train_loss = 0.0;
        for (int i = 0; i < num_batches; i++)
        {
            int start_index = i * batch_size;
            int end_index = std::min(start_index + batch_size, train_size);

            vec<torch::Tensor> states_tensors = {};
            for (int j = start_index; j < end_index; j++)
            {
                torch::Tensor state_tensor = make_tensor(states_ids[j]);
                states_tensors.push_back(state_tensor);
            }
            auto states_batch = torch::stack(states_tensors);
            auto targets_batch = torch::from_blob(targets.data() + start_index, {end_index - start_index, 1}, options).clone();

            optimizer.zero_grad();
            auto output = forward(states_batch);
            auto loss = torch::mse_loss(output, targets_batch);
            loss.backward();

            torch::nn::utils::clip_grad_norm_(this->parameters(), 1.0);
            optimizer.step();
            total_train_loss += loss.item().toFloat();
        }
        this->eval();
        float avg_train_loss = total_train_loss / num_batches;

        torch::NoGradGuard no_grad;
        vec<torch::Tensor> test_states_tensors = {};
        for (int j = train_size; j < states_ids.size(); j++)
        {
            torch::Tensor state_tensor = make_tensor(states_ids[j]);
            test_states_tensors.push_back(state_tensor);
        }
        auto test_states_tensor = torch::stack(test_states_tensors);
        auto test_targets_tensor = torch::from_blob(targets.data() + train_size, {static_cast<long int>(states_ids.size() - static_cast<std::size_t>(train_size)), 1}, options).clone();

        auto test_output = this->forward(test_states_tensor);
        auto test_loss = torch::mse_loss(test_output, test_targets_tensor).item().toFloat();
        std::cerr << "LOG::StateNetwork::train::Epoch: " << epoch
                  << "\tTraining Loss: " << avg_train_loss
                  << "\tTest Loss: " << test_loss << std::endl;
    }
}

double StateNetwork::predict(const long int &state_id) const
{

    torch::Tensor input = make_tensor(state_id).unsqueeze(0);

    auto &non_constant_this = const_cast<StateNetwork &>(*this);
    non_constant_this.eval();

    torch::Tensor output = non_constant_this.forward(input);

    double result = output.item<double>();
    return result;
}