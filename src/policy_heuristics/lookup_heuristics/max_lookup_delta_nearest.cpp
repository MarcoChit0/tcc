#include "max_lookup_delta_nearest.hpp"

MaxLookUpDeltaNearest::MaxLookUpDeltaNearest(const Task &task, const State::Heuristic &state_heuristic, const SampleGenerator &sample_generator, const Sample::Treatment& sample_treatment)
    : LookUp(task, state_heuristic, sample_generator, sample_treatment)
{
}

double MaxLookUpDeltaNearest::operator[](const Policy &policy) const
{
    // if not found, return max(delta-nearest, random-walk-lookup)
    Function this_function{&MaxLookUpDeltaNearest::operator[], *this};
    auto &cache = functions_cache[this_function];
    if (not cache.contains(policy))
    {
        double table_look_up = 0.0f;
        Policy cursor_policy = policy;
        // look for State on DOMAIN
        for (const State &domain_state : cursor_policy.domain_iterator())
        {
            if (this->table_nd.contains(domain_state.id))
            {
                table_look_up = std::max(this->table_nd[domain_state.id], table_look_up);
                this->number_of_lookups++;
            }
        }
        // look for state on OUT~
        cursor_policy = policy;
        for (const State &outgoing_non_goal_state : cursor_policy.outgoing_non_goal_states(this->task.goal_condition()))
        {
            if (this->table_nd.contains(outgoing_non_goal_state.id))
            {
                table_look_up = std::max(this->table_nd[outgoing_non_goal_state.id], table_look_up);
                this->number_of_lookups++;
            }
        }
        // compute delta-nearest
        int count = policy.size() + policy.outgoing_non_goal_states(this->task.goal_condition()).size();

        int minimal_outgoing_state_h_value = policy.does_reach_the_goal(this->task.goal_condition()) ? 0 : +INFTY;

        vec<int> states_heuristic_values;
        states_heuristic_values.reserve(count);
        for (const State &state : policy.domain_iterator())
        {
            states_heuristic_values.push_back(this->state_heuristic[state]);
        }
        for (const State &state : policy.outgoing_non_goal_states(this->task.goal_condition()))
        {
            states_heuristic_values.push_back(this->state_heuristic[state]);
            minimal_outgoing_state_h_value = std::min(minimal_outgoing_state_h_value, this->state_heuristic[state]);
        }

        std::sort(states_heuristic_values.begin(), states_heuristic_values.end(), std::greater<int>());

        int delta = -INFTY;
        int i = 0;
        for (const int &state_heuristic_value : states_heuristic_values)
        {
            delta = std::max(delta, state_heuristic_value + i++);
        }

        cache[policy] = std::max(delta, count + std::max(0, minimal_outgoing_state_h_value - 1)); // delta-nearest
        cache[policy] = std::max(cache[policy], table_look_up);                                   // lookup
    }
    return cache[policy];
};

// double MaxLookUpDeltaNearest::compute_score(int optimal_policy_size) const
// {
//     int n = this->state_heuristic.size();
//     int k = 0;
//     for(auto &pair: this->table_nd)
//     {
//         if(pair.second > optimal_policy_size and this->table_d[pair.first] <= optimal_policy_size)
//         {
//             k++;
//         }
//     }
//     return (double)k / n;
// };