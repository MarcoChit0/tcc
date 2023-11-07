#include "breadth_first_search.hpp"

BreadthFirstSearch::BreadthFirstSearch(const Task& task, const State::Heuristic &state_heuristic, int number_of_samples) : SamplesGenerator(task, state_heuristic, number_of_samples) {}

void BreadthFirstSearch::generate_samples()
{
    if (this->samples != vec<Sample>{})
    {
        return;
    }   
    if (this->state_heuristic[this->task.initial_state()] == +INFTY)
    {
        return;
    }
    BFSReturn bfs_return = this->bfs();
}

BreadthFirstSearch::BFSReturn BreadthFirstSearch::bfs()
{
    BreadthFirstSearch::BFSReturn bfs_return = BreadthFirstSearch::BFSReturn(set<PartialState>{}, set<State>{});
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
        for(PartialState regressed_state : partial_state.get_regressed_partial_states(this->task.actions()))
        {
            if (not visited.contains(regressed_state))
            {
                for(State concrete_state : this->state_heuristic.get_concrete_states(regressed_state))
                {
                    if(bfs_return.sampled.contains(concrete_state))
                    {
                        continue;
                    }
                    queue.push(regressed_state); // add partial state to bfs queue
                    bfs_return.update(regressed_state, concrete_state); // update bfs return
                    this->add_sample(concrete_state); // add sample to samples
                    if(++generated_samples >= this->number_of_samples)
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