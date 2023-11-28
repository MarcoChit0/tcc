#pragma once

#include "../delete_relaxation_heuristic.hpp"
class Max : public DeleteRelaxationHeuristic
{
public:
    using DeleteRelaxationHeuristic::DeleteRelaxationHeuristic;

    int operator[](const State &state) const;

    set<State> get_concrete_states(const PartialState &partial_state) const override;

    int size() const;
};
