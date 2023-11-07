#include "./blind.hpp"

int Blind::operator[](const State &state) const
{
    return state.is_goal(this->task.goal_condition())? 0: 1;;
};


vec<State> Blind::get_concrete_states(const PartialState &partial_state) const
{
    if (not partial_state_to_concrete_state.contains(partial_state.id))
    {
        auto &data_base = functions_storage[Function{&Blind::operator[], *this}];
        vec<State> concrete_states;
        for(std::pair<Object, int64_t> pair : data_base)
        {
            State state;
            state.id = pair.first.id;
            if (partial_state.does_model(state) and state.does_model(partial_state))
            {
                concrete_states.push_back(state);
            }
        }
        partial_state_to_concrete_state[partial_state.id] = concrete_states;
    }
    return partial_state_to_concrete_state[partial_state.id];
}