#pragma once

#include "dead_end_detector.hpp"

class CompleteDeadEndDetector : public DeadEndDetector
{
    public:
        void find_weak_alive_states(const set<State> &goal_states, map<State, StateActionPairSet> &reversed_edges, set<State> &weak_alive_states, StateActionPairSet &bad_state_action_pairs);
        void find_dead_end_states(const set<State> &states, set<State> &dead_end_states);
        void test_whether_weak_alive_states_are_dead_end_states(set<State> &weak_alive_states, set<State> &dead_end_states);
        void mark_goal_states_as_alive(const Task &task, const set<State> &states, map<State, StateActionPairSet> &reversed_edges, set<State> &goal_states, set<State> &non_goal_states);
        void transform_weak_alive_states_into_alive_states(const set<State> &weak_alive_states);
        void unlabel_weak_alive_states_before_performing_loop(set<State> &weak_alive_states, int &number_of_weak_alive_states_on_previous_iteration);
        void find_bad_actions(map<State, StateActionPairSet> & reversed_edges, StateActionPairSet &bad_state_action_pairs, set<State>& dead_end_states);
        CompleteDeadEndDetector(const Task &task, const bool save_metadata = false);
        bool is_deadend(const State &state) const;
};