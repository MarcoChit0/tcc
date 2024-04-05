#pragma once

#include "../task.hpp"
#include "../dead_end_detectors/dead_end_detector.hpp"

class AndStar : public Task::Solver
{
public:
    enum SignaturingMethod {ID, LANE, IN_OUT, OUT};
    enum Comparator {GREEDY, WEIGHTED, DEPTH_FIRST, DEFAULT, BREADTH_FIRST};

    const Policy::Heuristic &policy_heuristic;
    const State::Heuristic &state_heuristic;
    const opt<std::shared_ptr<DeadEndDetector>> &dead_end_detector;
    std::function<bool(const Policy &, const Policy &)> is_policy_worse_than;
    boost::heap::pairing_heap<Policy, boost::heap::stable<true>, boost::heap::compare<std::function<bool(const Policy &, const Policy &)>>> queue;



    AndStar(const Policy::Heuristic &policy_heuristic, const State::Heuristic &state_heuristic, const int& comparator = DEFAULT, const opt<std::shared_ptr<DeadEndDetector>>&dead_end_detector = std::nullopt);

    Policy get_solution(const Task &task);

};