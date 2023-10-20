#include "samples_generator.hpp"

SamplesGenerator::SamplesGenerator(Task task, int number_of_samples)
{
    this->task = task;
    this->number_of_samples = number_of_samples;
    this->samples = vec<SAMPLE>{};
}

void SamplesGenerator::print_samples() const
{
    std::cout << "state_id,h_nd,h_d" << std::endl;
    for(auto sample: this->samples)
    {
        std::cout <<std::get<0>(sample).id << ",";
        std::cout <<std::get<1>(sample) << ",";
        std::cout <<std::get<2>(sample) << std::endl;
    }
}

SAMPLE SamplesGenerator::get_sample(State new_initial_state, const State::Heuristic& state_heuristic)
{
    Task new_task = this->task;
    new_task.initial_state().id = new_initial_state.id;
    DeltaNearest delta_nearest = DeltaNearest(new_task, state_heuristic);
    Policy optimal_policy = AndStar(delta_nearest, state_heuristic).get_solution(new_task);
    return std::make_tuple(new_initial_state, optimal_policy.size(), state_heuristic[new_initial_state]);
}