#pragma once

#include "./trie_node.hpp"

class Trie
{
    public:
        TrieNode root;
        Trie& operator=(const Trie& other);
        Trie();
        Trie(set<State> states);
        Trie(const State &state);
        
        set<State> get_states(const PartialState &partial_state) const;
        void add(const State &state);
        void print();
};