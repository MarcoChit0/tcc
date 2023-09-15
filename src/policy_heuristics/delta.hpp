#pragma once

#include "../policy.hpp"
class Delta : public Policy::Heuristic
{
public:
    const State::Heuristic &state_heuristic;

    Delta(const Task &task, const State::Heuristic &state_heuristic);

    int operator[](const Policy &policy) const;
};
