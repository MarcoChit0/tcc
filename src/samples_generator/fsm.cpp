#include "fsm.hpp"

Fsm::Fsm(const Task& task, const State::Heuristic &state_heuristic, int number_of_samples, int length, float porcentage) : SamplesGenerator(task, state_heuristic, number_of_samples), length(length), porcentage(porcentage) {}

void Fsm::generate_samples()
{
    if (this->samples != vec<Sample>{})
    {
        return;
    }
    if (this->state_heuristic[this->task.initial_state()] == +INFTY)
    {
        return;
    }
    int number_of_samples_to_be_generated_by_rw = floor(this->number_of_samples*(1-this->porcentage));
    int number_of_samples_to_be_generated_by_bfs = ceil(this->number_of_samples*(this->porcentage));
    BreadthFirstSearch bfs_sample_generator = BreadthFirstSearch(this->task, this->state_heuristic, number_of_samples_to_be_generated_by_bfs);
    BreadthFirstSearch::BFSReturn bfs_return = bfs_sample_generator.bfs();
    int number_of_generated_samples_by_rw = 0;
    set<int64_t> states_ids;
    for(State state : bfs_return.sampled)
    {
        states_ids.insert(state.id);
    }
    for(Sample bfs_sample : bfs_sample_generator.samples)
    {
        this->samples.push_back(bfs_sample);
    }
    while (number_of_generated_samples_by_rw < number_of_samples_to_be_generated_by_rw)
    {
        for (PartialState partial_state : bfs_return.border)
        {
            Task new_task = this->task;
            const PartialState goal_condition = this->task.goal_condition();
            new_task.goal_condition() = partial_state;
            RandomWalk random_walk_sample_generator = RandomWalk(new_task, this->state_heuristic, number_of_samples_to_be_generated_by_rw, this->length);
            State state = random_walk_sample_generator.select_state(partial_state, &states_ids);
            this->task.goal_condition() = goal_condition;
            if(this->add_sample(state))
            {
                number_of_generated_samples_by_rw++;
            }
            if (number_of_generated_samples_by_rw >= number_of_samples)
            {
                break;
            }
        }
    }
}