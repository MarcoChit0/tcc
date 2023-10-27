#include "samples_generator.hpp"

SamplesGenerator::SamplesGenerator(Task task)
{
    this->task = task;
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

SAMPLE SamplesGenerator::get_sample(State new_initial_state)
{
    const State original_task_initial_state = this->task.initial_state();
    this->task.initial_state().id = new_initial_state.id;
    Star h_star = Star(this->task);
    DeltaNearest delta_nearest = DeltaNearest(this->task, h_star);
    Policy optimal_policy = AndStar(delta_nearest, h_star).get_solution(this->task);
    this->task.initial_state() = original_task_initial_state;
    return std::make_tuple(new_initial_state, optimal_policy.size(), h_star[new_initial_state], optimal_policy);
}