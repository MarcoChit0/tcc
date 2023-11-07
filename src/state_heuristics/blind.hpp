#pragma once

#include "../state.hpp"
class Blind : public State::Heuristic // Caution, operator[] here is returning a non-stable reference.
{
public:
    using State::Heuristic::Heuristic;

    int operator[](const State &state) const;

    vec<State> get_concrete_states(const PartialState &partial_state) const override;
};