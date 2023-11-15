#include "breadth_first_search.hpp"

BreadthFirstSearch::BreadthFirstSearch(const Task& task, const State::Heuristic &state_heuristic, const int number_of_samples) : SampleGenerator(task, state_heuristic, number_of_samples) {}

set<Sample> BreadthFirstSearch::generate_samples() const
{
    if (not (this->state_heuristic[this->task.initial_state()] == +INFTY))
    {
        return this->bfs().samples;  
    }
    else
    {
        return set<Sample>{};
    }
}

BreadthFirstSearch::BFSReturn BreadthFirstSearch::bfs() const
{
    BreadthFirstSearch::BFSReturn bfs_return = BreadthFirstSearch::BFSReturn(set<PartialState>{}, set<State>{}, set<Sample>{});
    set<PartialState> visited = set<PartialState>{};
    std::queue<PartialState> queue; 
    queue.push(this->task.goal_condition());
    int generated_samples = 0;
    while (not queue.empty())
    {
        PartialState partial_state = queue.front();
        queue.pop();
        if (visited.contains(partial_state))
        {
            continue;
        }
        visited.insert(partial_state);
        bfs_return.explored(partial_state);
        for(PartialState regressed_state : this->task.get_regressed_partial_states(partial_state))
        {
            if (not visited.contains(regressed_state))
            {
                for(State concrete_state : this->state_heuristic.get_concrete_states(regressed_state))
                {
                    if(bfs_return.sampled.contains(concrete_state))
                    {
                        continue;
                    }
                    queue.push(regressed_state);
                    Sample sample = this->get_sample(concrete_state);
                    if(not sample.is_none())
                    {
                        bfs_return.update(regressed_state, concrete_state, sample);
                    }
                    if(bfs_return.samples.size() >= this->number_of_samples or not enough_memory() or not enough_time())
                    {
                        return bfs_return;
                    }
                    else
                    {
                        break;
                    }
                }
                
            }
        }
    }
    return bfs_return;
}