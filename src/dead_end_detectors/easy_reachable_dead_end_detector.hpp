#pragma once

#include "reachable_dead_end_detector.hpp"

class EasyReachableDeadEndDetector : public ReachableDeadEndDetector
{
    public:
        void label_states(const bool save_metadata) override;
        EasyReachableDeadEndDetector(const Task &task, const opt<int> &time_limit_seconds = std::nullopt);
};