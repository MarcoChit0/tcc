#pragma once
#include "../trie.hpp"

class TrieStateHeuristic : public State::Heuristic
{
public:
    Trie trie;

    TrieStateHeuristic(const Task &task);

    int operator[](const State &state) const;

    vec<State> get_concrete_states(const PartialState &partial_state) const;
};