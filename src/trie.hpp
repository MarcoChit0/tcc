#pragma once

#include "./trie_node.hpp"

class Trie
{
    public:
        vec<TrieNode> roots;
        Trie& operator=(const Trie& other);
        int operator[](const State& state) const;
        Trie();
        Trie(const State &state, const int &heuristic);
        
        set<State> get_states(const PartialState &partial_state) const;
        void add(const State &state, const int &heuristic);
        void print();
};