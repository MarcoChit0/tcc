#include "union.hpp"

Union::Union(Task task) : SamplesGenerator(task)
{
    this->random_walk = new RandomWalk(task);
    this->breadth_first_search = new BreadthFirstSearch(task);
}

void Union::generate_samples()
{
    if (this->samples != vec<SAMPLE>{})
    {
        return;
    }
    int generated_samples = 0;
    vec<SAMPLE> samples;
    set<int64_t> states_ids;
    Star h_star = Star(this->task);
    if (h_star[this->task.initial_state()] == +INFTY)
    {
        return;
    }
    std::map<int, vec<PartialState>> partial_states_by_depth = this->breadth_first_search->bfs();
    vec<PartialState> depthest_partial_states = partial_states_by_depth[partial_states_by_depth.size() - 1];
    while (generated_samples < number_of_samples)
    {
        for (PartialState &partial_state : depthest_partial_states)
        {
            State state = this->random_walk->select_state(partial_state, h_star, &states_ids);
            SAMPLE sample = this->get_sample(state);
            samples.push_back(sample);
            if (++generated_samples >= number_of_samples)
            {
                break;
            }
        }
    }
    // TODO: check wheter it is possible to surpass the number of samples
    generated_samples = 0;
    int depths = partial_states_by_depth.size();
    for (int i = 0; i < depths and generated_samples < number_of_samples; i++)
    {
        for (PartialState &partial_state : partial_states_by_depth[i])
        {
            if(generated_samples >= number_of_samples)
            {
                break;
            }
            vec<State> states = h_star.get_concrete_states_from_pdb(partial_state); 
            for (State &state : states)
            {
                SAMPLE sample = this->get_sample(state);
                samples.push_back(sample);
                if (++generated_samples >= number_of_samples)
                {
                    break;
                }                
            }
        }
    }
    this->samples = samples;
}