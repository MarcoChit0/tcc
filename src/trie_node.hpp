#pragma once
#include "./task.hpp"
class TrieNode
{
public:
    TrieNode& operator=(const TrieNode& other);
    Variable variable;
    vec<TrieNode> children;
    set<State> states;
    int depth;

    TrieNode() : depth(-1), variable(Variable()), children(), states() {}

    TrieNode(int depth, Variable variable) : depth(depth), variable(variable), children(Task::variable_to_variable_domain_size[variable.id], TrieNode()), states() {}

    set<State> get_states(const PartialState &partial_state) const;
    void add(vec<Fact> facts, const State &state);
    void print();
};