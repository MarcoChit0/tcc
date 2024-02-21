#pragma once

#include "dead_end_detector.hpp"

class CompleteDeadEndDetector : public DeadEndDetector
{
public:
    void find_weak_alive_states(const set<State> &goal_states, map<State, StateActionPairSet> &reversed_edges, set<State> &weak_alive_states, const StateActionPairToBoolMap &is_bad_state_action_pair);
    void find_dead_end_states(const set<State> &states, set<State> &dead_end_states, map<State, StateActionPairSet> &reversed_edges, StateActionPairToBoolMap &is_bad_state_action_pair);
    void test_whether_weak_alive_states_are_dead_end_states(const Task& task, set<State> &weak_alive_states, set<State> &dead_end_states, StateActionPairToBoolMap& is_bad_state_action_pair, map<State, StateActionPairSet>& reversed_edges);
    void mark_goal_states_as_alive(const Task &task, const set<State> &states, map<State, StateActionPairSet> &reversed_edges, set<State> &goal_states, set<State> &non_goal_states, StateActionPairToBoolMap &is_bad_state_action_pair);
    void transform_weak_alive_states_into_alive_states(const set<State> &weak_alive_states);
    void unlabel_weak_alive_states_before_performing_loop(set<State> &weak_alive_states, int &number_of_weak_alive_states_on_previous_iteration);
    void mark_bad_state_action_pairs(map<State, StateActionPairSet> &reversed_edges, StateActionPairToBoolMap &is_bad_state_action_pair, const State &dead_end_state);
    bool is_deadend(const State &state) const;
    CompleteDeadEndDetector(const Task &task, const bool save_metadata = false);
};