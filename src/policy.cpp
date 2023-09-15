#include "./policy.hpp"

Policy::Policy(const State &state, const Action &action, const Policy &parent_policy)
{
    this->id = ++last_used_id;
    this->state() = state;
    this->action() = action;
    this->parent_policy() = parent_policy;
}

Policy::DomainIterator Policy::domain_iterator() const
{
    return DomainIterator(*this);
}

Action &Policy::operator[](const State &state) const
{
    if (this->is_none())
    {
        throw std::out_of_range("State not in policy.");
    }
    if (this->state() == state)
    {
        return this->action();
    }
    return this->parent_policy()[state];
}

bool Policy::contains(const State &state) const
{
    if (this->is_none())
    {
        return false;
    }
    if (this->state() == state)
    {
        return true;
    }
    return this->parent_policy().contains(state);
}

size_t Policy::size() const
{
    if (this->is_none())
    {
        return 0;
    }
    return this->parent_policy().size() + 1;
}

set<State> Policy::outgoing_non_goal_states(const PartialState &goal_condition) const
{
    Function this_function {&Policy::outgoing_non_goal_states, *this};
    auto &cache = functions_cache[this_function];
    if (not cache.contains(goal_condition))
    {
        auto &do_reach_the_goal_cache = functions_cache[Function{&Policy::does_reach_the_goal, *this}];
        if (this->is_none())
        {
            cache[goal_condition] = {};
            do_reach_the_goal_cache[goal_condition] = false;
        }
        else
        {
            cache[goal_condition] = this->parent_policy().outgoing_non_goal_states(goal_condition);
            do_reach_the_goal_cache[goal_condition] = this->parent_policy().does_reach_the_goal(goal_condition);
            cache[goal_condition].erase(this->state());
            for (const State &successor_state: this->state().get_successors(this->action()))
            {
                if (successor_state.is_goal(goal_condition))
                {
                    do_reach_the_goal_cache[goal_condition] = true;
                }
                else
                {
                    if (not this->contains(successor_state))
                    {
                        cache[goal_condition].insert(successor_state);
                    }
                }
            }
        }
    }
    return cache[goal_condition];
};

bool Policy::does_reach_the_goal(const PartialState &goal_condition) const
{
    Function this_function {&Policy::does_reach_the_goal, *this};
    auto &cache = functions_cache[this_function];
    if (not cache.contains(goal_condition))
    {
        this->outgoing_non_goal_states(goal_condition);
    }
    return cache[goal_condition];
};

std::ostream& operator<<(std::ostream &out, const Policy &self)
{
    bool first = true;
    for (const State &state: self.domain_iterator())
    {
        if (not first)
        {
            out << std::endl;
        }
        out << "[" << state << "]" << " -> " << self[state];
        first = false;
    }
    return out;
};

Policy::DomainIterator::DomainIterator(const Policy &policy) : policy(policy)
{
}

Policy::DomainIterator Policy::DomainIterator::begin() const
{
    return *this;
}

Policy::DomainIterator Policy::DomainIterator::end() const
{
    return DomainIterator({});
}

Policy::DomainIterator &Policy::DomainIterator::operator++()
{
    this->policy.id = this->policy.parent_policy().id;
    return *this;
}

bool Policy::DomainIterator::operator!=(const Policy::DomainIterator &other) const
{
    return this->policy != other.policy;
}

State Policy::DomainIterator::operator*() const
{
    return this->policy.state();
}

Policy::Heuristic::Heuristic(const Task &task) : task(task)
{
}
