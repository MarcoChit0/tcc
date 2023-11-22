#pragma once
#include "./task.hpp"

extern int concrete_states_generator;

enum ConcreteStatesGenerator
{
    ALL = 0,
    RANDOM,
};

class TrieNode
{
private:
    set<State> all(vec<Fact> fact) const;
    set<State> random(vec<Fact> fact) const;
public:
    TrieNode& operator=(const TrieNode& other);
    int operator[](vec<Fact> facts) const;

    Fact fact;
    vec<TrieNode> children;
    State state;
    int heuristic;
    int depth;
    int number_of_states;

    TrieNode() : depth(-1), fact(Fact()), children(), state(State()), heuristic(+INFTY), number_of_states(0) {}

    TrieNode(int depth, Fact fact, int next_variable_offset) : depth(depth), fact(fact), children(next_variable_offset, TrieNode()), state(State()), heuristic(+INFTY), number_of_states(0) {}

    set<State> get_states(vec<Fact> fact) const;
    void add(vec<Fact> facts, const State &state, const int &heuristic);
    void print() const;
};
