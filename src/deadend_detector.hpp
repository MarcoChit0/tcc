#pragma once

#include "task.hpp"

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
        DeadEndDetector(const Task &task);
        bool operator[](const State &state) const;
        static map<int64_t, int> labeled_states;
};