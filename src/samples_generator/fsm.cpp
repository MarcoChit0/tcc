#include "fsm.hpp"

Fsm::Fsm(const Task& task, const State::Heuristic &state_heuristic, const RandomWalk::Walker& walker, const int number_of_samples, const int length, const float porcentage) : SampleGenerator(task, state_heuristic, number_of_samples), walker(walker), length(length), porcentage(porcentage) {}

set<Sample> Fsm::generate_samples() const
{
    set<Sample> samples;
    if (not (this->state_heuristic[this->task.initial_state()] == +INFTY))
    {
        int number_of_samples_to_be_generated_by_rw = floor(this->number_of_samples*(1-this->porcentage));
        int number_of_samples_to_be_generated_by_bfs = ceil(this->number_of_samples*(this->porcentage));
        BreadthFirstSearch bfs_sample_generator = BreadthFirstSearch(this->task, this->state_heuristic, number_of_samples_to_be_generated_by_bfs);
        BreadthFirstSearch::BFSReturn bfs_return = bfs_sample_generator.bfs();
        set<int64_t> states_ids;
        for(Sample sample: bfs_return.samples)
        {
            states_ids.insert(sample.state().id);
            samples.insert(sample);
        }
        while (samples.size() < number_of_samples and enough_time() and enough_memory())
        {
            // todo: change this to randomly select bfs states
            for (PartialState partial_state : bfs_return.border)
            {
                Task new_task = this->task;
                const PartialState goal_condition = this->task.goal_condition();
                new_task.goal_condition() = partial_state;
                RandomWalk random_walk_sample_generator = RandomWalk(new_task, this->state_heuristic, this->walker, 1, this->length);
                State state = random_walk_sample_generator.select_state(partial_state, &states_ids);
                this->task.goal_condition() = goal_condition;
                Sample sample = this->get_sample(state);
                if(sample.is_valid())
                {
                    samples.insert(sample);
                }
                if (samples.size() >= number_of_samples or not enough_time() or not enough_memory())
                {
                    break;
                }
            }
        }
    }
    return samples;
}