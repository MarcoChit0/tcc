#include "reachable_dead_end_detector.hpp"

bool ReachableDeadEndDetector::have_good_actions(const State &state, const StateActionPairToBoolMap &is_bad_state_action_pair)
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

void ReachableDeadEndDetector::create_states(const vec<Fact> &facts, set<State> &states)
{
    std::cout << "LOG::ReachableDeadEndDetector::create_states::Creating states" << std::endl;
    std::stack<State> stack;
    stack.push(this->task.initial_state());
    while (not stack.empty())
    {
        State state = stack.top();
        stack.pop();
        states.insert(state);
        
        if (state.is_goal(this->task.goal_condition()))
        {
            continue;
        }

        for (auto action : state.get_applicable_actions(this->task.actions()))
        {
            for (auto successor_state : state.get_successors(action))
            {
                if (not states.contains(successor_state))
                {
                    stack.push(successor_state);
                }
            }
        }
    }
}

void ReachableDeadEndDetector::find_weak_alive_states(
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
        if (this->labeled_states[state.id] == HARD_DEAD_END or this->labeled_states[state.id] == EASY_DEAD_END)
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

void ReachableDeadEndDetector::find_easy_dead_end_states(
    map<State, StateActionPairSet> &reversed_edges,
    const set<State> &states,
    set<State> &dead_end_states,
    StateActionPairToBoolMap &is_bad_state_action_pair)
{
    std::stack<State> stack;
    for (const State &state : states)
    {
        if (this->labeled_states[state.id] == NO_LABEL)
        {
            this->labeled_states[state.id] = EASY_DEAD_END;
            dead_end_states.insert(state);
            stack.push(state);
        }
    }
    while (not stack.empty())
    {
        State state = stack.top();
        stack.pop();
        mark_bad_state_action_pairs(reversed_edges, state, dead_end_states, is_bad_state_action_pair);
    }
}

void ReachableDeadEndDetector::find_hard_dead_end_states(
    map<State, StateActionPairSet> &reversed_edges,
    const set<State> &states,
    set<State> &dead_end_states,
    StateActionPairToBoolMap &is_bad_state_action_pair)
{
    for (const State &state : states)
    {
        if (this->labeled_states[state.id] == NO_LABEL)
        {
            this->labeled_states[state.id] = HARD_DEAD_END;
            dead_end_states.insert(state);
            mark_bad_state_action_pairs(reversed_edges, state, dead_end_states, is_bad_state_action_pair);
        }
    }
}

void ReachableDeadEndDetector::mark_goal_states_as_alive(
    map<State, StateActionPairSet> &reversed_edges,
    const set<State> &states,
    set<State> &goal_states,
    set<State> &non_goal_states,
    StateActionPairToBoolMap &is_bad_state_action_pair)
{
    std::cout << "LOG::ReachableDeadEndDetector::mark_goal_states_as_alive::Marking goal states as alive" << std::endl;
    vec<State> stack;
    set<State> visited;
    stack.push_back(this->task.initial_state());

    while (not stack.empty())
    {
        State state = stack.back();
        stack.pop_back();
        visited.insert(state);

        if (state.is_goal(this->task.goal_condition()))
        {
            this->labeled_states[state.id] = ALIVE;
            goal_states.insert(state);
            continue;
        }
        this->labeled_states[state.id] = NO_LABEL;
        non_goal_states.insert(state);

        for (const Action &action : state.get_applicable_actions(this->task.actions()))
        {
            is_bad_state_action_pair[std::make_pair(state, action)] = false;
            for (const State &succesor_state : state.get_successors(action))
            {
                reversed_edges[succesor_state].insert(std::make_pair(state, action));
                if (not visited.contains(succesor_state))
                {
                    stack.push_back(succesor_state);
                }
            }
        }
    }
}

void ReachableDeadEndDetector::transform_weak_alive_states_into_alive_states(const set<State> &weak_alive_states)
{
    for (auto weak_alive_state : weak_alive_states)
    {
        this->labeled_states[weak_alive_state.id] = ALIVE;
    }
}

void ReachableDeadEndDetector::count_and_print(
    const set<State> &goal_states,
    const set<State> &non_goal_states,
    const set<State> &states)
{
    int hard_dead_end_count = 0, alive_count = 0, weak_alive_count = 0, easy_dead_end_count = 0;

    // commented for not to exceed memory limit on server
    std::ofstream labels_file(dead_end_directory+DEAD_END_LABELS_FILE);
    if (not labels_file.is_open())
    {
        std::cerr << "LOG::ReachableDeadEndDetector::save_states::Error opening states file." << std::endl;
        return;
    }

    for (auto [state_id, label] : labeled_states)
    {
        State state;
        state.id = state_id;
        labels_file << state << " -> " << state_label_to_string[label] << std::endl;

        switch (label)
        {
        case HARD_DEAD_END:
            hard_dead_end_count++;
            break;
        case EASY_DEAD_END:
            easy_dead_end_count++;
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
    labels_file.close();

    std::ofstream metadata_file(dead_end_directory + DEAD_END_METADATA_FILE);
    if (not metadata_file.is_open())
    {
        std::cerr << "LOG::ReachableDeadEndDetector::save_metadata::Error opening metadata file." << std::endl;
        return;
    }
    metadata_file << "Metric,Count\n";
    metadata_file << "HardDeadEndStates," << hard_dead_end_count << "\n";
    metadata_file << "SoftDeadEndStates," << easy_dead_end_count << "\n";
    metadata_file << "AliveStates," << alive_count << "\n";
    metadata_file << "WeakAliveStates," << weak_alive_count << "\n";
    metadata_file << "TotalStates," << states.size() << "\n";
    metadata_file << "GoalStates," << goal_states.size() << "\n";
    metadata_file << "NonGoalStates," << non_goal_states.size() << "\n";
    metadata_file.close();
    assert(states.size() == goal_states.size() + non_goal_states.size());
    assert(weak_alive_count == 0);
    assert(states.size() == hard_dead_end_count + easy_dead_end_count + alive_count);
}

void ReachableDeadEndDetector::unlabel_weak_alive_states_before_performing_loop(set<State> &weak_alive_states)
{
    for (auto weak_alive_state : weak_alive_states)
    {
        if (this->labeled_states[weak_alive_state.id] == WEAK_ALIVE)
        {
            this->labeled_states[weak_alive_state.id] = NO_LABEL;
        }
    }
    weak_alive_states.clear();
}

void ReachableDeadEndDetector::mark_bad_state_action_pairs(
    map<State, StateActionPairSet> &reversed_edges,
    const State &dead_end_state,
    set<State> &dead_end_states,
    StateActionPairToBoolMap &is_bad_state_action_pair)
{
    for (auto pair_state_action : reversed_edges[dead_end_state])
    {
        is_bad_state_action_pair[pair_state_action] = true;
    }
    // recursively check whether the predecessor states have become dead-ends when the bad state-action pairs are marked
    for (auto pair_state_action : reversed_edges[dead_end_state])
    {
        State predecessor_state = pair_state_action.first;
        if (not have_good_actions(predecessor_state, is_bad_state_action_pair) and not this->labeled_states[predecessor_state.id] == ALIVE and not this->labeled_states[predecessor_state.id] == EASY_DEAD_END)
        {
            this->labeled_states[predecessor_state.id] = HARD_DEAD_END;
            dead_end_states.insert(predecessor_state);
            mark_bad_state_action_pairs(reversed_edges, predecessor_state, dead_end_states, is_bad_state_action_pair);
        }
    }
}

double ReachableDeadEndDetector::is_deadend(const State &state) const
{
    if (this->labeled_states.at(state.id) == HARD_DEAD_END or this->labeled_states.at(state.id) == EASY_DEAD_END)
    {
        return 1.0f;
    }
    else
    {
        return 0.0f;
    }
}

ReachableDeadEndDetector::ReachableDeadEndDetector(const Task &task) : DeadEndDetector(task){};

void ReachableDeadEndDetector::label_states(const bool save_metadata)
{
    std::ofstream log_file(dead_end_directory + this->file_name);
    // 1.
    log_file << "1. Creating states\n";
    set<State> states;
    create_states(vec<Fact>(), states);
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
    int iteration = 0;
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
        log_file << "4. Number of dead end states before = " << dead_end_states.size() << std::endl;
        if (iteration++)
        { // dead ends that are difficult to find
            this->find_hard_dead_end_states(reversed_edges, states, dead_end_states, is_bad_state_action_pair);
        }
        else
        { // dead ends that are not that interessing
            this->find_easy_dead_end_states(reversed_edges, states, dead_end_states, is_bad_state_action_pair);
        }
        log_file << "4. Number of dead end states after = " << dead_end_states.size() << std::endl;
        log_file << "4. Ended at " << get_ellapsed_time() << std::endl;
    } while (number_of_dead_end_states != dead_end_states.size());

    // 5.
    log_file << "5. Transforming weak alive states into alive states\n";
    this->transform_weak_alive_states_into_alive_states(weak_alive_states);
    log_file << "5. Weak alive states transformed into alive states\n";
    log_file << "5. Alive states: " << weak_alive_states.size() << std::endl;
    log_file << "5. Dead end states: " << dead_end_states.size() << std::endl;
    log_file << "5. Ended at " << get_ellapsed_time() << std::endl;

    if (save_metadata)
    {
        count_and_print(goal_states, non_goal_states, states);
    }
}