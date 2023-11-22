#include "trie_node.hpp"

void TrieNode::print() const
{
    if (this->depth == -1)
    {
        return;
    }
    str ident = "";
    for (int i = 0; i <= this->depth; i++)
    {
        ident += " ";
    }
    std::cout << "variable: " << this->fact.variable();
    std::cout << ", fact: " << this->fact;
    if (this->children.size() > 0)
    {
        std::cout << ", children:\n";
        for (int i = 0; i < this->children.size(); i++)
        {
            std::cout << ident << i << ": ";
            this->children[i].print();
            std::cout << std::endl;
        }
    }
    else
    {
        std::cout << ", state: " << this->state;
        std::cout << ", heuristic: " << this->heuristic;
        std::cout << std::endl;
    }
}

TrieNode &TrieNode::operator=(const TrieNode &other)
{
    this->fact = other.fact;
    this->children = other.children;
    this->state = other.state;
    this->depth = other.depth;
    return *this;
}

void TrieNode::add(vec<Fact> facts, const State &state, const int &heuristic)
{
    if (this->depth == -1)
    {
        return;
    }
    this->number_of_states++;
    if (facts.size() == 0)
    {
        this->state = state;
        this->heuristic = heuristic;
        return;
    }
    int offset = Task::fact_to_fact_offset[facts[0].id];
    if (0 > offset or offset > this->children.size())
    {
        throw std::runtime_error("LOG::TrieNode::add::offset out of bounds");
    }
    if (this->children[offset].depth == -1)
    {
        if (facts.size() == 1)
        {
            this->children[offset] = TrieNode(this->depth + 1, facts[0], 0);
        }
        else
        {
            this->children[offset] = TrieNode(this->depth + 1, facts[0], Task::variable_to_variable_domain_size[facts[1].variable().id]);
        }
    }
    this->children[offset].add(vec<Fact>(facts.begin() + 1, facts.end()), state, heuristic);
}

set<State> TrieNode::get_states(vec<Fact> facts) const
{
    if (this->depth == -1)
    {
        return set<State>();
    }
    switch (concrete_states_generator)
    {
    case ConcreteStatesGenerator::ALL:
        return this->all(facts);
    case ConcreteStatesGenerator::RANDOM:
        return this->random(facts);
    default:
        throw std::runtime_error("LOG::TrieNode::get_states::concrete_states_generator not implemented");
    }
}

int TrieNode::operator[](vec<Fact> facts) const
{
    if ((facts.size() > 0 and facts[0].is_none()) or this->depth == -1)
    {
        return +INFTY;
    }
    if (facts.size() == 0)
    {
        return this->heuristic;
    }
    int offset = Task::fact_to_fact_offset[facts[0].id];
    if (0 > offset or offset > this->children.size())
    {
        throw std::runtime_error("LOG::TrieNode::operator[]::offset out of bounds");
    }
    return this->children[offset][vec<Fact>(facts.begin() + 1, facts.end())];
}

set<State> TrieNode::all(vec<Fact> facts) const
{
    if (this->depth == -1)
    {
        return set<State>();
    }
    if (facts.size() == 0)
    {
        return set<State>{this->state};
    }
    if (facts[0].is_none())
    {
        set<State> states;
        for (int i = 0; i < this->children.size(); i++)
        {
            auto child_states = this->children[i].get_states(vec<Fact>(facts.begin() + 1, facts.end()));
            states.insert(child_states.begin(), child_states.end());
        }
        return states;
    }
    else
    {
        int offset = Task::fact_to_fact_offset[facts[0].id];
        if (0 > offset or offset > this->children.size())
        {
            throw std::runtime_error("LOG::TrieNode::get_states::offset out of bounds");
        }
        return this->children[offset].get_states(vec<Fact>(facts.begin() + 1, facts.end()));
    }
}

set<State> TrieNode::random(vec<Fact> facts) const
{
    if (this->depth == -1)
    {
        return set<State>();
    }
    if (facts.size() == 0)
    {
        return set<State>{this->state};
    }
    if (facts[0].is_none())
    {
        set<int> offsets;
        set<State> states;
        do
        {
            int sum = 0;
            for (int i = 0; i < this->children.size(); i++)
            {
                if (this->children[i].depth != -1 and offsets.find(i) == offsets.end())
                {
                    sum += this->children[i].number_of_states;
                }
            }
            if (sum == 0)
            {
                break;
            }
            int random_offset = rand() % sum;
            int offset = 0;
            for (int i = 0; i < this->children.size(); i++)
            {
                if (this->children[i].depth != -1 and offsets.find(i) == offsets.end())
                {
                    offset += this->children[i].number_of_states;
                    if (offset >= random_offset)
                    {
                        offsets.insert(i);
                        states = this->children[i].get_states(vec<Fact>(facts.begin() + 1, facts.end()));
                        break;
                    }
                }
            }
        } while (states.empty() and offsets.size() < this->children.size());
        return states;
    }
    else
    {
        int offset = Task::fact_to_fact_offset[facts[0].id];
        if (0 > offset or offset > this->children.size())
        {
            throw std::runtime_error("LOG::TrieNode::get_states::offset out of bounds");
        }
        return this->children[offset].get_states(vec<Fact>(facts.begin() + 1, facts.end()));
    }
}