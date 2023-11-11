#pragma once
#include "./task.hpp"
class TrieNode
{
public:
    TrieNode& operator=(const TrieNode& other);
    Fact fact;
    vec<TrieNode> children;
    set<State> states;
    int depth;

    TrieNode() : depth(-1), fact(Fact()), children(), states() {}

    TrieNode(int depth, Fact fact) : depth(depth), fact(fact), children(Task::variable_to_variable_domain_size[fact.variable().id], TrieNode()), states() {}

    set<State> get_states(const PartialState &partial_state) const;
    void add(vec<Fact> facts, const State &state);
    void print();
};