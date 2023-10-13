#pragma once

#include "../state.hpp"
class Star : public State::Heuristic
{
public:

    Star(const Task &task);

    int operator[](const State &state) const;
    
    vec<State> get_concrete_states_from_pdb(const PartialState &partial_state) const;
    static map<int64_t, vec<State>> partial_state_to_concrete_state;
};
