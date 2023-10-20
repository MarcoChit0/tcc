#include "breadth_first_search.hpp"

BreadthFirstSearch::BreadthFirstSearch(Task task, int number_of_samples, int depth) : SamplesGenerator(task, number_of_samples) 
{
    this->depth = depth;
}

void BreadthFirstSearch::generate_samples()
{
    int generated_samples = 0;
    vec<SAMPLE> samples = vec<SAMPLE>{};
    std::queue<PartialState> queue;
    set<int64_t> explored_partial_states;
    set<int64_t> sampled_states;
    std::map<int64_t, int> partial_states_depths = {{this->task.goal_condition().id , 0}};
    Star h_star = Star(this->task);

    if (this->samples.size() > 0)
    {
        return;
    }

    if (h_star[this->task.initial_state()] == +INFTY)
    {
        return;
    }

    queue.push(this->task.goal_condition());
    while (generated_samples <= this->number_of_samples and not queue.empty())
    {
        PartialState partial_state = queue.front();
        queue.pop();
        if (not explored_partial_states.contains(partial_state.id))
        {
            for (PartialState regressed_partial_state : partial_state.get_regressed_partial_states(this->task.actions()))
            {
                if (not partial_states_depths.contains(regressed_partial_state.id))
                {
                    partial_states_depths[regressed_partial_state.id] = 1 + partial_states_depths[partial_state.id];
                    queue.push(regressed_partial_state);
                }
            }
            explored_partial_states.insert(partial_state.id);
            if (partial_states_depths[partial_state.id] >= this->depth)
            {
                for (State state : h_star.get_concrete_states_from_pdb(partial_state))
                {
                    if (generated_samples <= this->number_of_samples and not sampled_states.contains(state.id))
                    {
                        samples.push_back(this->get_sample(state, h_star));
                        sampled_states.insert(state.id);
                        generated_samples++;
                    }
                    else
                    {
                        break;
                    }
                }                
            }

        }
    }
    this->samples = samples;
}