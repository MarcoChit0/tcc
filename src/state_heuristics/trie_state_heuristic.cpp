#include "trie_state_heuristic.hpp"

TrieStateHeuristic::TrieStateHeuristic(const Task &task) : Heuristic(task), trie(Trie())
{
};

int TrieStateHeuristic::operator[](const State &state) const
{
    return this->trie[state];
};

set<State> TrieStateHeuristic::get_concrete_states(const PartialState &partial_state) const
{
    return this->trie.get_states(partial_state);
};

int TrieStateHeuristic::size() const
{
    int states = 0;
    for(auto root : this->trie.roots)
    {
        states += root.number_of_states;
    }
    return states;
};