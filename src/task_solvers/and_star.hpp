#pragma once

#include "../task.hpp"
class AndStar : public Task::Solver
{
public:
    enum SignaturingMethod {ID, LANE, IN_OUT, OUT};

    const Policy::Heuristic &policy_heuristic;
    const State::Heuristic &state_heuristic;
    int64_t number_of_generated_policies = 0;
    int64_t number_of_inserted_policies = 0;
    int64_t number_of_removed_policies = 0;
    int64_t number_of_expanded_policies = 0;

    AndStar(const Policy::Heuristic &policy_heuristic, const State::Heuristic &state_heuristic);

    Policy get_solution(const Task &task);
};
