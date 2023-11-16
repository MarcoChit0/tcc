#include "./random_walk.hpp"

RandomWalk::RandomWalk(const Task& task, const State::Heuristic &state_heuristic, const Walker& walker, const int number_of_samples, const int length) : SampleGenerator(task, state_heuristic, number_of_samples), length(length), walker(walker) {}

set<Sample> RandomWalk::generate_samples() const
{
    set<Sample> samples = set<Sample>{};
    if (not (this->state_heuristic[this->task.initial_state()] == +INFTY))
    {
        set<int64_t> states_ids;
        while (samples.size() < this->number_of_samples and enough_memory() and enough_time())
        {
            State state = this->select_state(this->task.goal_condition(), &states_ids);
            if(enough_memory() and enough_time())
            {
                Sample sample = this->get_sample(state);
                if(not sample.is_none())
                {
                    samples.insert(sample);
                }                
            }
        }
    }
    return samples;
}

PartialState RandomWalk::perform_random_walk(PartialState partial_state) const
{
    return this->walker(partial_state, this->task, this->length);
}

State RandomWalk::select_state(PartialState partial_state_to_be_regressed, set<int64_t>* states_ids) const
{
    State state;
    bool match = false;
    while (not match)
    {
        PartialState partial_state = partial_state_to_be_regressed;
        do
        { partial_state = this->perform_random_walk(partial_state_to_be_regressed); } 
        while (partial_state == partial_state_to_be_regressed);
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

PartialState Stop::operator()(PartialState partial_state, const Task& task, const int length) const
{
    for (int i = 0; i < length; i++)
    {
        vec<PartialState> regressed_states = task.get_regressed_partial_states(partial_state);
        if (not regressed_states.empty())
        {
            std::uniform_int_distribution<int> distribution(0, regressed_states.size() - 1);
            int random_index = distribution(rng);
            partial_state = regressed_states[random_index];
        }
        else
        {
            break;
        }
    }
    return partial_state;
}