#pragma once

#include "./and_star.hpp"

class CompareStateState
{
    public:
        const State::Heuristic &state_heuristic;
        CompareStateState(const State::Heuristic &state_heuristic) : state_heuristic(state_heuristic) {}
        bool operator()(const State &state1, const State &state2) const
        {
            return state_heuristic[state1] > state_heuristic[state2];
        }
};

class GPM : public Task::Solver
{
    public:
        GPM(const State::Heuristic &state_heuristic, const opt<std::shared_ptr<DeadEndDetector>> &dead_end_detector = std::nullopt);

        const State::Heuristic &state_heuristic;
        const opt<std::shared_ptr<DeadEndDetector>> &dead_end_detector;
        
        Policy get_solution(const Task &task);
}; 