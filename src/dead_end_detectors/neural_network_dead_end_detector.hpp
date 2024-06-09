#pragma once

#include "dead_end_detector.hpp"
#include "../neural_networks/dead_end_neural_network.hpp"

#define NEURAL_NETWORK_MODEL_WEIGHTS_FILE "model_weights.pt"
#define NEURAL_NETWORK_DIRECTORY "neural_network/"

class NeuralNetworkDeadEndDetector : public DeadEndDetector
{
protected:
    const std::shared_ptr<DeadEndDetector> &dead_end_detector;
    DeadEndNeuralNetwork neural_network;
    const opt<int> &time_limit_seconds;
    const str neural_network_dir = this->dead_end_directory + std::string(NEURAL_NETWORK_DIRECTORY);

public:
    NeuralNetworkDeadEndDetector(
        const Task &task,
        std::shared_ptr<DeadEndDetector> &dead_end_detector,
        DeadEndNeuralNetwork neural_network,
        const opt<int> &time_limit_seconds = std::nullopt) : DeadEndDetector(task),
                                                             dead_end_detector(dead_end_detector),
                                                             neural_network(neural_network),
                                                             time_limit_seconds(time_limit_seconds)
    {
        if (not directory_created_successfully(std::string(DEAD_END_DIR) + std::string(NEURAL_NETWORK_DIRECTORY)))
        {
            throw std::runtime_error("LOG::DeadEndDetector::DeadEndDetector::directory not created");
        }
    }
    double is_deadend(const State &state) const;
    void label_states(const bool save_metadata) override;
    void save_labeled_states() const override;
    void load_labeled_states() override;
};