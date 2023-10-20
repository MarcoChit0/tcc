#include "./random_walk.hpp"

RandomWalk::RandomWalk(Task task, int number_of_samples, int length) : SamplesGenerator(task, number_of_samples)
{
    this->length = length;
}

void RandomWalk::generate_samples()
{
    int generated_samples = 0;
    vec<SAMPLE> samples;
    set<int64_t> states_ids;
    Star h_star = Star(this->task);
    if (this->samples != vec<SAMPLE>{})
    {
        return;
    }

    if (h_star[this->task.initial_state()] == +INFTY)
    {
        return;
    }

    while (++generated_samples <= this->number_of_samples)
    {
        bool match = false;
        PartialState partial_state = this->task.goal_condition();
        State state;
        while (not match)
        {
            for (int i = 0; i < this->length; i++)
            {
                vec<PartialState> regressed_states = partial_state.get_regressed_partial_states(this->task.actions());
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
            vec<State> concrete_states = h_star.get_concrete_states_from_pdb(partial_state);
            if (not concrete_states.empty())
            {
                std::uniform_int_distribution<int> distribution(0, concrete_states.size() - 1);
                int random_index = distribution(rng);
                state = concrete_states[random_index];
                if (not states_ids.contains(state.id))
                {
                    states_ids.insert(state.id);
                    match = true;
                }
                else
                {
                    match = false;
                }
            }
            else
            {
                match = false;
            }
        }
        samples.push_back(this->get_sample(state, h_star));
    }
    this->samples = samples;
    return;
}