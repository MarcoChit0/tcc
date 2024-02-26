#pragma once

#include "../task.hpp"
#include <unordered_set>

#define DEAD_END_FILE_NAME "log.txt"
#define DEAD_END_DIR "dead-end/"

enum StateLabel
{
    NO_LABEL,
    DEAD_END,
    WEAK_ALIVE,
    ALIVE,
    ND_DEAD_END
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

typedef std::unordered_set<StateActionPair, hash_StateActionPair> StateActionPairSet;
typedef std::unordered_map<StateActionPair, bool, hash_StateActionPair> StateActionPairToBoolMap;
class DeadEndDetector
{
    protected:
        const Task &task;
        static map<int64_t, int> labeled_states;
        const str dead_end_directory = default_directory + DEAD_END_DIR;
        const str file_name = DEAD_END_FILE_NAME;
    public:
        DeadEndDetector(const Task &task) : task(task) {
            if(not directory_created_successfully(DEAD_END_DIR))
            {
                throw std::runtime_error("LOG::DeadEndDetector::DeadEndDetector::directory not created");
            }
        };
        // TODO: make this bool
        virtual double is_deadend(const State &state) const = 0;
};