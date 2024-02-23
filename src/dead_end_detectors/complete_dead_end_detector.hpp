#pragma once

#include "dead_end_detector.hpp"

class CompleteDeadEndDetector : public DeadEndDetector
{
public:
    void find_weak_alive_states(
        map<State, StateActionPairSet> &reversed_edges,
        const set<State> &goal_states,
        set<State> &weak_alive_states,
        const StateActionPairToBoolMap &is_bad_state_action_pair);

    void find_dead_end_states(
        map<State, StateActionPairSet> &reversed_edges,
        const set<State> &states,
        set<State> &dead_end_states,
        StateActionPairToBoolMap &is_bad_state_action_pair);

    void mark_goal_states_as_alive(
        map<State, StateActionPairSet> &reversed_edges,
        const set<State> &states,
        set<State> &goal_states,
        set<State> &non_goal_states,
        StateActionPairToBoolMap &is_bad_state_action_pair);

    void transform_weak_alive_states_into_alive_states(const set<State> &weak_alive_states);

    void unlabel_weak_alive_states_before_performing_loop(set<State> &weak_alive_states);

    void mark_bad_state_action_pairs(
        map<State, StateActionPairSet> &reversed_edges,
        const State &dead_end_state,
        set<State>& dead_end_states,
        StateActionPairToBoolMap &is_bad_state_action_pair);

    double is_deadend(const State &state) const;

    bool have_good_actions(
        const State &state,
        const StateActionPairToBoolMap &is_bad_state_action_pair);

    CompleteDeadEndDetector(
        const Task &task,
        const bool save_metadata = false);
};