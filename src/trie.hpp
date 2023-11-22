#pragma once

#include "./trie_node.hpp"

class Trie
{
    private:
        set<State> all(const PartialState& partial_state) const;
        set<State> random(const PartialState& partial_state) const;
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