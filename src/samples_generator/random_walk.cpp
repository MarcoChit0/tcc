#include "./random_walk.hpp"

RandomWalk::RandomWalk(const Task &task, const State::Heuristic &state_heuristic, const Walker &walker, const int number_of_samples, const int length) : SampleGenerator(task, state_heuristic, number_of_samples), length(length), walker(walker) {}

set<Sample> RandomWalk::generate_samples() const
{
    set<Sample> samples = set<Sample>{};
    if (not(this->state_heuristic[this->task.initial_state()] == +INFTY))
    {
        set<int64_t> states_ids;
        while (samples.size() < this->number_of_samples and enough_memory() and enough_time())
        {
            State state = this->select_state(this->task.goal_condition(), &states_ids);
            if (enough_memory() and enough_time())
            {
                Sample sample = this->get_sample(state);
                if (not sample.is_none())
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

State RandomWalk::select_state(PartialState partial_state_to_be_regressed, set<int64_t> *states_ids) const
{
    State state;
    bool match = false;
    while (not match)
    {
        PartialState partial_state = partial_state_to_be_regressed;
        do
        {
            partial_state = this->perform_random_walk(partial_state_to_be_regressed);
        } while (partial_state == partial_state_to_be_regressed);
        set<State> concrete_states = this->state_heuristic.get_concrete_states(partial_state);
        if (not concrete_states.empty())
        {
            std::uniform_int_distribution<int> distribution(0, concrete_states.size() - 1);
            int random_index = distribution(rng);
            auto it = std::next(concrete_states.begin(), random_index);
            state = *it;
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

PartialState Stop::operator()(PartialState partial_state, const Task &task, const int length) const
{
    for (int i = 0; i < length; i++)
    {
        vec<vec<PartialState>> vec_regressed_partial_states = task.get_regressed_partial_states(partial_state);
        if (not vec_regressed_partial_states.empty())
        {
            std::uniform_int_distribution<int> distribution(0, vec_regressed_partial_states.size() - 1);
            int random_action_index = distribution(rng);
            vec<PartialState> regressed_partial_states = vec_regressed_partial_states[random_action_index];
            if(regressed_partial_states.size() > 1)
            {
                distribution = std::uniform_int_distribution<int>(0, regressed_partial_states.size() - 1);
                int random_partial_state_index = distribution(rng);
                partial_state = regressed_partial_states[random_partial_state_index];                
            }
            else
            {
                partial_state = regressed_partial_states[0];
            }
        }
        else
        {
            break;
        }
    }
    return partial_state;
}

PartialState BackTracking::operator()(PartialState partial_state, const Task &task, const int length) const
{
    std::stack<PartialState> partial_states;
    map<int64_t, bool> regressed_states;
    map<int64_t, int> partial_state_to_depth;
    partial_states.push(partial_state);
    partial_state_to_depth[partial_state.id] = 0;
    while (not partial_states.empty())
    {
        partial_state = partial_states.top();
        partial_states.pop();
        if (partial_state_to_depth[partial_state.id] == length)
        {
            break;
        }
        if (not regressed_states[partial_state.id])
        {
            regressed_states[partial_state.id] = true;
            vec<vec<PartialState>> vec_regressed_partial_states = task.get_regressed_partial_states(partial_state);
            std::shuffle(vec_regressed_partial_states.begin(), vec_regressed_partial_states.end(), rng);
            for(vec<PartialState> regressed_partial_states : vec_regressed_partial_states)
            {
                if(regressed_partial_states.size() > 1)
                {
                    std::shuffle(regressed_partial_states.begin(), regressed_partial_states.end(), rng);
                }
                for (PartialState regressed_partial_state : regressed_partial_states)
                {
                    partial_states.push(regressed_partial_state);
                    partial_state_to_depth[regressed_partial_state.id] = partial_state_to_depth[partial_state.id] + 1;
                }                
            }

        }
    }
    return partial_state;
}

PartialState Restart::operator()(PartialState partial_state, const Task &task, const int length) const
{
    const PartialState initial_partial_state = partial_state;
    bool found = false;
    while (!found)
    {
        partial_state = initial_partial_state;
        int i = 0;
        for (; i < length; i++)
        {
            vec<vec<PartialState>> vec_regressed_partial_states = task.get_regressed_partial_states(partial_state);
            if (not vec_regressed_partial_states.empty())
            {
                std::uniform_int_distribution<int> distribution(0, vec_regressed_partial_states.size() - 1);
                int random_action_index = distribution(rng);
                vec<PartialState> regressed_partial_states = vec_regressed_partial_states[random_action_index];
                if(regressed_partial_states.size() > 1)
                {
                    distribution = std::uniform_int_distribution<int>(0, regressed_partial_states.size() - 1);
                    int random_partial_state_index = distribution(rng);
                    partial_state = regressed_partial_states[random_partial_state_index];
                }
                else
                {
                    partial_state = regressed_partial_states[0];
                }
            }
            else
            {
                break;
            }
        }
        if (i == length)
        {
            found = true;
        }
    }
    return partial_state;
}
