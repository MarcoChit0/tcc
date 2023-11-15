#pragma once

#include "../trie_state_heuristic.hpp"

class TrieStar : public TrieStateHeuristic
{
public:
    TrieStar(const Task &task);
};
