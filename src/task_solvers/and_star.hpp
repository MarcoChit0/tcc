#pragma once

#include "../task.hpp"
#include "../dead_end_detectors/dead_end_detector.hpp"

class AndStar : public Task::Solver
{
public:
    enum SignaturingMethod {ID, LANE, IN_OUT, OUT};

    const Policy::Heuristic &policy_heuristic;
    const State::Heuristic &state_heuristic;
    const opt<std::shared_ptr<DeadEndDetector>> &dead_end_detector;
    int64_t number_of_generated_policies = 0;
    int64_t number_of_inserted_policies = 0;
    int64_t number_of_removed_policies = 0;
    int64_t number_of_expanded_policies = 0;

    AndStar(const Policy::Heuristic &policy_heuristic, const State::Heuristic &state_heuristic, const opt<std::shared_ptr<DeadEndDetector>>&dead_end_detector = std::nullopt);

    Policy get_solution(const Task &task);
};
