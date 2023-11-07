#include "./delete_relaxation_heuristic.hpp"

void DeleteRelaxationHeuristic::set_start_action(const State &state)
{
    for (const Fact &fact: actions_successor_facts[start_action])
    {
        facts_predecessor_actions[fact].erase(start_action);
    }
    actions_successor_facts[start_action].clear();

    for (const Fact &fact: state.true_facts())
    {
        facts_predecessor_actions[fact].insert(start_action);
        actions_successor_facts[start_action].insert(fact);
    }
}

DeleteRelaxationHeuristic::DeleteRelaxationHeuristic(const Task &task) : Heuristic(task)
{
    start_fact.id = -2;
    final_fact.id = -3;
    start_action.id = -2;
    final_action.id = -3;

    facts_successor_actions[start_fact].insert(start_action);
    facts_predecessor_actions[final_fact].insert(final_action);
    actions_successor_facts[final_action].insert(final_fact);
    actions_predecessor_facts[start_action].insert(start_fact);

    for (const Action &action: task.actions())
    {
        for (const Fact &fact: action.precondition().true_facts())
        {
            if (not fact.is_none())
            {
                facts_successor_actions[fact].insert(action);
                actions_predecessor_facts[action].insert(fact);
            }
        }
        if (actions_predecessor_facts[action].empty())
        {
            facts_successor_actions[start_fact].insert(action);
            actions_predecessor_facts[action].insert(start_fact);
        }

        for (const PartialState &effect: action.effects())
        {
            for (const Fact &fact: effect.true_facts())
            {
                if (not fact.is_none())
                {
                    facts_predecessor_actions[fact].insert(action);
                    actions_successor_facts[action].insert(fact);
                }
            }
        }
    }

    for (const Fact &fact: task.goal_condition().true_facts())
    {
        if (not fact.is_none())
        {
            facts_successor_actions[fact].insert(final_action);
            actions_predecessor_facts[final_action].insert(fact);
        }
    }
}

map<Fact, set<Action>> DeleteRelaxationHeuristic::facts_successor_actions;
map<Fact, set<Action>> DeleteRelaxationHeuristic::facts_predecessor_actions;
map<Action, set<Fact>> DeleteRelaxationHeuristic::actions_successor_facts;
map<Action, set<Fact>> DeleteRelaxationHeuristic::actions_predecessor_facts;
Fact DeleteRelaxationHeuristic::start_fact;
Fact DeleteRelaxationHeuristic::final_fact;
Action DeleteRelaxationHeuristic::start_action;
Action DeleteRelaxationHeuristic::final_action;

vec<State> DeleteRelaxationHeuristic::get_concrete_states(const PartialState &partial_state) const
{
    if (not partial_state_to_concrete_state.contains(partial_state.id))
    {
        auto &data_base = functions_storage[Function{&DeleteRelaxationHeuristic::operator[], *this}];
        vec<State> concrete_states;
        for(std::pair<Object, int64_t> pair : data_base)
        {
            State state;
            state.id = pair.first.id;
            if (partial_state.does_model(state) and state.does_model(partial_state))
            {
                concrete_states.push_back(state);
            }
        }
        partial_state_to_concrete_state[partial_state.id] = concrete_states;
    }
    return partial_state_to_concrete_state[partial_state.id];
}