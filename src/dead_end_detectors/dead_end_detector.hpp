#pragma once

#include "../task.hpp"
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
    protected:
        const Task &task;
        static map<int64_t, int> labeled_states;
    public:
        DeadEndDetector(const Task &task) : task(task) {};
        // TODO: make this bool
        virtual bool is_deadend(const State &state) const = 0;
};