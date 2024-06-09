#include "./set_dead_end_detector.hpp"
#include <algorithm> // For std::set_difference, std::set_intersection
#include <iterator>  // For std::back_inserter

SetDeadEndDetector::SetDeadEndDetector(const Task &task, const opt<int> &time_limit_seconds) : ReachableDeadEndDetector(task, time_limit_seconds)
{
}

double SetDeadEndDetector::is_deadend(const State &state) const
{
    return this->labeled_states.at(state.id) == HARD_DEAD_END ? 1.0 : 0.0;
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

void SetDeadEndDetector::label_states(const bool save_metadata)
{
    std::unordered_set<State> alive, unk, dead, visited, new_dead;
    vec<State> stack = {this->task.initial_state()};
    std::queue<State> queue;

    int i = 0, hard_dead_end_count = 0, easy_dead_end_count = 0, goal_count = 0;

    while (!stack.empty())
    {
        State state = stack.back();
        stack.pop_back();
        visited.insert(state);

        if (state.is_goal(this->task.goal_condition()))
        {
            alive.insert(state);
        }
        else
        {
            unk.insert(state);
            for (const Action &action : state.get_applicable_actions(this->task.actions()))
            {
                for (const State &successor_state : state.get_successors(action))
                {
                    if (visited.find(successor_state) == visited.end())
                    {
                        stack.push_back(successor_state);
                    }
                }
            }
        }
    }

    goal_count = alive.size();
    stack.clear();

    do
    {
        queue = std::queue<State>(std::deque<State>(alive.begin(), alive.end()));
        visited.clear();
        std::cerr << "LOG::SetDeadEndDetector::started inner loop " << i << " at " << get_elapsed_time() << std::endl;
        while (!queue.empty())
        {
            State state = queue.front();
            queue.pop();

            if (visited.contains(state))
            {
                continue;
            }

            visited.insert(state);

            for (const State &predecessor : my_set_difference(unk, visited))
            {
                bool good_action = false;

                for (const Action &action : predecessor.get_applicable_actions(this->task.actions()))
                {
                    std::unordered_set<State> successors(predecessor.get_successors(action).begin(), predecessor.get_successors(action).end());
                    if (successors.find(state) != successors.end() && my_set_intersection(successors, dead).empty())
                    {
                        good_action = true;
                        break;
                    }
                }

                if (good_action)
                {
                    queue.push(predecessor);
                }
            }
        }
        std::cerr << "LOG::SetDeadEndDetector::ended inner loop at " << get_elapsed_time() << std::endl;
        std::cerr << "LOG::SetDeadEndDetector::visited size " << visited.size() << std::endl;
        std::cerr << "LOG::SetDeadEndDetector::unk before size " << unk.size() << std::endl;
        std::cerr << "LOG::SetDeadEndDetector::dead before size " << dead.size() << std::endl;
        new_dead = my_set_difference(unk, visited);
        if (i++)
        {
            hard_dead_end_count += new_dead.size();
            for (const auto &h : new_dead)
            {
                this->labeled_states[h.id] = HARD_DEAD_END;
                dead.insert(h);
            }
        }
        else
        {
            easy_dead_end_count += new_dead.size();
            for (const auto &e : new_dead)
            {
                this->labeled_states[e.id] = EASY_DEAD_END;
                dead.insert(e);
            }
        }
        unk = my_set_intersection(unk, visited);
        std::cerr << "LOG::SetDeadEndDetector::unk after size " << unk.size() << std::endl;
        std::cerr << "LOG::SetDeadEndDetector::dead after size " << dead.size() << std::endl;
    } while (!new_dead.empty());
    std::cerr << "LOG::SetDeadEndDetector::ended outer loop at " << get_elapsed_time() << std::endl;
    std::cerr << "LOG::SetDeadEndDetector::consumed memory " << get_memory_usage() << std::endl;
    alive = my_set_union(alive, unk);
    for (const auto &a : alive)
    {
        this->labeled_states[a.id] = ALIVE;
    }
    std::ofstream metadata_file(dead_end_directory + DEAD_END_METADATA_FILE);
    if (!metadata_file.is_open())
    {
        std::cerr << "LOG::ReachableDeadEndDetector::save_metadata::Error opening metadata file." << std::endl;
        return;
    }
    metadata_file << "Metric,Count\n";
    metadata_file << "HardDeadEndStates," << hard_dead_end_count << "\n";
    metadata_file << "EasyDeadEndStates," << easy_dead_end_count << "\n";
    metadata_file << "AliveStates," << alive.size() << "\n";
    metadata_file << "WeakAliveStates," << unk.size() << "\n";
    metadata_file << "TotalStates," << alive.size() + dead.size() << "\n";
    metadata_file << "GoalStates," << goal_count << "\n";
    metadata_file << "NonGoalStates," << (alive.size() + dead.size()) - goal_count << "\n";
    metadata_file.close();
}
