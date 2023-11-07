#include "samples_generator.hpp"

SamplesGenerator::SamplesGenerator(const Task& task, const State::Heuristic &state_heuristic, int number_of_samples) : task(task), state_heuristic(state_heuristic), number_of_samples(number_of_samples)
{
    this->samples = vec<Sample>{};
}

void SamplesGenerator::print_samples() const
{
    std::cout << "state_id,h_nd,h_d" << std::endl;
    for(Sample sample: this->samples)
    {
        std::cout << sample.state().id << ",";
        std::cout << sample.non_deterministic_value() << ",";
        std::cout << sample.deterministic_value() << std::endl;
    }
}

bool SamplesGenerator::add_sample(State new_initial_state)
{
    const State original_task_initial_state = this->task.initial_state();
    this->task.initial_state().id = new_initial_state.id;
    DeltaNearest delta_nearest = DeltaNearest(this->task, this->state_heuristic);
    Policy optimal_policy = AndStar(delta_nearest, this->state_heuristic).get_solution(this->task);
    this->task.initial_state() = original_task_initial_state;
    if(optimal_policy.size() == 0)
    {
        return false;
    }
    else
    {
        this->samples.push_back(Sample(new_initial_state, optimal_policy.size(), this->state_heuristic[new_initial_state]));        
        return true;
    }
}