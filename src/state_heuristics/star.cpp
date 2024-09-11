#include "./star.hpp"

Star::Star(const Task &task, const opt<std::shared_ptr<DeadEndDetector>> &dead_end_detector) : Heuristic(task), dead_end_detector(dead_end_detector)
{
    map<State, vec<State>> reverse_edges;
    vec<State> stack;
    set<State> non_goal_states;
    set<State> goal_states;

    auto is_good_action = [&](const State &state, const Action &action)
    {
        for (const State &successor_state : state.get_successors(action))
        {
            if ((*(this->dead_end_detector))->is_deadend(successor_state) == 1.0f)
            {
                return false;
            }
        }
        return true;
    };
    stack.push_back(task.initial_state());
    while (not stack.empty())
    {
        State state = stack.back();
        stack.pop_back();
        for (const Action &action : state.get_applicable_actions(task.actions()))
        {
            if (dead_end_detector.has_value() and not is_good_action(state, action))
            {
                continue;
            }
            for (const State &successor_state : state.get_successors(action))
            {
                reverse_edges[successor_state].push_back(state);
                if (successor_state.is_goal(task.goal_condition()))
                {
                    goal_states.insert(successor_state);
                }
                else
                {
                    if (not non_goal_states.contains(successor_state))
                    {
                        stack.push_back(successor_state);
                        non_goal_states.insert(successor_state);
                    }
                }
            }
        }
    }

    non_goal_states.clear();

    vec<State> states_at_current_depth;
    vec<State> states_at_next_depth;
    int current_depth = 0;

    auto &pdb = functions_storage[Function{&Star::operator[], *this}];

    for (const State &state : goal_states)
    {
        states_at_current_depth.push_back(state);
        pdb[state] = 0;
    }

    while (not(states_at_current_depth.empty() and states_at_next_depth.empty()))
    {
        if (states_at_current_depth.empty())
        {
            current_depth++;
            states_at_current_depth.swap(states_at_next_depth);
        }
        State state = states_at_current_depth.back();
        states_at_current_depth.pop_back();
        for (const State &successor_state : reverse_edges[state])
        {
            if (not pdb.contains(successor_state))
            {
                states_at_next_depth.push_back(successor_state);
                pdb[successor_state] = current_depth + 1;
            }
        }
    }
}

int Star::operator[](const State &state) const
{
    auto &pdb = functions_storage[Function{&Star::operator[], *this}];
    if (pdb.contains(state))
    {
        return pdb[state];
    }
    else
    {
        return +INFTY;
    }
};

set<State> Star::get_concrete_states(const PartialState &partial_state) const
{
    auto &data_base = functions_storage[Function{&Star::operator[], *this}];
    set<State> concrete_states;
    for (std::pair<Object, int64_t> pair : data_base)
    {
        State state;
        state.id = pair.first.id;
        if (partial_state.does_model(state) and state.does_model(partial_state))
        {
            concrete_states.insert(state);
        }
    }
    return concrete_states;
}

int Star::size() const
{
    auto &data_base = functions_storage[Function{&Star::operator[], *this}];
    return data_base.size();
}