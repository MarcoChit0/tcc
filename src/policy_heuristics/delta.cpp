#include "./delta.hpp"

Delta::Delta(const Task &task, const State::Heuristic &state_heuristic) : Heuristic(task), state_heuristic(state_heuristic) {}

double Delta::operator[](const Policy &policy) const
{
    Function this_function {&Delta::operator[], *this};
    auto &cache = functions_cache[this_function];
    if (not cache.contains(policy))
    {
        vec<int> states_heuristic_values;
        for (const State &state: policy.domain_iterator())
        {
            states_heuristic_values.push_back(this->state_heuristic[state]);
        }
        for (const State &state: policy.outgoing_non_goal_states(this->task.goal_condition()))
        {
            states_heuristic_values.push_back(this->state_heuristic[state]);
        }

        std::sort(states_heuristic_values.begin(), states_heuristic_values.end(), std::greater<int>());

        int delta = -INFTY;
        int i = 0;
        for (const int &state_heuristic_value: states_heuristic_values)
        {
            delta = std::max(delta, state_heuristic_value + i++);
        }

        cache[policy] = delta;
    }
    return cache[policy];
};
