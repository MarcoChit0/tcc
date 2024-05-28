#include "easy_reachable_dead_end_detector.hpp"

EasyReachableDeadEndDetector::EasyReachableDeadEndDetector(const Task &task, const opt<int> &time_limit_seconds) : ReachableDeadEndDetector(task, time_limit_seconds)
{
}

void EasyReachableDeadEndDetector::label_states(const bool save_metadata)
{
    std::ofstream log_file(dead_end_directory + DEAD_END_LOG_FILE);
    // 1.
    map<int64_t, int64_t> predecessor;
    map<State, StateActionPairSet> reversed_edges;
    set<State> goal_states;
    StateActionPairToBoolMap is_bad_state_action_pair;
    set<State> states;
    set<State> current_weak_alive_states;

    if (this->time_limit_seconds.has_value())
    {
        log_file << "1. Running forward search with time constraints of " << this->time_limit_seconds.value() << " seconds\n";
        log_file << "1. Started at " << get_ellapsed_time() << std::endl;
        std::future<void> response = std::async(std::launch::async, &EasyReachableDeadEndDetector::mark_goal_states_as_alive, this, std::ref(reversed_edges), std::ref(goal_states), std::ref(states), std::ref(is_bad_state_action_pair));
        if (response.wait_for(std::chrono::seconds(this->time_limit_seconds.value())) == std::future_status::ready)
        {
            response.get();
            log_file << "1. States sucessfully created within the time limit." << std::endl;
        }
        else
        {
            log_file << "1. States creation failed within the time limit." << std::endl;
            log_file << "1. Ending program execution at " << get_ellapsed_time() << std::endl;
            exit(1);
        }
    }
    else
    {
        log_file << "1. Running forward search without time constraints.\n";
        log_file << "1. Started at " << get_ellapsed_time() << std::endl;
        mark_goal_states_as_alive(reversed_edges, goal_states, states, is_bad_state_action_pair);
    }
    log_file << "1. Reversed edges created" << std::endl;
    log_file << "1. Goal states: " << goal_states.size() << std::endl;
    log_file << "1. Non goal states: " << states.size() << std::endl;
    log_file << "1. Total states: " << goal_states.size() + states.size() << std::endl;
    log_file << "1. Ended at " << get_ellapsed_time() << std::endl;

    int iteration = WEAK_ALIVE;
    bool first_dead_end_detected = false, first_hard_dead_end_detected = false;

    int dead_end_label = (iteration++ != WEAK_ALIVE) ? HARD_DEAD_END : EASY_DEAD_END;
    if (iteration == INFTY)
    {
        throw std::runtime_error("LOG::ReachableDeadEndDetector::label_states::iteration_exceeded::" + std::to_string(iteration));
    }

    log_file << "2. Iteration: " << iteration << std::endl;
    log_file << "2. Started at " << get_ellapsed_time() << std::endl;
    log_file << "2. Previous weak alive states: " << states.size() << std::endl;

    this->find_weak_alive_states(iteration, reversed_edges, goal_states, current_weak_alive_states, is_bad_state_action_pair);

    log_file << "2. Current weak alive states: " << current_weak_alive_states.size() << std::endl;
    log_file << "2. Ended at " << get_ellapsed_time() << std::endl;

    log_file << "3. Transforming weak alive states into alive states\n";
    for(auto state : states)
    {
        if(this->labeled_states[state.id] == iteration)
        {
            this->labeled_states[state.id] = ALIVE;
        }
        else
        {
            if(this->labeled_states[state.id] != ALIVE)
            {
                this->labeled_states[state.id] = EASY_DEAD_END;
            }
        }
    }
    log_file << "3. Weak alive states transformed into alive states\n";
    int alive_states = current_weak_alive_states.size() + goal_states.size();
    log_file << "3. Alive states: " << alive_states << std::endl;
    log_file << "3. Dead end states: " << this->labeled_states.size() - alive_states << std::endl;
    log_file << "3. Memory spent on this process " << get_memory_usage() << " GB" << std::endl;
    log_file << "3. Ended at " << get_ellapsed_time() << std::endl;

    if (save_metadata)
    {
        count_and_print(goal_states);
    }
}