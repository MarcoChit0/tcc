#include "./set_dead_end_detector.hpp"
#include <algorithm> // For std::set_difference, std::set_intersection
#include <iterator>  // For std::back_inserter

SetDeadEndDetector::SetDeadEndDetector(const Task &task) : DeadEndDetector(task)
{
    this->alive = std::unordered_set<State>();
    this->unk = std::unordered_set<State>();
    this->dead = std::unordered_set<State>();
    this->hard_dead_end_count = 0;
    this->easy_dead_end_count = 0;
    this->goal_count = 0;
    this->is_bad = StateActionPairToBoolMap();
    this->predecessors = std::map<State, vec<StateActionPair>>();
}

set<State> my_set_intersection(const set<State> &set1, const set<State> &set2)
{
    set<State> intersec;
    if (set1.empty() || set2.empty())
    {
        return intersec;
    }
    for (const State &state1 : set1)
    {
        if (set2.find(state1) != set2.end())
        {
            intersec.insert(state1);
        }
    }
    return intersec;
}

set<State> my_set_difference(const set<State> &set1, const set<State> &set2)
{
    set<State> diff;
    if (set1.empty())
    {
        return diff;
    }
    for (const State &state1 : set1)
    {
        if (set2.find(state1) == set2.end())
        {
            diff.insert(state1);
        }
    }
    return diff;
}

set<State> my_set_union(const set<State> &set1, const set<State> &set2)
{
    set<State> uni;
    for (const State &state1 : set1)
    {
        uni.insert(state1);
    }
    for (const State &state2 : set2)
    {
        uni.insert(state2);
    }
    return uni;
}

void SetDeadEndDetector::forward_search()
{
    vec<State> stack = {this->task.initial_state()};
    while (!stack.empty())
    {
        State state = stack.back();
        stack.pop_back();
        if (state.is_goal(this->task.goal_condition()))
        {
            alive.insert(state);
            this->labeled_states[state.id] = ALIVE;
        }
        else
        {
            unk.insert(state);
            this->labeled_states[state.id] = WEAK_ALIVE;
            for (const Action &action : state.get_applicable_actions(this->task.actions()))
            {
                for (const State &successor_state : state.get_successors(action))
                {
                    if (predecessors.find(successor_state) == predecessors.end())
                    {
                        predecessors[successor_state] = vec<StateActionPair>();
                        stack.push_back(successor_state);
                    }
                    auto p = std::make_pair(state, action);
                    predecessors[successor_state].push_back(p);
                    is_bad[p] = false;
                }
            }
        }
    }
}

void SetDeadEndDetector::backward_search(std::unordered_set<State> &visited)
{
    std::queue<State> queue = std::queue<State>(std::deque<State>(alive.begin(), alive.end()));
    visited = std::unordered_set<State>(alive.begin(), alive.end());

    while (!queue.empty())
    {
        State state = queue.front();
        queue.pop();

        for (const StateActionPair &p : predecessors[state])
        {
            if (not is_bad[p] and visited.find(p.first) == visited.end())
            {
                queue.push(p.first);
                visited.insert(p.first);
            }
        }
    }
}
void SetDeadEndDetector::label_dead_states(std::unordered_set<State> &visited, const int &iteration, State &last_dead_end)
{
    std::unordered_set<State> new_dead = my_set_difference(unk, visited);
    int label;
    if (iteration == 0)
    {
        label = EASY_DEAD_END;
        easy_dead_end_count += new_dead.size();
    }
    else
    {
        label = HARD_DEAD_END;
        hard_dead_end_count += new_dead.size();
    }

    last_dead_end = new_dead.size() > 0 ? *new_dead.begin() : last_dead_end;

    for (const auto &d : new_dead)
    {
        this->labeled_states[d.id] = label;
        dead.insert(d);
        for (const StateActionPair &p : predecessors[d])
        {
            is_bad[p] = true;
        }
    }
}

void SetDeadEndDetector::label_alive_states()
{
    alive = my_set_union(alive, unk);
    for (const auto &a : alive)
    {
        this->labeled_states[a.id] = ALIVE;
    }
    unk.clear();
}

void SetDeadEndDetector::print(const int &iteration) const
{
    int set_memory_estimate = sizeof(State) * (alive.size() + dead.size() + unk.size());
    std::ofstream metadata_file(dead_end_directory + DEAD_END_METADATA_FILE);
    if (!metadata_file.is_open())
    {
        std::cerr << "LOG::SetDeadEndDetector::save_metadata::Error opening metadata file." << std::endl;
        return;
    }
    metadata_file << "Metric,Count\n";
    metadata_file << "Time," << get_elapsed_time() << "\n";
    metadata_file << "HardDeadEndStates," << hard_dead_end_count << "\n";
    metadata_file << "EasyDeadEndStates," << easy_dead_end_count << "\n";
    metadata_file << "AliveStates," << alive.size() << "\n";
    metadata_file << "WeakAliveStates," << unk.size() << "\n";
    metadata_file << "TotalStates," << alive.size() + dead.size() << "\n";
    metadata_file << "GoalStates," << goal_count << "\n";
    metadata_file << "NonGoalStates," << (alive.size() + dead.size()) - goal_count << "\n";
    metadata_file << "K1Metric," << iteration - 1 << "\n";
    metadata_file << "MemoryEstimate," << set_memory_estimate << "\n";
    metadata_file << "Memory," << get_memory_usage() << "\n";
    metadata_file.close();
}

void SetDeadEndDetector::label_states(const bool save_metadata)
{
    std::unordered_set<State> visited;
    int i = 0, dead_end_count = 0;
    std::cerr << "LOG::SetDeadEndDetector::label_states::Starting forward search at " << get_elapsed_time() << std::endl;
    forward_search();
    std::cerr << "LOG::SetDeadEndDetector::label_states::Ending forward search at " << get_elapsed_time() << std::endl;
    goal_count = alive.size();
    State last_dead_end_found;
    do
    {
        dead_end_count = dead.size();
        visited.clear();
        std::cerr << "LOG::SetDeadEndDetector::label_states::Starting backward search #" << i << " at " << get_elapsed_time() << std::endl;
        backward_search(visited);
        std::cerr << "LOG::SetDeadEndDetector::label_states::Starting backward search #" << i << " at " << get_elapsed_time() << std::endl;
        std::cerr << "LOG::SetDeadEndDetector::label_states::#DeadEndStates before: " << dead.size() << std::endl;
        label_dead_states(visited, i, last_dead_end_found);
        std::cerr << "LOG::SetDeadEndDetector::label_states::#DeadEndStates after: " << dead.size() << std::endl;
        std::cerr << "LOG::SetDeadEndDetector::label_states::#UnknownStates before: " << unk.size() << std::endl;
        unk = my_set_intersection(unk, visited);
        std::cerr << "LOG::SetDeadEndDetector::label_states::#UnknownStates after: " << unk.size() << std::endl;
        i++;
    } while (dead_end_count != dead.size());
    std::cerr << "LOG::SetDeadEndDetector::label_states::#AliveStates before: " << alive.size() << std::endl;
    label_alive_states();
    std::cerr << "LOG::SetDeadEndDetector::label_states::#AliveStates after: " << alive.size() << std::endl;
    std::cerr << "LOG::SetDeadEndDetector::label_states::last dead end found:\n"
              << last_dead_end_found << std::endl;
    if (save_metadata)
    {
        print(i);
    }
}

bool SetDeadEndDetector::iterative_states_labeling(int &iteration, const bool save_metadata)
{
    if (iteration == 0)
    {
        std::cerr << "LOG::SetDeadEndDetector::label_states::Starting forward search at " << get_elapsed_time() << std::endl;
        forward_search();
        std::cerr << "LOG::SetDeadEndDetector::label_states::Ending forward search at " << get_elapsed_time() << std::endl;
    }
    State last_dead_end;
    int dead_end_count = dead.size();
    std::unordered_set<State> visited;
    std::cerr << "LOG::SetDeadEndDetector::label_states::Starting backward search #" << iteration << " at " << get_elapsed_time() << std::endl;
    backward_search(visited);
    std::cerr << "LOG::SetDeadEndDetector::label_states::Ending backward search #" << iteration << " at " << get_elapsed_time() << std::endl;
    std::cerr << "LOG::SetDeadEndDetector::label_states::#DeadEndStates before: " << dead.size() << std::endl;
    label_dead_states(visited, iteration, last_dead_end);
    std::cerr << "LOG::SetDeadEndDetector::label_states::#DeadEndStates after: " << dead.size() << std::endl;
    std::cerr << "LOG::SetDeadEndDetector::label_states::#UnknownStates before: " << unk.size() << std::endl;
    unk = my_set_intersection(unk, visited);
    std::cerr << "LOG::SetDeadEndDetector::label_states::#UnknownStates after: " << unk.size() << std::endl;
    iteration++;
    if (dead_end_count == dead.size())
    {
        std::cerr << "LOG::SetDeadEndDetector::label_states::#AliveStates before: " << alive.size() << std::endl;
        label_alive_states();
        std::cerr << "LOG::SetDeadEndDetector::label_states::#AliveStates after: " << alive.size() << std::endl;
        if (save_metadata)
        {
            print(iteration);
        }
        // return true if the execution is complete
        return true;
    }
    // return false if the execution is not complete
    return false;
}