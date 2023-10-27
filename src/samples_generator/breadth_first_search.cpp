#include "breadth_first_search.hpp"

BreadthFirstSearch::BreadthFirstSearch(Task task) : SamplesGenerator(task) {}

void BreadthFirstSearch::generate_samples()
{
    if (this->samples.size() > 0)
    {
        return;
    }    
    Star h_star = Star(this->task);
    if (h_star[this->task.initial_state()] == +INFTY)
    {
        return;
    }    
    int generated_samples = 0;
    vec<SAMPLE> samples = vec<SAMPLE>{};
    set<int64_t> sampled_states = set<int64_t>{};
    std::map<int, vec<PartialState>> partial_states_by_depth = this->bfs();
    for (auto &[depth, partial_states] : partial_states_by_depth)
    {
        for (PartialState partial_state : partial_states)
        {
            if (generated_samples >= number_of_samples)
            {
                break;
            }
            for (State state : h_star.get_concrete_states_from_pdb(partial_state))
            {
                if (generated_samples <= number_of_samples and not sampled_states.contains(state.id))
                {
                    samples.push_back(this->get_sample(state));
                    sampled_states.insert(state.id);
                    generated_samples++;
                }
                else
                {
                    break;
                }
            }
        }
        if (generated_samples >= number_of_samples)
        {
            break;
        }
    }
    this->samples = samples;
}

std::map<int, vec<PartialState>> BreadthFirstSearch::bfs()
{
    std::queue<PartialState> queue;
    set<int64_t> explored_partial_states;
    std::map<int64_t, int> partial_states_depths = {{this->task.goal_condition().id, 0}};
    std::map<int, vec<PartialState>> partial_states_by_depth = {{0, vec<PartialState>{this->task.goal_condition()}}};
    queue.push(this->task.goal_condition());
    while (not queue.empty())
    {
        PartialState partial_state = queue.front();
        queue.pop();
        if (not explored_partial_states.contains(partial_state.id) and partial_states_depths[partial_state.id] < breadth_first_search_depth)
        {
            for (PartialState regressed_partial_state : partial_state.get_regressed_partial_states(this->task.actions()))
            {
                if (not partial_states_depths.contains(regressed_partial_state.id))
                {
                    partial_states_depths[regressed_partial_state.id] = 1 + partial_states_depths[partial_state.id];
                    if (partial_states_by_depth.contains(partial_states_depths[regressed_partial_state.id]))
                    {
                        partial_states_by_depth[partial_states_depths[regressed_partial_state.id]].push_back(regressed_partial_state);
                    }
                    else
                    {
                        partial_states_by_depth[partial_states_depths[regressed_partial_state.id]] = vec<PartialState>{regressed_partial_state};
                    }
                    queue.push(regressed_partial_state);
                }
            }
            explored_partial_states.insert(partial_state.id);
        }
    }
    return partial_states_by_depth;
}