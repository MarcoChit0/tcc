#pragma once

#include "reachable_dead_end_detector.hpp"

class SetDeadEndDetector : public ReachableDeadEndDetector
{
    private: 
        std::unordered_set<State> alive, unk, dead;
        StateActionPairToBoolMap is_bad;
        std::map<State, vec<StateActionPair>> predecessors;
        int hard_dead_end_count, easy_dead_end_count, goal_count;
        void forward_search();
        void backward_search(std::unordered_set<State>& visited);
        void label_dead_states(std::unordered_set<State>& visited, const int& iteration);
        void label_alive_states();
        void print(const int& iteration) const;
    public:
        SetDeadEndDetector(const Task &task, const opt<int> &time_limit_seconds = std::nullopt);
        double is_deadend(const State &state) const;
        void label_states(const bool save_metadata) override;
};
