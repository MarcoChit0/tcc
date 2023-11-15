#pragma once

#include "../state.hpp"
class Star : public State::Heuristic
{
public:

    Star(const Task &task);

    int operator[](const State &state) const;

    vec<State> get_concrete_states(const PartialState &partial_state) const override;
};