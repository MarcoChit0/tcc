#include "complete_dead_end_detector.hpp"
#include <fstream>

bool CompleteDeadEndDetector::have_good_actions(const State &state, const StateActionPairToBoolMap &is_bad_state_action_pair)
{
    for (const Action &action : state.get_applicable_actions(this->task.actions()))
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

void CompleteDeadEndDetector::find_weak_alive_states(
    map<State, StateActionPairSet> &reversed_edges,
    const set<State> &goal_states,
    set<State> &weak_alive_states,
    const StateActionPairToBoolMap &is_bad_state_action_pair)
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
        if (this->labeled_states[state.id] == DEAD_END)
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
                if (this->labeled_states[predecessor_state.id] == NO_LABEL)
                {
                    this->labeled_states[predecessor_state.id] = WEAK_ALIVE;
                    weak_alive_states.insert(predecessor_state);
                }
            }
        }
    }
}

void CompleteDeadEndDetector::find_dead_end_states(
    map<State, StateActionPairSet> &reversed_edges,
    const set<State> &states,
    set<State> &dead_end_states,
    StateActionPairToBoolMap &is_bad_state_action_pair)
{
    for (const State &state : states)
    {
        if (this->labeled_states[state.id] == NO_LABEL)
        {
            this->labeled_states[state.id] = DEAD_END;
            dead_end_states.insert(state);
            mark_bad_state_action_pairs(reversed_edges, state, is_bad_state_action_pair);
        }
    }
}

void CompleteDeadEndDetector::test_whether_weak_alive_states_are_dead_end_states(
    map<State, StateActionPairSet> &reversed_edges,
    set<State> &dead_end_states,
    set<State> &weak_alive_states,
    StateActionPairToBoolMap &is_bad_state_action_pair)
{
    for (auto it = weak_alive_states.begin(); it != weak_alive_states.end();)
    {
        auto state = *it;
        it++;
        if (not have_good_actions(state, is_bad_state_action_pair))
        {
            this->labeled_states[state.id] = DEAD_END;
            dead_end_states.insert(state);
            mark_bad_state_action_pairs(reversed_edges, state, is_bad_state_action_pair);
            weak_alive_states.erase(state);
        }
    }
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

void CompleteDeadEndDetector::transform_weak_alive_states_into_alive_states(const set<State> &weak_alive_states)
{
    for (auto weak_alive_state : weak_alive_states)
    {
        this->labeled_states[weak_alive_state.id] = ALIVE;
    }
}

void count_and_print(const set<State> &states, const set<State> &goal_states, const set<State> &non_goal_states, const map<int64_t, int> &labeled_states)
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
    metadata_file.close();
    assert(states.size() == goal_states.size() + non_goal_states.size());
    assert(weak_alive_count == 0);
    assert(states.size() == dead_end_states_count + alive_count);
}

void CompleteDeadEndDetector::unlabel_weak_alive_states_before_performing_loop(set<State> &weak_alive_states)
{
    for (auto weak_alive_state : weak_alive_states)
    {
        this->labeled_states[weak_alive_state.id] = NO_LABEL;
    }
    weak_alive_states.clear();
}
// TODO: add only the new dead-ends to the bad_state_action_pairs instead of all the previous dead-ends
void CompleteDeadEndDetector::mark_bad_state_action_pairs(
    map<State, StateActionPairSet> &reversed_edges,
    const State &dead_end_state,
    StateActionPairToBoolMap &is_bad_state_action_pair)
{
    for (auto pair_state_action : reversed_edges[dead_end_state])
    {
        is_bad_state_action_pair[pair_state_action] = true;
    }
}

bool CompleteDeadEndDetector::is_deadend(const State &state) const
{
    return this->labeled_states.at(state.id) == DEAD_END;
}

bool CompleteDeadEndDetector::forward_search(
    const State &initial_state,
    StateActionPairToBoolMap &is_bad_state_action_pair)
{
    vec<State> stack;
    set<State> explored;
    stack.push_back(initial_state);
    while (not stack.empty())
    {
        State state = stack.back();
        stack.pop_back();
        explored.insert(state);

        if (state.is_goal(this->task.goal_condition()))
        {
            return true;
        }

        for (const Action &action : state.get_applicable_actions(this->task.actions()))
        {
            if (not is_bad_state_action_pair.at(std::make_pair(state, action)))
            {
                for (const State &succesor_state : state.get_successors(action))
                {
                    if (not explored.contains(succesor_state))
                    {
                        stack.push_back(succesor_state);
                    }
                }
            }
        }
    }
    return false;
}

void CompleteDeadEndDetector::loop_until_there_is_no_more_dead_ends_on_weak_alive_set(
    map<State, StateActionPairSet> &reversed_edges,
    set<State> &dead_end_states,
    set<State> &weak_alive_states,
    StateActionPairToBoolMap &is_bad_state_action_pair)
{
    std::ofstream log_file("dead-end-log.txt", std::ios_base::app);
    int number_of_dead_end_states_on_previous_iteration, i = 0;
    bool changed;
    do
    {
        changed = false;
        number_of_dead_end_states_on_previous_iteration = dead_end_states.size();
        log_file << "5. Iteration = " << ++i << std::endl;
        log_file << "\t5.1 Number of dead end states = " << dead_end_states.size() << std::endl;
        log_file << "\t5.1 Number of weak alive states = " << weak_alive_states.size() << std::endl;
        this->test_whether_weak_alive_states_are_dead_end_states(reversed_edges, dead_end_states, weak_alive_states, is_bad_state_action_pair);
        log_file << "\t5.2 Number of dead end states = " << dead_end_states.size() << std::endl;
        log_file << "\t5.2 Number of weak alive states = " << weak_alive_states.size() << std::endl;
        log_file << "\t5.2 Ended at " << get_ellapsed_time() << std::endl;
        if (number_of_dead_end_states_on_previous_iteration == dead_end_states.size())
        {
            break;
        }
        for (auto it = weak_alive_states.begin(); it != weak_alive_states.end();)
        {
            auto state = *it;
            it++;
            if (not this->forward_search(state, is_bad_state_action_pair))
            {
                changed = true;
                weak_alive_states.erase(state);
                dead_end_states.insert(state);
                this->labeled_states[state.id] = DEAD_END;
                mark_bad_state_action_pairs(reversed_edges, state, is_bad_state_action_pair);
            }
        }
        log_file << "\t5.3 Number of dead end states = " << dead_end_states.size() << std::endl;
        log_file << "\t5.3 Number of weak alive states = " << weak_alive_states.size() << std::endl;
        log_file << "\t5.3 Ended at " << get_ellapsed_time() << std::endl;
    } while (changed);
    log_file << "5. Ended at " << get_ellapsed_time() << std::endl;
    log_file.close();
}

CompleteDeadEndDetector::CompleteDeadEndDetector(const Task &task, const bool save_metadata) : DeadEndDetector(task)
{
    std::ofstream log_file("dead-end-log.txt");
    // 1.
    log_file << "1. Creating states\n";
    set<State> states;
    create_states(this->task, vec<Fact>(), states, 0);
    log_file << "1. States created: " << states.size() << std::endl;
    log_file << "1. Ended at " << get_ellapsed_time() << std::endl;

    // 2.
    map<int64_t, int64_t> predecessor;
    map<State, StateActionPairSet> reversed_edges;
    set<State> goal_states;
    set<State> non_goal_states;
    StateActionPairToBoolMap is_bad_state_action_pair;
    log_file << "2. Creating reversed edges\n";
    this->mark_goal_states_as_alive(reversed_edges, states, goal_states, non_goal_states, is_bad_state_action_pair);
    log_file << "2. Reversed edges created\n";
    log_file << "2. Goal states: " << goal_states.size() << std::endl;
    log_file << "2. Non goal states: " << non_goal_states.size() << std::endl;
    log_file << "2. Ended at " << get_ellapsed_time() << std::endl;

    // loop 3,4,5 until there is no change in the number of weak alive states
    set<State> weak_alive_states;
    set<State> dead_end_states;
    int number_of_dead_end_states;
    do
    {
        // 3.
        log_file << "3. Unlabeling weak alive states before performing loop\n";
        log_file << "3. Number of weak alive states = " << weak_alive_states.size() << std::endl;
        this->unlabel_weak_alive_states_before_performing_loop(weak_alive_states);
        log_file << "3. Finding weak alive states\n";
        this->find_weak_alive_states(reversed_edges, goal_states, weak_alive_states, is_bad_state_action_pair);
        log_file << "3. Number of weak alive states =" << weak_alive_states.size() << std::endl;
        log_file << "3. Ended at " << get_ellapsed_time() << std::endl;

        // 4.
        log_file << "4. Finding dead end states\n";
        number_of_dead_end_states = dead_end_states.size();
        this->find_dead_end_states(reversed_edges, states, dead_end_states, is_bad_state_action_pair);
        log_file << "4. Number of dead end states = " << dead_end_states.size() << std::endl;
        log_file << "4. Ended at " << get_ellapsed_time() << std::endl;

        // 5.
        log_file << "5. Finding dead end states on weak alive set\n";
        log_file << "5. Number of dead end states before = " << dead_end_states.size() << std::endl;
        log_file << "5. Number of weak alive states before = " << weak_alive_states.size() << std::endl;
        this->test_whether_weak_alive_states_are_dead_end_states(reversed_edges, dead_end_states, weak_alive_states, is_bad_state_action_pair);
        log_file << "5. Number of dead end states after = " << dead_end_states.size() << std::endl;
        log_file << "5. Number of weak alive states = " << weak_alive_states.size() << std::endl;
    } while (number_of_dead_end_states != dead_end_states.size());

    // 6.
    log_file << "6. Transforming weak alive states into alive states\n";
    this->transform_weak_alive_states_into_alive_states(weak_alive_states);
    log_file << "6. Weak alive states transformed into alive states\n";
    log_file << "6. Alive states: " << weak_alive_states.size() << std::endl;
    log_file << "6. Dead end states: " << dead_end_states.size() << std::endl;
    log_file << "6. Ended at " << get_ellapsed_time() << std::endl;

    if (save_metadata)
    {
        count_and_print(states, goal_states, non_goal_states, this->labeled_states);
    }
};