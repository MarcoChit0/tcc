#pragma once

#include "reachable_dead_end_detector.hpp"

class CompleteDeadEndDetector : public ReachableDeadEndDetector
{
protected:
    void create_states(
        const vec<Fact> &facts,
        set<State> &states) override;

    void create_states_recursive_procedure(
        const int depth, 
        const vec<Fact> &facts, 
        set<State> &states);

    void mark_goal_states_as_alive(
        map<State, StateActionPairSet> &reversed_edges,
        const set<State> &states,
        set<State> &goal_states,
        set<State> &non_goal_states,
        StateActionPairToBoolMap &is_bad_state_action_pair) override;

public:
    CompleteDeadEndDetector(const Task &task);
};