#pragma once

#include "task.hpp"
#include "dead_end_detectors/dead_end_detector.hpp"

void find_reachable_states_that_do_not_lead_to_dead_end_states(
    const Task &task,
    const State::Heuristic &state_heuristic,
    std::optional<std::shared_ptr<DeadEndDetector>>& dead_end_detector);