#include "./blind.hpp"

int Blind::operator[](const State &state) const
{
    return state.is_goal(this->task.goal_condition()) ? 0 : 1;
    ;
};

set<State> Blind::get_concrete_states(const PartialState &partial_state) const
{
    auto &data_base = functions_storage[Function{&Blind::operator[], *this}];
    set<State> concrete_states;
    for (std::pair<Object, int64_t> pair : data_base)
    {
        State state;
        state.id = pair.first.id;
        if (partial_state.does_model(state) and state.does_model(partial_state))
        {
            concrete_states.insert(state);
        }
    }
    return concrete_states;
}