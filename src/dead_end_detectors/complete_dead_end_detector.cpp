#include "complete_dead_end_detector.hpp"
#include <fstream>

bool have_good_actions(const Task& task, const State& state, const StateActionPairToBoolMap& is_bad_state_action_pair)
{
    for (const Action &action : state.get_applicable_actions(task.actions()))
    {
        if (not is_bad_state_action_pair.at(std::make_pair(state, action)))
        {
            return true;
        }
    }
    return false;
}

void create_states(const Task &task, const vec<Fact> &facts, set<State> &states, const int depth)
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
            newFacts.emplace_back(fact);
            create_states(task, newFacts, states, depth + 1);
        }
    }
}

void CompleteDeadEndDetector::find_weak_alive_states(const set<State> &goal_states, map<State, StateActionPairSet> &reversed_edges, set<State> &weak_alive_states, const StateActionPairToBoolMap& is_bad_state_action_pair)
{
    vec<State> states_at_next_depth;
    vec<State> states_at_current_depth = vec<State>(goal_states.begin(), goal_states.end());
    set<State> visited = goal_states;

    while (not(states_at_current_depth.empty() and states_at_next_depth.empty()))
    {
        if (states_at_current_depth.empty())
        {
            states_at_current_depth.swap(states_at_next_depth);
        }
        State state = states_at_current_depth.back();
        states_at_current_depth.pop_back();
        if (this->labeled_states.contains(state.id) and this->labeled_states[state.id] == DEAD_END)
        {
            continue;
        }
        for (auto state_action_pair : reversed_edges[state])
        {
            if (is_bad_state_action_pair.at(state_action_pair))
            {
                continue;
            }
            State predecessor_state = state_action_pair.first;
            Action action = state_action_pair.second;
            if (visited.contains(predecessor_state))
            {
                continue;
            }
            else
            {
                states_at_next_depth.push_back(predecessor_state);
                visited.insert(predecessor_state);
                if (not this->labeled_states.contains(predecessor_state.id))
                {
                    this->labeled_states[predecessor_state.id] = WEAK_ALIVE;
                    weak_alive_states.insert(predecessor_state);
                }
            }
        }
    }
}

void CompleteDeadEndDetector::find_dead_end_states(const set<State> &states, set<State> &dead_end_states, set<State>& became_dead_end_state_on_previous_iteration)
{
    for (const State &state : states)
    {
        if (not this->labeled_states.contains(state.id))
        {
            this->labeled_states[state.id] = DEAD_END;
            dead_end_states.insert(state);
            became_dead_end_state_on_previous_iteration.insert(state);
        }
    }
}

void CompleteDeadEndDetector::test_whether_weak_alive_states_are_dead_end_states(set<State> &weak_alive_states, set<State> &dead_end_states, set<State> &became_dead_end_state_on_previous_iteration)
{
    bool all_actions_are_bad = true;
    do
    {
        State weak_alive_state;
        all_actions_are_bad = true;
        for (auto it = weak_alive_states.begin(); it != weak_alive_states.end(); it++)
        {
            all_actions_are_bad = true;
            weak_alive_state = *it;
            for (const Action &action : weak_alive_state.get_applicable_actions(task.actions()))
            {
                bool is_dead_end = false;
                for (const State &successor_state : weak_alive_state.get_successors(action))
                {
                    if (dead_end_states.contains(successor_state))
                    {
                        is_dead_end = true;
                        break;
                    }
                }
                if (not is_dead_end)
                {
                    all_actions_are_bad = false;
                    break;
                }
            }
            if (all_actions_are_bad)
                break;
        }
        if (all_actions_are_bad)
        {
            this->labeled_states[weak_alive_state.id] = DEAD_END;
            dead_end_states.insert(weak_alive_state);
            became_dead_end_state_on_previous_iteration.insert(weak_alive_state);
            weak_alive_states.erase(weak_alive_state);
        }
    } while (all_actions_are_bad);
}

void CompleteDeadEndDetector::mark_goal_states_as_alive(const Task &task, const set<State> &states, map<State, StateActionPairSet> &reversed_edges, set<State> &goal_states, set<State> &non_goal_states, StateActionPairToBoolMap& is_bad_state_action_pair)
{
    vec<State> stack;
    set<State> states_to_explore = states;
    stack.push_back(task.initial_state());
    while (not states_to_explore.empty() or not stack.empty())
    {
        while (not stack.empty())
        {
            State state = stack.back();
            stack.pop_back();
            states_to_explore.erase(state);

            if (state.is_goal(task.goal_condition()))
            {
                this->labeled_states[state.id] = ALIVE;
                goal_states.insert(state);
                continue;
            }

            non_goal_states.insert(state);
            for (const Action &action : state.get_applicable_actions(task.actions()))
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

void CompleteDeadEndDetector::transform_weak_alive_states_into_alive_states(const set<State> &weak_alive_states)
{
    for (auto weak_alive_state : weak_alive_states)
    {
        this->labeled_states[weak_alive_state.id] = ALIVE;
    }
}

void count_and_print(const set<State> &states, const set<State> &goal_states, const set<State> &non_goal_states, const map<int64_t, int> &labeled_states, const int iterations)
{
    int dead_end_states_count = 0, alive_count = 0, weak_alive_count = 0;

    std::ofstream states_file("states.txt");
    if (not states_file.is_open())
    {
        std::cerr << "LOG::CompleteDeadEndDetector::save_states::Error opening states file." << std::endl;
        return;
    }

    for (auto [state_id, label] : labeled_states)
    {
        State state;
        state.id = state_id;
        states_file << state << " -> " << state_label_to_string[label] << std::endl;

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
    states_file.close();

    std::ofstream metadata_file("metadata.csv");
    if (not metadata_file.is_open())
    {
        std::cerr << "LOG::CompleteDeadEndDetector::save_metadata::Error opening metadata file." << std::endl;
        return;
    }
    metadata_file << "Metric,Count\n";
    metadata_file << "DeadEndStates," << dead_end_states_count << "\n";
    metadata_file << "AliveStates," << alive_count << "\n";
    metadata_file << "WeakAliveStates," << weak_alive_count << "\n";
    metadata_file << "TotalStates," << states.size() << "\n";
    metadata_file << "GoalStates," << goal_states.size() << "\n";
    metadata_file << "NonGoalStates," << non_goal_states.size() << "\n";
    metadata_file << "Iterations," << iterations << "\n";
    metadata_file.close();
    assert(states.size() == goal_states.size() + non_goal_states.size());
    assert(weak_alive_count == 0);
    assert(states.size() == dead_end_states_count + alive_count);
}

void CompleteDeadEndDetector::unlabel_weak_alive_states_before_performing_loop(set<State> &weak_alive_states, int &number_of_weak_alive_states_on_previous_iteration)
{
    number_of_weak_alive_states_on_previous_iteration = weak_alive_states.size();
    if (not weak_alive_states.empty())
    {
        for (auto weak_alive_state : weak_alive_states)
        {
            this->labeled_states.erase(weak_alive_state.id);
        }
    }
}
// TODO: add only the new dead-ends to the bad_state_action_pairs instead of all the previous dead-ends
void CompleteDeadEndDetector::find_bad_actions(map<State, StateActionPairSet> &reversed_edges, StateActionPairToBoolMap& is_bad_state_action_pair, set<State>& became_dead_end_state_on_previous_iteration)
{
    for (auto dead_end_state : became_dead_end_state_on_previous_iteration)
    {
        for (auto pair_state_action : reversed_edges[dead_end_state])
        {
            is_bad_state_action_pair[pair_state_action] = true;
        }
    }
    became_dead_end_state_on_previous_iteration.clear();
}

bool CompleteDeadEndDetector::is_deadend(const State &state) const
{
    return this->labeled_states.at(state.id) == DEAD_END;
}

CompleteDeadEndDetector::CompleteDeadEndDetector(const Task &task, const bool save_metadata) : DeadEndDetector(task)
{
    // 1.
    set<State> states;
    create_states(this->task, vec<Fact>(), states, 0); 

    // 2.
    map<int64_t, int64_t> predecessor;
    map<State, StateActionPairSet> reversed_edges;
    set<State> goal_states;
    set<State> non_goal_states;
    StateActionPairToBoolMap is_bad_state_action_pair;
    this->mark_goal_states_as_alive(this->task, states, reversed_edges, goal_states, non_goal_states, is_bad_state_action_pair);

    // loop 3,4,5 until there is no change in the number of weak alive states
    set<State> weak_alive_states;
    set<State> dead_end_states;
    set<State> became_dead_end_state_on_previous_iteration;
    int number_of_weak_alive_states_on_previous_iteration = 0, it = 0;
    do
    {   
        // TODO: create a map[<state, action>] -> bool so that find_weak_alive_states is only processed to the new modified bad actions
        // prepare for the next iteration
        ++it;
        this->unlabel_weak_alive_states_before_performing_loop(weak_alive_states, number_of_weak_alive_states_on_previous_iteration);
        this->find_bad_actions(reversed_edges, is_bad_state_action_pair, became_dead_end_state_on_previous_iteration);
        
        // 3.
        this->find_weak_alive_states(goal_states, reversed_edges, weak_alive_states, is_bad_state_action_pair);
        
        // 4.
        this->find_dead_end_states(non_goal_states, dead_end_states, became_dead_end_state_on_previous_iteration);
        
        // 5.
        this->test_whether_weak_alive_states_are_dead_end_states(weak_alive_states, dead_end_states, became_dead_end_state_on_previous_iteration);
    } while (not(number_of_weak_alive_states_on_previous_iteration == weak_alive_states.size()));

    // 6.
    this->transform_weak_alive_states_into_alive_states(weak_alive_states);

    if (save_metadata)
    {
        count_and_print(states, goal_states, non_goal_states, this->labeled_states, it);
    }
};