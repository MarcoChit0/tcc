#include "./star.hpp"

Star::Star(const Task &task) : Heuristic(task)
{
    map<State, vec<State>> reverse_edges;
    vec<State> stack;
    set<State> non_goal_states;
    set<State> goal_states;

    stack.push_back(task.initial_state());
    while (not stack.empty())
    {
        State state = stack.back();
        stack.pop_back();
        for (const Action &action: state.get_applicable_actions(task.actions()))
        {
            for (const State &succesor_state: state.get_successors(action))
            {
                reverse_edges[succesor_state].push_back(state);
                if (succesor_state.is_goal(task.goal_condition()))
                {
                    goal_states.insert(succesor_state);
                }
                else
                {
                    if (not non_goal_states.contains(succesor_state))
                    {
                        stack.push_back(succesor_state);
                        non_goal_states.insert(succesor_state);
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

    for (const State &state: goal_states)
    {
        states_at_current_depth.push_back(state);
        pdb[state] = 0;
    }

    while (not (states_at_current_depth.empty() and states_at_next_depth.empty()))
    {
        if (states_at_current_depth.empty())
        {
            current_depth++;
            states_at_current_depth.swap(states_at_next_depth);
        }
        State state = states_at_current_depth.back();
        states_at_current_depth.pop_back();
        for (const State &successor_state: reverse_edges[state])
        {
            if (not pdb.contains(successor_state))
            {
                states_at_next_depth.push_back(successor_state);
                pdb[successor_state] = current_depth + 1;
            }
        }
    }
    std::cout << "LOG::Star::pdb.size(): " << pdb.size() << std::endl;
    for(std::pair<Object, int64_t> pair : pdb)
    {
        State state;
        state.id = pair.first.id;
        this->trie.add(state);
    }
    this->trie.print();
    std::cout << "LOG::Star::trie generated\n";
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

vec<State> Star::get_concrete_states(const PartialState &partial_state) const
{
    // if (not partial_state_to_concrete_state.contains(partial_state.id))
    // {
    //     auto &data_base = functions_storage[Function{&Star::operator[], *this}];
    //     vec<State> concrete_states;
    //     for(std::pair<Object, int64_t> pair : data_base)
    //     {
    //         State state;
    //         state.id = pair.first.id;
    //         if (partial_state.does_model(state) and state.does_model(partial_state))
    //         {
    //             concrete_states.push_back(state);
    //         }
    //     }
    //     partial_state_to_concrete_state[partial_state.id] = concrete_states;
    // }
    // return partial_state_to_concrete_state[partial_state.id];
    std::cout << "LOG::Star::get_concrete_states::partial_state: " << partial_state << std::endl;
    set<State> states = this->trie.get_states(partial_state);
    for(State state : states)
    {
        std::cout << "LOG::Star::get_concrete_states::state: " << state << std::endl;
    }
    exit(1);
    return vec<State>(states.begin(), states.end());
}