#include "trie_state_heuristic.hpp"

TrieStateHeuristic::TrieStateHeuristic(const Task &task) : Heuristic(task), trie(Trie())
{
};

int TrieStateHeuristic::operator[](const State &state) const
{
    return this->trie[state];
};

vec<State> TrieStateHeuristic::get_concrete_states(const PartialState &partial_state) const
{
    if(not partial_state_to_concrete_state.contains(partial_state.id))
    {
        set<State> concrete_states = this->trie.get_states(partial_state);
        partial_state_to_concrete_state[partial_state.id] = vec<State>(concrete_states.begin(), concrete_states.end());
    }
    return partial_state_to_concrete_state[partial_state.id];
};