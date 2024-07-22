#include "reachable_dead_end_detector.hpp"

// TODO: MAKE THIS A HASH MAP
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

// TODO: it could be a simple queue instead of two vectors
void ReachableDeadEndDetector::find_weak_alive_states(
    int iteration,
    map<State, StateActionPairSet> &reversed_edges,
    const set<State> &goal_states,
    set<State> &current_weak_alive_states,
    const StateActionPairToBoolMap &is_bad_state_action_pair)
{
    current_weak_alive_states.clear();

    std::queue<State> q = std::queue<State>();
    for (auto goal_state : goal_states)
    {
        q.push(goal_state);
    }

    set<State> visited = goal_states;

    while (not q.empty())
    {
        State state = q.front(); 
        q.pop();
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
                q.push(predecessor_state);
                visited.insert(predecessor_state);
                if (this->labeled_states[predecessor_state.id] >= WEAK_ALIVE)
                {
                    this->labeled_states[predecessor_state.id] = iteration;
                    current_weak_alive_states.insert(predecessor_state);
                }
            }
        }
    }
}

void ReachableDeadEndDetector::find_dead_end_states(
    int iteration,
    int dead_end_state_label,
    map<State, StateActionPairSet> &reversed_edges,
    set<State> &previous_weak_alive_states,
    StateActionPairToBoolMap &is_bad_state_action_pair)
{
    std::stack<State> stack;
    for (const State &state : previous_weak_alive_states)
    {
        if (this->labeled_states[state.id] != iteration)
        {
            if (this->first_dead_end_detected_time == -1)
            {
                this->first_dead_end_detected_time = get_elapsed_time();
            }
            this->labeled_states[state.id] = dead_end_state_label;
            stack.push(state);
        }
    }
    // TODO: comment this to check whteher this impacts on the correctess of the algorithm
    while (not stack.empty())
    {
        State state = stack.top();
        stack.pop();
        mark_bad_state_action_pairs(reversed_edges, state, is_bad_state_action_pair);
    }
}

void ReachableDeadEndDetector::mark_goal_states_as_alive(
    map<State, StateActionPairSet> &reversed_edges,
    set<State> &goal_states,
    set<State> &weak_alive,
    StateActionPairToBoolMap &is_bad_state_action_pair)
{
    set<State> states;
    vec<State> stack;
    stack.push_back(this->task.initial_state());

    while (not stack.empty())
    {
        State state = stack.back();
        stack.pop_back();
        states.insert(state);

        if (state.is_goal(this->task.goal_condition()))
        {
            this->labeled_states[state.id] = ALIVE;
            goal_states.insert(state);
        }
        else
        {
            weak_alive.insert(state);
            this->labeled_states[state.id] = WEAK_ALIVE;

            for (const Action &action : state.get_applicable_actions(this->task.actions()))
            {
                is_bad_state_action_pair[std::make_pair(state, action)] = false;
                for (const State &succesor_state : state.get_successors(action))
                {
                    reversed_edges[succesor_state].insert(std::make_pair(state, action));
                    if (not states.contains(succesor_state))
                    {
                        stack.push_back(succesor_state);
                    }
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

// TODO: change this function
void ReachableDeadEndDetector::count_and_print(
    const set<State> &goal_states)
{
    int hard_dead_end_count = 0, alive_count = 0, weak_alive_count = 0, easy_dead_end_count = 0;

    // commented for not to exceed memory limit on server
    // std::ofstream labels_file(dead_end_directory + DEAD_END_LABEL_TO_IP_FILE);
    // if (not labels_file.is_open())
    // {
    //     std::cerr << "LOG::ReachableDeadEndDetector::save_states::Error opening states file." << std::endl;
    //     return;
    // }

    for (auto [state_id, label] : labeled_states)
    {
        State state;
        state.id = state_id;
        // labels_file << state << " -> " << print_state_label(label) << std::endl;

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
        default:
            {
                if (label >= WEAK_ALIVE)
                {
                    weak_alive_count++;
                }
                else
                {
                    std::cerr << "LOG::ReachableDeadEndDetector::save_states::Invalid state label." << std::endl;
                }
            }
            break;
        }
    }
    // labels_file.close();

    std::ofstream metadata_file(dead_end_directory + DEAD_END_METADATA_FILE);
    if (not metadata_file.is_open())
    {
        std::cerr << "LOG::ReachableDeadEndDetector::save_metadata::Error opening metadata file." << std::endl;
        return;
    }
    metadata_file << "Metric,Count\n";
    metadata_file << "HardDeadEndStates," << hard_dead_end_count << "\n";
    metadata_file << "EasyDeadEndStates," << easy_dead_end_count << "\n";
    metadata_file << "AliveStates," << alive_count << "\n";
    metadata_file << "WeakAliveStates," << weak_alive_count << "\n";
    metadata_file << "TotalStates," << labeled_states.size() << "\n";
    metadata_file << "GoalStates," << goal_states.size() << "\n";
    metadata_file << "NonGoalStates," << labeled_states.size() - goal_states.size() << "\n";
    metadata_file.close();
}


void ReachableDeadEndDetector::mark_bad_state_action_pairs(
    map<State, StateActionPairSet> &reversed_edges,
    const State &dead_end_state,
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
            if (this->first_dead_end_detected_time == -1)
            {
                this->first_dead_end_detected_time = get_elapsed_time();
            }
            this->labeled_states[predecessor_state.id] = HARD_DEAD_END;
            mark_bad_state_action_pairs(reversed_edges, predecessor_state, is_bad_state_action_pair);
        }
    }
}

double ReachableDeadEndDetector::is_deadend(const State &state) const
{
    number_of_lookups++;
    if (this->labeled_states.at(state.id) == HARD_DEAD_END)
    {
        number_of_hard_dead_end_lookups++;
        number_of_useful_lookups++;
        return 1.0f;
    }
    else if (this->labeled_states.at(state.id) == EASY_DEAD_END)
    {
        number_of_easy_dead_end_lookups++;
        number_of_useful_lookups++;
        return 1.0f;
    }
    else
    {
        return 0.0f;
    }
}

ReachableDeadEndDetector::ReachableDeadEndDetector(const Task &task, const opt<int> &time_limit_seconds) : DeadEndDetector(task),
                                                                                                           time_limit_seconds(time_limit_seconds)
                                                                                                           {};

void ReachableDeadEndDetector::label_states(const bool save_metadata)
{
    std::ofstream log_file(dead_end_directory + DEAD_END_LOG_FILE);
    // 1.
    map<int64_t, int64_t> predecessor;
    map<State, StateActionPairSet> reversed_edges;
    set<State> goal_states;
    StateActionPairToBoolMap is_bad_state_action_pair;
    set<State> current_weak_alive_states;
    set<State> previous_weak_alive_states;

    if (this->time_limit_seconds.has_value())
    {
        log_file << "1. Running forward search with time constraints of " <<  this->time_limit_seconds.value() << " seconds\n";
        log_file << "1. Started at " << get_elapsed_time() << std::endl;
        std::future<void> response = std::async(std::launch::async, &ReachableDeadEndDetector::mark_goal_states_as_alive, this, std::ref(reversed_edges), std::ref(goal_states), std::ref(current_weak_alive_states), std::ref(is_bad_state_action_pair));
        if (response.wait_for(std::chrono::seconds(this->time_limit_seconds.value())) == std::future_status::ready)
        {
            response.get();
            log_file << "1. States sucessfully created within the time limit." << std::endl;
        }
        else
        {
            log_file << "1. States creation failed within the time limit." << std::endl;
            log_file << "1. Ending program execution at " << get_elapsed_time() << std::endl;
            exit(1);
        }
    }
    else
    {
        log_file << "1. Running forward search without time constraints.\n";
        log_file << "1. Started at " << get_elapsed_time() << std::endl;
        this->mark_goal_states_as_alive(reversed_edges, goal_states, current_weak_alive_states, is_bad_state_action_pair);
    }
    log_file << "1. Reversed edges created" << std::endl;
    log_file << "1. Goal states: " << goal_states.size() << std::endl;
    log_file << "1. Non goal states: " << current_weak_alive_states.size() << std::endl;
    log_file << "1. Total states: " << goal_states.size() + current_weak_alive_states.size() << std::endl;
    log_file << "1. Ended at " << get_elapsed_time() << std::endl;

    int iteration = WEAK_ALIVE;
    bool first_dead_end_detected = false, first_hard_dead_end_detected = false;
    
    while(true)
    {
        // 2.
        int dead_end_label = (iteration++ != WEAK_ALIVE) ? HARD_DEAD_END : EASY_DEAD_END;
        if(iteration == INFTY) 
        {
            throw std::runtime_error("LOG::ReachableDeadEndDetector::label_states::iteration_exceeded::" + std::to_string(iteration));
        }
        
        previous_weak_alive_states = current_weak_alive_states;

        log_file << "2. Iteration: " << iteration << std::endl;
        log_file << "2. Started at " << get_elapsed_time() << std::endl;
        log_file << "2. Previous weak alive states: " << previous_weak_alive_states.size() << std::endl;

        this->find_weak_alive_states(iteration, reversed_edges, goal_states, current_weak_alive_states, is_bad_state_action_pair);

        log_file << "2. Current weak alive states: " << current_weak_alive_states.size() << std::endl;
        log_file << "2. Ended at " << get_elapsed_time() << std::endl;

        if (previous_weak_alive_states.size() == current_weak_alive_states.size())
        {
            log_file << "2. No new weak alive states found." << std::endl;
            log_file << "2. Ending loop at " << get_elapsed_time() << std::endl;
            break;
        }

        // 3.
        log_file << "3. Started at " << get_elapsed_time() << std::endl;
        log_file << "3. Dead end label: " << print_state_label(dead_end_label) << std::endl;
        this->find_dead_end_states(iteration, dead_end_label, reversed_edges, previous_weak_alive_states, is_bad_state_action_pair);
        log_file << "3. " << previous_weak_alive_states.size() - current_weak_alive_states.size() << " dead end states found." << std::endl;
        log_file << "3. Ended at " << get_elapsed_time() << std::endl;

        if (this->first_dead_end_detected_time != -1 and not first_dead_end_detected)
        {
            log_file << "3. First dead end detected at " << this->first_dead_end_detected_time << std::endl;
            first_dead_end_detected = true;
        }
        if (this->first_hard_dead_end_detected_time != -1 and not first_hard_dead_end_detected)
        {
            log_file << "3. First hard dead end detected at " << this->first_hard_dead_end_detected_time << std::endl;
            first_hard_dead_end_detected = true;
        }
    }

    log_file << "4. Transforming weak alive states into alive states\n";
    this->transform_weak_alive_states_into_alive_states(current_weak_alive_states);
    log_file << "4. Weak alive states transformed into alive states\n";
    int alive_states = current_weak_alive_states.size() + goal_states.size();
    log_file << "4. Alive states: " << alive_states << std::endl;
    log_file << "4. Dead end states: " << this->labeled_states.size() - alive_states << std::endl;
    log_file << "4. Memory spent on this process " << get_memory_usage() << " GB" << std::endl;
    log_file << "4. Ended at " << get_elapsed_time() << std::endl;

    if (save_metadata)
    {
        count_and_print(goal_states);
    }
}