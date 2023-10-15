#include "./partial_state.hpp"

vec<Fact> &PartialState::true_facts() const
{
    return partial_states_true_factss[this->id];
};

mpz_class PartialState::hash() const
{
    return partial_states_hashes.left.at(this->id);
};

PartialState::PartialState(const vec<Fact> &true_facts, const mpz_class &hash)
{
    if (partial_states_hashes.right.find(hash) != partial_states_hashes.right.end())
    {
        this->id = partial_states_hashes.right.at(hash);
    }
    else
    {
        this->id = ++last_used_id;
        while (partial_states_true_factss.size() <= this->id) {partial_states_true_factss.emplace_back();} // See comment above.
        partial_states_true_factss[this->id] = true_facts;
        partial_states_hashes.insert({this->id, hash});
    }
};

PartialState::PartialState(const vec<Fact> &true_facts)
{
    mpz_class hash = 0;
    for (const Fact &fact: true_facts)
    {
        hash += fact.hash();
    }

    if (partial_states_hashes.right.find(hash) != partial_states_hashes.right.end())
    {
        this->id = partial_states_hashes.right.at(hash);
    }
    else
    {
        this->id = ++last_used_id;
        while (partial_states_true_factss.size() <= this->id) {partial_states_true_factss.emplace_back();} // See comment above.
        partial_states_true_factss[this->id] = true_facts;
        partial_states_hashes.insert({this->id, hash});
    }
};

bool PartialState::does_model(const PartialState &other) const
{
    for (int i = 0; i < this->true_facts().size(); i++)
    {
        if (not other.true_facts()[i].is_none() and not this->true_facts()[i].is_none())
        {
            if (other.true_facts()[i] != this->true_facts()[i])
            {
                return false;
            }
        }
    }
    return true;
}

std::ostream& operator<<(std::ostream &out, const PartialState &self)
{
    bool first = true;
    for (const Fact &fact: self.true_facts())
    {
        if (not fact.is_none())
        {
            if (not first)
            {
                out << ", ";
            }
            out << fact;
            first = false;
        }
    }
    return out;
};

// map<PartialState::Id, vec<Fact>> PartialState::partial_states_true_factss;
vec<vec<Fact>> PartialState::partial_states_true_factss;
boost::bimap<PartialState::Id, mpz_class> PartialState::partial_states_hashes;


vec<PartialState> PartialState::get_regressed_partial_states(const vec<Action> &actions) const
{
    std::cout<<"LOG::PartialState::get_regressed_partial_states()::begin\n";
    if(not regressed_partial_states.contains(this->id))
    {
        vec<PartialState> predecessors;
        set<int64_t> predecessors_ids;
        for(auto action : actions)
        {
            std::cout << "Action: " << action << std::endl;
            for (auto effect : action.effects())
            {
                std::cout << "Effect: " << effect << std::endl;
                if (this->does_model(effect))
                {
                    vec<Fact> predecessor_true_facts = this->true_facts();
                    for(int i = 0; i < this->true_facts().size(); i++)
                    {
                        predecessor_true_facts[i] = action.precondition().true_facts()[i];
                    }
                    PartialState predecessor = PartialState(predecessor_true_facts);
                    std::cout << "Predecessor: " << predecessor << std::endl;
                    if(not predecessors_ids.contains(predecessor.id))
                    {
                        predecessors_ids.insert(predecessor.id);
                        predecessors.push_back(predecessor);
                    }
                }
            }
        }
        regressed_partial_states[this->id] = predecessors;
    }
    std::cout<<"LOG::PartialState::get_regressed_partial_states()::end\n";
    return regressed_partial_states[this->id];
}

map<PartialState::Id, vec<PartialState>> PartialState::regressed_partial_states;