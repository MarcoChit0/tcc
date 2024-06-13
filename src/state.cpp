#include "./state.hpp"

bool &State::is_goal(const PartialState &goal_condition) const
{
    if (not are_states_goal.contains(this->id))
    {
        are_states_goal[this->id] = this->does_model(goal_condition);
    }
    return are_states_goal[this->id];
}

static vec<Action> static_applicable_actions = vec<Action>();
vec<Action> &State::get_applicable_actions(const vec<Action> &actions) const
{
    if (not cache_enabled)
    {
        static_applicable_actions.clear();
        for (const Action &action: actions)
        {
            if (this->can_receive_action(action))
            {
                static_applicable_actions.push_back(action);
            }
        }
        return static_applicable_actions;
    }
    else
    {
        if (not states_applicable_actionss.contains(this->id))
        {
            vec<Action> applicable_actions;
            for (const Action &action: actions)
            {
                if (this->can_receive_action(action))
                {
                    applicable_actions.push_back(action);
                }
            }
            states_applicable_actionss[this->id] = applicable_actions;


        }
        return states_applicable_actionss[this->id];
    }

}

bool State::can_receive_action(const Action &action) const
{
    return this->does_model(action.precondition());
}

static vec<State> static_successors = vec<State>();
vec<State> &State::get_successors(const Action &action) const
{
    if(not cache_enabled)
    {
        static_successors.clear();
        for (const PartialState &effect: action.effects())
        {
            static_successors.push_back(this->get_successor(effect));
        }
        return static_successors;
    }
    else
    {
        if (not states_actions_successor_statess.contains(this->id) or not states_actions_successor_statess[this->id].contains(action.id))
        {
            vec<State> successors;
            for (const PartialState &effect: action.effects())
            {
                successors.push_back(this->get_successor(effect));
            }

                states_actions_successor_statess[this->id][action.id] = successors;

        }
        return states_actions_successor_statess[this->id][action.id];
    }



}

State State::get_successor(const PartialState &effect) const
{
    vec<Fact> successor_true_facts = this->true_facts();
    mpz_class successor_hash = this->hash();
    int n = successor_true_facts.size();
    for (int i = 0; i < n; i++)
    {
        if (not effect.true_facts()[i].is_none())
        {
            successor_true_facts[i] = effect.true_facts()[i];
            successor_hash += successor_true_facts[i].hash() - this->true_facts()[i].hash();
        }
    }
    return State(successor_true_facts, successor_hash);
}

State::Heuristic::Heuristic(const Task &task) : task(task)
{
}

map<State::Id, bool> State::are_states_goal;
map<State::Id, vec<Action>> State::states_applicable_actionss;
map<State::Id, map<int64_t, vec<State>>> State::states_actions_successor_statess;