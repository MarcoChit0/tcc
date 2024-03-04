#include "complete_dead_end_detector.hpp"

void CompleteDeadEndDetector::create_states_recursive_procedure(const int depth, const vec<Fact> &facts, set<State> &states)
{
    if (depth == this->task.variables().size())
    {
        State s(facts);
        states.insert(s);
    }
    else
    {
        for (auto fact : task.variables()[depth].facts())
        {
            vec<Fact> newFacts = facts;
            newFacts.emplace_back(fact);
            create_states_recursive_procedure(depth + 1, newFacts, states);
        }
    }
}

void CompleteDeadEndDetector::create_states(const vec<Fact> &facts, set<State> &states)
{
    create_states_recursive_procedure(0, facts, states);
}

void CompleteDeadEndDetector::mark_goal_states_as_alive(
    map<State, StateActionPairSet> &reversed_edges,
    const set<State> &states,
    set<State> &goal_states,
    set<State> &non_goal_states,
    StateActionPairToBoolMap &is_bad_state_action_pair)
{
    vec<State> stack;
    set<State> states_to_explore = states;
    stack.push_back(this->task.initial_state());
    while (not states_to_explore.empty() or not stack.empty())
    {
        while (not stack.empty())
        {
            State state = stack.back();
            stack.pop_back();
            states_to_explore.erase(state);

            if (state.is_goal(this->task.goal_condition()))
            {
                this->labeled_states[state.id] = ALIVE;
                goal_states.insert(state);
                continue;
            }

            non_goal_states.insert(state);
            this->labeled_states[state.id] = NO_LABEL;
            for (const Action &action : state.get_applicable_actions(this->task.actions()))
            {
                is_bad_state_action_pair[std::make_pair(state, action)] = false;
                for (const State &succesor_state : state.get_successors(action))
                {
                    reversed_edges[succesor_state].insert(std::make_pair(state, action));
                    if (states_to_explore.contains(succesor_state))
                    {
                        stack.push_back(succesor_state);
                    }
                }
            }
        }
        if (stack.empty() and not states_to_explore.empty())
        {
            stack.push_back(*states_to_explore.begin());
            states_to_explore.erase(states_to_explore.begin());
        }
    }
    assert(states.size() == goal_states.size() + non_goal_states.size());
}

CompleteDeadEndDetector::CompleteDeadEndDetector(const Task &task) : ReachableDeadEndDetector(task)
{}
