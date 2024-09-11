#pragma once

#include "./metric.hpp"
#include "../dead_end_detectors/set_dead_end_detector.hpp"
#include "../state_heuristics/star.hpp"

class K2Metric : public Metric {
    public:
        K2Metric(const Task &task) : Metric(task) {}
        void compute() const override;
        bool meta_gpm(const Star &h) const;
};

/*
def meta_gpm(h):
    if h[initial state] is infty
        return false
    if h[initial state] == 0
        return true
    
    stack = {initial state}
    visited = {}
    
    while stack is not empty:

        state = stack.pop()
        if h[state] == 0:
            continue
        if state in visited:
            continue
        visited += {state}
        
        good_action = false
        for action in applicable action(state):
            // do not generate known dead end and make deterministic progress 
            // note that dead end for meta_gpm() is not is_deadend() but h[state] == infty
            if (h[succ] != infty for all succ in action(state)) and (h[state] > h[succ] if exists succ in action(state)):
                good_action = true
                stack += {action(state)}
        if not good_action
            return false 
    
    return true

def k2_metric():
    i = 0
    known_dead_ends = {}
    while true:
        h_i = compute star heuristic using known dead ends
        if meta_gpm(h_i)
            return i
        known_dead_ends = run set dead end detector with i limiting the depth
        i += 1
    return false
*/