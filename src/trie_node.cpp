#include "trie_node.hpp"

void TrieNode::print()
{
    if(this->depth == -1)
    {
        return;
    }
    str ident = "";
    for(int i = 0; i < this->depth; i++) { ident += " "; }
    std::cout << "variable: " << this->fact.variable();
    std::cout << ", fact: " << this->fact;
    std::cout << ", states: [ ";
    for (State state : this->states)
    {
        std::cout << state.id << ", ";
    }
    std::cout << " ], children:\n";
    for(int i = 0; i < this->children.size(); i++)
    {
        std::cout << ident << i << ": ";
        this->children[i].print();
        std::cout << std::endl;
    }
}

TrieNode &TrieNode::operator=(const TrieNode &other)
{
    this->fact = other.fact;
    this->children = other.children;
    this->states = other.states;
    this->depth = other.depth;
    return *this;
}

void TrieNode::add(vec<Fact> facts, const State &state)
{
    if (facts.size() <= 0)
    {
        return;
    }
    if (facts.size() == 1)
    {
        this->states.insert(state);
        return;
    }
    else
    {
        int offset = Task::fact_to_fact_offset[fact.id];
        if (this->children.size() <= offset)
        {
            this->children.resize(offset + 1, TrieNode());
        }
        if (this->children[offset].depth == -1)
        {
            this->children[offset] = TrieNode(this->depth + 1, facts[1]);
        }
        facts.erase(facts.begin());
        this->children[offset].add(facts, state);
    }
}