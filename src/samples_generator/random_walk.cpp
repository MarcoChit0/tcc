#include "./random_walk.hpp"

RandomWalk::RandomWalk(const Task& task, const State::Heuristic &state_heuristic, int number_of_samples, int length) : SamplesGenerator(task, state_heuristic, number_of_samples), length(length) {}

void RandomWalk::generate_samples()
{
    if (this->samples != vec<Sample>{})
    {
        return;
    }
    if (this->state_heuristic[this->task.initial_state()] == +INFTY)
    {
        return;
    }
    set<int64_t> states_ids;
    int generated_samples = 0;
    while (generated_samples < this->number_of_samples)
    {
        State state = this->select_state(this->task.goal_condition(), &states_ids);
        if(this->add_sample(state))
        {
            generated_samples++;
        }
    }
}

vec<PartialState> RandomWalk::perform_random_walk(PartialState partial_state)
{
    vec<PartialState> partial_states_by_depth = vec<PartialState>{partial_state};
    for (int i = 0; i < this->length; i++)
    {
        vec<PartialState> regressed_states = this->task.get_regressed_partial_states(partial_state);
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

State RandomWalk::select_state(PartialState partial_state_to_be_regressed, set<int64_t>* states_ids)
{
    State state;
    bool match = false;
    while (not match)
    {
        PartialState partial_state = partial_state_to_be_regressed;
        vec<PartialState> partial_states_by_depth;
        do
        { partial_states_by_depth = this->perform_random_walk(partial_state); } 
        while (partial_states_by_depth.size() <= 1);
        
        partial_state = partial_states_by_depth[partial_states_by_depth.size() - 1];
        vec<State> concrete_states = this->state_heuristic.get_concrete_states(partial_state);
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