#include "./dead_end_neural_network.hpp"



torch::Tensor DeadEndNeuralNetwork::make_tensor(const long int &state_id) const
{
    State state;
    state.id = state_id;
    vec<double> bitvector_state = task.bitvector_representation_of_state(state);
    torch::Tensor tensor = torch::from_blob(bitvector_state.data(), bitvector_state.size(), options);
    return tensor.clone();
}

//void DeadEndNeuralNetwork::training(
//    const std::vector<long int> &states_ids,
//    const std::vector<double> &targets,
//    float clip_norm,
//    float train_ratio)
//{
//    std::cerr << "LOG::training::starting at " << get_elapsed_time() << std::endl;
//    std::cerr << "LOG::training::states_ids.size(): " << states_ids.size() << std::endl;
//    std::cerr << "LOG::training::targets.size(): " << targets.size() << std::endl;
//
//    int train_size = std::ceil(states_ids.size() * train_ratio);
//    int num_batches = std::max(static_cast<int>(std::ceil(train_size / batch_size)), 1);
//
//    for (int epoch = 0; epoch < epochs; epoch++)
//    {
//        this->train();
//        float total_train_loss = 0.0;
//        for (int i = 0; i < num_batches; i++)
//        {
//            std::cerr << "LOG::training::Epoch: " << epoch << "\tBatch: " << i << std::endl;
//            int start_index = i * batch_size;
//            int end_index = std::min(start_index + batch_size, train_size);
//
//            std::vector<torch::Tensor> states_tensors;
//            for (int j = start_index; j < end_index; j++)
//            {
//                states_tensors.push_back(make_tensor(states_ids[j]));
//            }
//            auto states_batch = torch::stack(states_tensors);
//            std::cerr << "LOG::training::states_batch.size(): " << states_batch.sizes() << std::endl;
//            std::cerr << "LOG::training::states_batch: " << states_batch << std::endl;
//            auto targets_batch = torch::from_blob(const_cast<double *>(targets.data()) + start_index, {end_index - start_index, 1}, this->options).clone();
//            std::cerr << "LOG::training::targets_batch.size(): " << targets_batch.sizes() << std::endl;
//            std::cerr << "LOG::training::targets_batch: " << targets_batch << std::endl;
//
//            this->optimizer->zero_grad();
//            auto output = this->forward(states_batch);
//            auto loss = torch::mse_loss(output, targets_batch);
//            loss.backward();
//
//            torch::nn::utils::clip_grad_norm_(this->parameters(), clip_norm);
//            this->optimizer->step();
//            total_train_loss += loss.item().toFloat();
//        }
//        this->eval();
//        float avg_train_loss = total_train_loss / num_batches;
//
//        torch::NoGradGuard no_grad;
//        std::vector<torch::Tensor> test_states_tensors;
//        for (int j = train_size; j < states_ids.size(); j++)
//        {
//            torch::Tensor state_tensor = make_tensor(states_ids[j]);
//            test_states_tensors.push_back(state_tensor);
//        }
//        auto test_states_tensor = torch::stack(test_states_tensors);
//        auto test_targets_tensor = torch::from_blob(targets.data() + train_size, {static_cast<long int>(states_ids.size() - static_cast<std::size_t>(train_size)), 1}, options).clone();
//
//        auto test_output = this->forward(test_states_tensor);
//        auto test_loss = torch::mse_loss(test_output, test_targets_tensor).item().toFloat();
//        std::cerr << "LOG::training::Epoch: " << epoch
//                  << "\tTraining Loss: " << avg_train_loss
//                  << "\tTest Loss: " << test_loss << std::endl;
//    }
//    std::cerr << "LOG::training::ending at " << get_elapsed_time() << std::endl;
//}

void DeadEndNeuralNetwork::training(
    const std::vector<long int> &states_ids,
    const std::vector<double> &targets,
    float clip_norm)
{
    int train_size = states_ids.size();
    int num_batches = std::max(static_cast<int>(std::ceil(train_size / batch_size)), 1);
    std::cout << "LOG::StateNetwork::train::states size : " << states_ids.size() << ", num batches: " << num_batches << std::endl;

    for (int epoch = 0; epoch < epochs; epoch++)
    {
        this->train();
        float total_train_loss = 0.0;
        for (int i = 0; i < num_batches; i++)
        {
            std::cerr << "LOG::StateNetwork::train::Epoch: " << epoch << ", Batch: " << num_batches << std::endl;
            int start_index = i * batch_size;
            int end_index = std::min(start_index + batch_size, train_size);

            vec<torch::Tensor> states_tensors = {};
            for (int j = start_index; j < end_index; j++)
            {
                states_tensors.push_back(make_tensor(states_ids[j]));
            }
            std::cerr << "LOG::StateNetwork::train::states_tensors.size(): " << states_tensors.size() << std::endl;
            auto states_batch = torch::stack(states_tensors);
            std::cerr << "LOG::StateNetwork::train::states_batch.size(): " << states_batch.sizes() << std::endl;
            std::cerr << "LOG::StateNetwork::train::states_batch: " << std::endl << states_batch << std::endl;
            auto targets_batch = torch::from_blob(const_cast<double*>(targets.data()) + start_index, {end_index - start_index, 1}, options).clone();
            std::cerr << "LOG::StateNetwork::train::targets_batch.size(): " << targets_batch.sizes() << std::endl;
            std::cerr << "LOG::StateNetwork::train::targets_batch: " << std::endl << targets_batch << std::endl;

            this->optimizer->zero_grad();
            auto output = forward(states_batch);
            std::cerr << "LOG::StateNetwork::train::output.size(): " << output.sizes() << std::endl;
            std::cerr << "LOG::StateNetwork::train::output: " << std::endl << output << std::endl;
            std::cerr << "LOG::StateNetwork::train::targets_batch.size(): " << targets_batch.sizes() << std::endl;
            auto loss = torch::mse_loss(output, targets_batch);
            std::cerr << "LOG::StateNetwork::train::loss: " << loss << std::endl;
            loss.backward();

            torch::nn::utils::clip_grad_norm_(this->parameters(), clip_norm);
            this->optimizer->step();
            total_train_loss += loss.item().toFloat();
            std::cerr << "LOG::StateNetwork::train::total_train_loss: " << total_train_loss << std::endl;
        }
        this->eval();
        float avg_train_loss = total_train_loss / num_batches;

        torch::NoGradGuard no_grad;
        vec<torch::Tensor> test_states_tensors = {};
        for (int j = 0; j < train_size; j++)
        {
            test_states_tensors.push_back(make_tensor(states_ids[j]));
        }
        auto test_states_tensor = torch::stack(test_states_tensors);
        std::cerr << "LOG::StateNetwork::train::test_states_tensor.size(): " << test_states_tensor.sizes() << std::endl;
        std::cerr << "LOG::StateNetwork::train::test_states_tensor: " << std::endl << test_states_tensor << std::endl;
        auto test_targets_tensor = torch::from_blob(const_cast<double*>(targets.data()) + train_size, {static_cast<long int>(states_ids.size() - static_cast<std::size_t>(train_size)), 1}, options).clone();
        std::cerr << "LOG::StateNetwork::train::test_targets_tensor.size(): " << test_targets_tensor.sizes() << std::endl;
        std::cerr << "LOG::StateNetwork::train::test_targets_tensor: " << std::endl << test_targets_tensor << std::endl;

        auto test_output = this->forward(test_states_tensor);
        auto test_loss = torch::mse_loss(test_output, test_targets_tensor).item().toFloat();
        std::cerr << "LOG::StateNetwork::train::Epoch: " << epoch
                  << "\tTraining Loss: " << avg_train_loss
                  << "\tTest Loss: " << test_loss << std::endl;
    }
}


double DeadEndNeuralNetwork::predict(const long int &state_id) const
{
    torch::Tensor input = make_tensor(state_id).unsqueeze(0);

    auto &non_constant_this = const_cast<DeadEndNeuralNetwork &>(*this);
    non_constant_this.eval();

    torch::Tensor res = non_constant_this.forward(input);

    double result = res.item<double>();
    return result;
}

void DeadEndNeuralNetwork::save_model(const std::string &file_path) const
{
    torch::serialize::OutputArchive archive;
    this->save(archive);
    archive.save_to(file_path);
}


void DeadEndNeuralNetwork::load_model(const std::string &file_path)
{
    torch::serialize::InputArchive archive;
    archive.load_from(file_path);
    this->load(archive);
}

torch::Tensor DeadEndNeuralNetwork::forward(torch::Tensor x)
{
    std::cerr << "LOG::forward::before linear: x.size(): " << x.sizes() << std::endl;
    x = torch::relu(this->linear1(x));
    std::cerr << "LOG::forward::after linear: x.size(): " << x.sizes() << std::endl;
    x = this->final_layer(x);
    std::cerr << "LOG::forward::after final layer: x.size(): " << x.sizes() << std::endl;
    return x;
}