#include "trie.hpp"

Trie& Trie::operator=(const Trie& other)
{
    this->root = other.root;
    return *this;
}

Trie::Trie(set<State> states)
{
    std::cout << "LOG::Trie::trying to generate trie" << std::endl;
    auto it = states.begin();
    this->root = TrieNode(0, (*it).true_facts()[0]);
    std::cout << "LOG::Trie::generated trie " << std::endl;
    std::cout << "LOG::Trie::adding state\n";
    this->add(*it);
    std::cout << "LOG::Trie::added state\n";
}

Trie::Trie()
{
    this->root = TrieNode();
}

void Trie::print()
{
    std::cout << "LOG::Trie::print" << std::endl;
    this->root.print();
    std::cout << "LOG::Trie::print::end" << std::endl;
}

void Trie::add(const State& state)
{
    this->root.add(state.true_facts(), state);
}