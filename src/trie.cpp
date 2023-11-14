#include "trie.hpp"

Trie& Trie::operator=(const Trie& other)
{
    this->roots = other.roots;
    return *this;
}

Trie::Trie() : roots() {}

Trie::Trie(const State &state, const int &heuristic)
{
    std::cout << "LOG::Trie::trying to generate trie" << std::endl;
    this->roots = vec<TrieNode>(Task::variable_to_variable_domain_size[state.true_facts()[0].variable().id], TrieNode());
    this->add(state, heuristic);
    std::cout << "LOG::Trie::generated trie with one only state" << std::endl;
}

void Trie::print()
{
    std::cout << "LOG::Trie::print" << std::endl;
    for(int i = 0; i < this->roots.size(); i++)
    {
        std::cout << "LOG::Trie::print::root " << i << std::endl;
        this->roots[i].print();
    }
    std::cout << "LOG::Trie::print::end" << std::endl;
}

void Trie::add(const State& state, const int &heuristic)
{
    if(state.true_facts().size() <= 0)
    {
        throw std::runtime_error("LOG::Trie::add::state.true_facts().size() <= 0");
    }    
    if(this->roots.size() == 0)
    {
        this->roots = vec<TrieNode>(Task::variable_to_variable_domain_size[state.true_facts()[0].variable().id], TrieNode());
    }
    int offset = Task::fact_to_fact_offset[state.true_facts()[0].id];
    if(0 > offset or offset > this->roots.size())
    {
        throw std::runtime_error("LOG::Trie::add::fact offset out of bounds");
    }
    if(this->roots[offset].depth == -1)
    {
        if(state.true_facts().size() == 1)
        {
            this->roots[offset] = TrieNode(0, state.true_facts()[0], 0);
        }
        else
        {
            this->roots[offset] = TrieNode(0, state.true_facts()[0], Task::variable_to_variable_domain_size[state.true_facts()[1].variable().id]);
        }
    }
    this->roots[offset].add(vec<Fact>(state.true_facts().begin() + 1, state.true_facts().end()), state, heuristic);
}

set<State> Trie::get_states(const PartialState &partial_state) const
{
    if(partial_state.true_facts().size() <= 0)
    {
        throw std::runtime_error("LOG::Trie::get_states::partial_state.true_facts().size() <= 0");
    }
    if(partial_state.true_facts()[0].is_none())
    {
        set<State> states;
        for(int i = 0; i < this->roots.size(); i++)
        {
            auto root_states = this->roots[i].get_states(vec<Fact>(partial_state.true_facts().begin() + 1, partial_state.true_facts().end()));
            states.insert(root_states.begin(), root_states.end());
        }
        return states;
    }
    else
    {
        int offset = Task::fact_to_fact_offset[partial_state.true_facts()[0].id];
        if(0 > offset or offset > this->roots.size())
        {
            throw std::runtime_error("LOG::Trie::get_states::fact offset out of bounds");
        }
        if(this->roots[offset].depth == -1)
        {
            return set<State>();
        }    
        return this->roots[offset].get_states(vec<Fact>(partial_state.true_facts().begin() + 1, partial_state.true_facts().end()));
    }
}

int Trie::operator[](const State& state) const
{
    if(state.true_facts().size() <= 0)
    {
        throw std::runtime_error("LOG::Trie::operator[]::state.true_facts().size() <= 0");
    }
    int offset = Task::fact_to_fact_offset[state.true_facts()[0].id];
    if(0 > offset or offset > this->roots.size())
    {
        throw std::runtime_error("LOG::Trie::operator[]::fact offset out of bounds");
    }
    if(this->roots.size() == 0 or this->roots[offset].depth == -1)
    {
        return +INFTY;
    }
    return this->roots[offset][vec<Fact>(state.true_facts().begin() + 1, state.true_facts().end())];
}