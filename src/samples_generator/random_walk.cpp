#include "./random_walk.hpp"

RandomWalk::RandomWalk(Task task) : SamplesGenerator(task) {}

void RandomWalk::generate_samples()
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
    while (++generated_samples < number_of_samples)
    {
        State state = this->select_state(this->task.goal_condition(), h_star, &states_ids);
        SAMPLE sample = this->get_sample(state);
        samples.push_back(sample);
    }
    this->samples = samples;
}

vec<PartialState> RandomWalk::perform_random_walk(PartialState partial_state)
{
    vec<PartialState> partial_states_by_depth = vec<PartialState>{partial_state};
    for (int i = 0; i < random_walk_length; i++)
    {
        vec<PartialState> regressed_states = partial_state.get_regressed_partial_states(this->task.actions());
        if (not regressed_states.empty())
        {
            std::uniform_int_distribution<int> distribution(0, regressed_states.size() - 1);
            int random_index = distribution(rng);
            partial_state = regressed_states[random_index];
            partial_states_by_depth.push_back(partial_state);
        }
        else
        {
            break;
        }
    }
    return partial_states_by_depth;
}

State RandomWalk::select_state(PartialState partial_state_to_be_regressed, Star h_star, set<int64_t>* states_ids)
{
    State state;
    bool match = false;
    while (not match)
    {
        PartialState partial_state = partial_state_to_be_regressed;
        vec<PartialState> partial_states_by_depth = this->perform_random_walk(partial_state);
        while(partial_states_by_depth.size() <= 1) 
        {
            partial_states_by_depth = this->perform_random_walk(partial_state);
        }
        partial_state = partial_states_by_depth[partial_states_by_depth.size() - 1];
        vec<State> concrete_states = h_star.get_concrete_states_from_pdb(partial_state);
        if (not concrete_states.empty())
        {   
            std::uniform_int_distribution<int> distribution(0, concrete_states.size() - 1);
            int random_index = distribution(rng);
            state = concrete_states[random_index];
            if (not states_ids->contains(state.id))
            {
                states_ids->insert(state.id);
                match = true;
                break;
            }
        }
    }
    return state;
}