#pragma once

#include "task.hpp"
#include <ilcplex/cplex.h>
#include <ilcplex/ilocplex.h>

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

class DeadEndDetector
{
    private:
        const Task &task;
    public:
        void find_weak_alive_states(const set<State> &goal_states, map<State, vec<State>> &reversed_edges, set<State> &weak_alive_states);
        void find_dead_end_states(const set<State> &states, set<State> &dead_end_states);
        void test_whether_weak_alive_states_are_dead_end_states(set<State> &weak_alive_states, set<State> &dead_end_states);
        void mark_goal_states_as_alive(const Task &task, const set<State> &states, map<State, vec<State>> &reversed_edges, set<State> &goal_states, set<State> &non_goal_states);
        void transform_weak_alive_states_into_alive_states(const set<State> &weak_alive_states);
        DeadEndDetector(const Task &task);
        bool operator[](const State &state) const;
        static map<int64_t, int> labeled_states;
};

void print_integer_programming(map<str, vec<State>> mapping_label_to_states, map<State, str> mapping_state_to_lebel, map<str, set<Fact>> mapping_label_to_facts, map<State, set<Fact>> map_state_to_facts);