#pragma once
#include "./task.hpp"
class TrieNode
{
public:
    TrieNode& operator=(const TrieNode& other);
    int operator[](vec<Fact> facts) const;

    Fact fact;
    vec<TrieNode> children;
    State state;
    int heuristic;
    int depth;

    TrieNode() : depth(-1), fact(Fact()), children(), state(State()), heuristic(+INFTY) {}

    TrieNode(int depth, Fact fact, int next_variable_offset) : depth(depth), fact(fact), children(next_variable_offset, TrieNode()), state(State()), heuristic(+INFTY) {}

    set<State> get_states(vec<Fact> fact) const;
    void add(vec<Fact> facts, const State &state, const int &heuristic);
    void print();
};