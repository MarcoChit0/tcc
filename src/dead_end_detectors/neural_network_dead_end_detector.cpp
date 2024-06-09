#include "./neural_network_dead_end_detector.hpp"

void NeuralNetworkDeadEndDetector::label_states(const bool save_metadata)
{
    std::cerr << "LOG::NeuralNetworkDeadEndDetector::label_states::starting at " << get_elapsed_time() << std::endl;
    this->set_labeled_states(this->dead_end_detector->get_labeled_states());
    std::vector<int64_t> states_ids;
    std::vector<double> targets;
    states_ids.reserve(this->labeled_states.size());
    targets.reserve(this->labeled_states.size());
    std::cerr << "AAAAAAAA" << std::endl;
    for (const auto &pair : this->labeled_states)
    {
        states_ids.push_back(pair.first);
        // TODO: check if that is ok
        if (pair.second == ALIVE)
        {
            targets.push_back(0.0f);
        }
        else
        {
            targets.push_back(1.0f);
        }
    }
    std::cerr << "BBBBBBBB" << std::endl;
    // TODO: add time limit to the training.
    // time_training = time_limit - time_dead_end_detector
    // auto optimizer = torch::optim::Adam(param, torch::optim::AdamOptions(1e-5));
    std::cerr << "LOG::NeuralNetworkDeadEndDetector::label_states::training at " << get_elapsed_time() << std::endl;
    this->neural_network.training(states_ids, targets);
    std::cerr << "LOG::NeuralNetworkDeadEndDetector::label_states::trained at " << get_elapsed_time() << std::endl;
    std::cerr << "LOG::NeuralNetworkDeadEndDetector::label_states::ending at " << get_elapsed_time() << std::endl;
}

void NeuralNetworkDeadEndDetector::save_labeled_states() const
{
    this->neural_network.save_model(this->neural_network_dir + std::string(NEURAL_NETWORK_MODEL_WEIGHTS_FILE));
}

void NeuralNetworkDeadEndDetector::load_labeled_states()
{
    this->neural_network.load_model(this->neural_network_dir + std::string(NEURAL_NETWORK_MODEL_WEIGHTS_FILE));
}

double NeuralNetworkDeadEndDetector::is_deadend(const State &state) const
{
    double predicted_value = this->neural_network.predict(state.id);
    std::cerr << "LOG::NeuralNetworkDeadEndDetector::is_deadend::predicted value " << predicted_value;
    auto dead_end_detector_value = state_label_to_string.at(this->labeled_states[state.id]);
    std::cerr << " of " << dead_end_detector_value << std::endl;
    return predicted_value;
}

