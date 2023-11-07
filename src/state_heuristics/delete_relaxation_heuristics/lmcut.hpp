#pragma once

#include "../delete_relaxation_heuristic.hpp"
class Lmcut : public DeleteRelaxationHeuristic
{
public:
    using DeleteRelaxationHeuristic::DeleteRelaxationHeuristic;

    int operator[](const State &state) const;

    vec<State> get_concrete_states(const PartialState &partial_state) const override;
};
