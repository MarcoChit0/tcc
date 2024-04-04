#include "sample_generator.hpp"

SampleGenerator::SampleGenerator(const Task &task, const State::Heuristic &state_heuristic, const int number_of_samples) : task(task), state_heuristic(state_heuristic), number_of_samples(number_of_samples) {}

void SampleGenerator::print_samples(set<Sample> samples) const
{
    std::cout << "state_id,h_nd,h_d" << std::endl;
    for (Sample sample : samples)
    {
        std::cout << sample.state().id << ",";
        std::cout << sample.non_deterministic_value() << ",";
        std::cout << sample.deterministic_value() << std::endl;
    }
}

Sample SampleGenerator::get_sample(State new_initial_state) const
{
    const State original_task_initial_state = this->task.initial_state();
    this->task.initial_state().id = new_initial_state.id;
    DeltaNearest delta_nearest = DeltaNearest(this->task, this->state_heuristic);
    set_timer();
    // TODO: receive task solver as parameter
    auto solver = AndStar(delta_nearest, this->state_heuristic, AndStar::DEFAULT);
    auto policy = solver.get_solution(this->task);
    unset_timer();
    int policy_size = 0;
    if(get_policy_type() == UNSOLVABLE_POLICY)
    {
        policy_size = INFTY;
    }
    else
    {
        policy_size = policy.size();
    }
    this->task.initial_state() = original_task_initial_state;
    return Sample(new_initial_state, policy_size, this->state_heuristic[new_initial_state], get_policy_type());
}
