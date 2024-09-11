#pragma once

#include "dead_end_detector.hpp"

class SetDeadEndDetector : public DeadEndDetector
{
private:
    std::unordered_set<State> alive, unk, dead;
    StateActionPairToBoolMap is_bad;
    map<State, int> state_to_label;
    std::map<State, vec<StateActionPair>> predecessors;
    int hard_dead_end_count, easy_dead_end_count, goal_count;
    void forward_search();
    void backward_search(std::unordered_set<State> &visited);
    void label_dead_states(std::unordered_set<State> &visited, const int &iteration, State &last_dead_end);
    void label_alive_states();
    void print(const int &iteration) const;

public:
    SetDeadEndDetector(const Task &task);
    void label_states(const bool save_metadata) override;
    bool iterative_states_labeling(int &iteration, const bool save_metadata = true);
};
