#include "deadend_detector.hpp"
#include <fstream>

map<int64_t, int> DeadEndDetector::labeled_states;

void create_states(const Task &task, const vec<Fact>& facts, set<State>& states, const int depth)
{
    if (depth == task.variables().size())
    {
        State s(facts);
        states.insert(s);
    }
    else
    {
        for (auto fact : task.variables()[depth].facts())
        {
            vec<Fact> newFacts = facts;
            newFacts.emplace_back(fact); // Append fact to the end of the vector
            create_states(task, newFacts, states, depth + 1);
        }
    }
}

DeadEndDetector::DeadEndDetector(const Task &task) : task(task)
{
    // 1.
    set<State> states;
    create_states(this->task, vec<Fact>(), states, 0);
    std::cerr << "LOG::DeadEndDetector::#1.\n";
    std::cerr << "LOG::DeadEndDetector::#States: " << states.size() << std::endl;

    map<int64_t, int64_t> predecessor;
    map<State, vec<State>> reversed_edges;
    vec<State> stack;
    set<State> goal_states;
    set<State> non_goal_states;
    set<State> visited;


    // 2.
    stack.push_back(task.initial_state());
    do
    {
        while (not stack.empty())
        {
            State state = stack.back();
            stack.pop_back();
            if(visited.contains(state))
            {
                continue;
            }
            visited.insert(state);

            if(state.is_goal(task.goal_condition()))
            {
                this->labeled_states[state.id] = ALIVE;
                // std::cerr << "LOG::DeadEndDetector::GoalState: [" << state << "] marked as alive directly." << std::endl;
                goal_states.insert(state);
                continue;
            }

            non_goal_states.insert(state);
            for (const Action &action : state.get_applicable_actions(task.actions()))
            {
                for (const State &succesor_state : state.get_successors(action))
                {
                    reversed_edges[succesor_state].push_back(state);
                    stack.push_back(succesor_state);
                }
            }
        }
        if(stack.empty() and not (visited.size() == states.size()))
        {
            for(auto s : states)
            {
                if(not visited.contains(s))
                {
                    stack.push_back(s);
                    break;
                }
            }
        }
    } while (not (visited.size() == states.size() and stack.empty()));
    std::cerr << "LOG::DeadEndDetector::#2.\n";
    std::cerr << "LOG::DeadEndDetector::#GoalStates: " << goal_states.size() << std::endl;
    std::cerr << "LOG::DeadEndDetector::#NonGoalStates: " << non_goal_states.size() << std::endl;
    assert (states.size() == goal_states.size() + non_goal_states.size());

    // 3.
    set<State> weak_alive_states;
    map<
    vec<State> states_at_next_depth;
    vec<State> states_at_current_depth = vec<State>(goal_states.begin(), goal_states.end());
    visited = goal_states;

    while(not (states_at_current_depth.empty() and states_at_next_depth.empty()))
    {
        if(states_at_current_depth.empty())
        {
            states_at_current_depth.swap(states_at_next_depth);
        }
        State state = states_at_current_depth.back();
        states_at_current_depth.pop_back();
        for(const State& predecessor_state : reversed_edges[state])
        {
            if(visited.contains(predecessor_state))
            {
                continue;
            }
            else
            {
                states_at_next_depth.push_back(predecessor_state);
                visited.insert(predecessor_state);
                if(not this->labeled_states.contains(predecessor_state.id))
                {
                    this->labeled_states[predecessor_state.id] = WEAK_ALIVE;
                    // std::cerr << "LOG::DeadEndDetector::State: [" << predecessor_state << "] marked as WeakAlive." << std::endl;
                    weak_alive_states.insert(predecessor_state);
                }
            }
        }
    }
    std::cerr << "LOG::DeadEndDetector::#3.\n";
    std::cerr << "LOG::DeadEndDetector::WeakAliveStates after adding new states: " << weak_alive_states.size() << std::endl;
    
    
    // 4.
    set<State> dead_end_states;
    for (const State &state : states)
    {
        if(not this->labeled_states.contains(state.id))
        {
            this->labeled_states[state.id] = DEAD_END;
            // std::cerr << "LOG::DeadEndDetector::State: [" << state << "] marked as DeadEnd." << std::endl;
            dead_end_states.insert(state);
        }
    }
    std::cerr << "LOG::DeadEndDetector::#4.\n";
    std::cerr << "LOG::DeadEndDetector::States: " << states.size() << std::endl;
    std::cerr << "LOG::DeadEndDetector::DeadEndStates: " << dead_end_states.size() << std::endl;
    std::cerr << "LOG::DeadEndDetector::WeakAliveStates: " << weak_alive_states.size() << std::endl;
    std::cerr << "LOG::DeadEndDetector::AliveStates: " << goal_states.size() << std::endl;

    // 5.
    bool all_actions_are_bad = true;
    do
    {
        State weak_alive_state;
        all_actions_are_bad = true;
        for(auto it = weak_alive_states.begin(); it != weak_alive_states.end(); it++)
        {
            all_actions_are_bad = true;
            weak_alive_state = *it;
            for(const Action& action : weak_alive_state.get_applicable_actions(task.actions()))
            {
                bool is_dead_end = false;
                for(const State& successor_state : weak_alive_state.get_successors(action))
                {
                    if(dead_end_states.contains(successor_state))
                    {
                        is_dead_end = true;
                        break;
                    }
                }
                if(not is_dead_end)
                {
                    all_actions_are_bad = false;
                    break;
                }
            }
            if(all_actions_are_bad) break;
        }
        if(all_actions_are_bad)
        {
            this->labeled_states[weak_alive_state.id] = DEAD_END;
            // std::cerr << "LOG::DeadEndDetector::WeakAliveState: [" << weak_alive_state << "] now marked as DeadEnd." << std::endl;
            dead_end_states.insert(weak_alive_state);
            weak_alive_states.erase(weak_alive_state);
        }
    } while (all_actions_are_bad);
    std::cerr << "LOG::DeadEndDetector::#5." << std::endl;
    std::cerr << "LOG::DeadEndDetector::WeakAliveStates: " << weak_alive_states.size() << std::endl;

    

    // 6.
    for (auto weak_alive_state : weak_alive_states)
    {
        this->labeled_states[weak_alive_state.id] = ALIVE;
        // std::cerr << "LOG::DeadEndDetector::WeakAliveState: [" << weak_alive_state << "] now marked as Alive." << std::endl;
    }

    int dead_end_states_count = 0, alive_count = 0, weak_alive_count = 0;
    std::ofstream file("deadend_states.txt");
    for(auto [state_id, label] : this->labeled_states)
    {
        file << state_id << " -> " << state_label_to_string[label] << std::endl;
        switch (label)
        {
        case DEAD_END:
            dead_end_states_count++;
            break;
        case ALIVE:
            alive_count++;
            break;
        case WEAK_ALIVE:
            weak_alive_count++;
            break;
        default:
            break;
        }
    }
    std::cerr << "LOG::DeadEndDetector::#6." << std::endl;
    std::cerr << "LOG::DeadEndDetector::DeadEndStates: " << dead_end_states_count << std::endl;
    std::cerr << "LOG::DeadEndDetector::AliveStates: " << alive_count << std::endl;
    std::cerr << "LOG::DeadEndDetector::WeakAliveStates: " << weak_alive_count << std::endl;
    std::cerr << "LOG::DeadEndDetector::#States: " << states.size() << std::endl;
    std::cerr << "LOG::DeadEndDetector::#GoalStates: " << goal_states.size() << std::endl;
    std::cerr << "LOG::DeadEndDetector::#NonGoalStates: " << non_goal_states.size() << std::endl;
    assert(states.size() == goal_states.size() + non_goal_states.size());
    assert(weak_alive_count == 0);
    assert(states.size() == dead_end_states_count + alive_count);
    end_program();
};

bool DeadEndDetector::operator[](const State &state) const
{
    return true;
}