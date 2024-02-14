#pragma once

#include "task.hpp"
#include <unordered_set>

enum StateLabel
{
    DEAD_END,
    WEAK_ALIVE,
    ALIVE,
};

static std::map<int, str> state_label_to_string = {
    {DEAD_END, "deadend"},
    {WEAK_ALIVE, "weak-alive"},
    {ALIVE, "alive"},
}; 

typedef std::pair<State, Action> StateActionPair;

struct hash_StateActionPair
{
    size_t operator()(const StateActionPair &state_action_pair) const
    {
        return std::hash<State>()(state_action_pair.first) ^ std::hash<Action>()(state_action_pair.second);
    }
};

typedef std::unordered_set<std::pair<State, Action>, hash_StateActionPair> StateActionPairSet;

class DeadEndDetector
{
    private:
        const Task &task;
    public:
        void find_weak_alive_states(const set<State> &goal_states, map<State, StateActionPairSet> &reversed_edges, set<State> &weak_alive_states, StateActionPairSet &bad_state_action_pairs);
        void find_dead_end_states(const set<State> &states, set<State> &dead_end_states);
        void test_whether_weak_alive_states_are_dead_end_states(set<State> &weak_alive_states, set<State> &dead_end_states);
        void mark_goal_states_as_alive(const Task &task, const set<State> &states, map<State, StateActionPairSet> &reversed_edges, set<State> &goal_states, set<State> &non_goal_states);
        void transform_weak_alive_states_into_alive_states(const set<State> &weak_alive_states);
        void unlabel_weak_alive_states_before_performing_loop(set<State> &weak_alive_states, int &number_of_weak_alive_states_on_previous_iteration);
        void find_bad_actions(map<State, StateActionPairSet> & reversed_edges, StateActionPairSet &bad_state_action_pairs, set<State>& dead_end_states);
        DeadEndDetector(const Task &task, const bool save_metadata = false);
        bool operator[](const State &state) const;
        static map<int64_t, int> labeled_states;
};