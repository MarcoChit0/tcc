#pragma once

#include "reachable_dead_end_detector.hpp"

class SetDeadEndDetector : public ReachableDeadEndDetector
{
    public:
        SetDeadEndDetector(const Task &task, const opt<int> &time_limit_seconds = std::nullopt);
        double is_deadend(const State &state) const;
        void label_states(const bool save_metadata) override;
};
