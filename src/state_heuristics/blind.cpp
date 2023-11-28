#include "./blind.hpp"

int Blind::operator[](const State &state) const
{
    return state.is_goal(this->task.goal_condition()) ? 0 : 1;
    ;
};

set<State> Blind::get_concrete_states(const PartialState &partial_state) const
{
    return set<State>{};
}

int Blind::size() const
{
    return 0;
}