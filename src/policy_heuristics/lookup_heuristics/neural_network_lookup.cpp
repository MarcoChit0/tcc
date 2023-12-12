#include "neural_network_lookup.hpp"

NeuralNetworkLookUp::NeuralNetworkLookUp(const Task &task, const State::Heuristic &state_heuristic, const SampleGenerator &samples_generator, const Sample::Treatment &sample_treatment, str file_name) : LookUp(task, state_heuristic, samples_generator, sample_treatment, file_name)
{
    std::cout << "LOG::NeuralNetworkLookUp::NeuralNetworkLookUp::START" << std::endl;
    std::stringstream ss{get_output("build-and-train", "python3 ./misc/tools/lab/neural_network.py --samples_file=" + file_name + " --operation=train")};
    std::cout << "LOG::NeuralNetworkLookUp::NeuralNetworkLookUp::END" << std::endl;
    this->table_nd = map<int64_t, int>{};
}

int NeuralNetworkLookUp::operator[](const Policy &policy) const
{
    // if not found, return max(delta-nearest, random-walk-lookup)
    Function this_function{&NeuralNetworkLookUp::operator[], *this};
    auto &cache = functions_cache[this_function];
    if (not cache.contains(policy))
    {
        int table_look_up = 0;
        Policy cursor_policy = policy;
        vec<State> states_to_consult;
        // look for State on DOMAIN
        for (const State &domain_state : cursor_policy.domain_iterator())
        {
            if (this->table_nd.contains(domain_state.id))
            {
                table_look_up = std::max(this->table_nd[domain_state.id], table_look_up);
                this->number_of_lookups++;
            }
            else
            {
                states_to_consult.push_back(domain_state);
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
            else
            {
                states_to_consult.push_back(outgoing_non_goal_state);
            }
        }
        // consult neural network
        int maximum_consulted_value = this->consult_neural_network(states_to_consult);
        table_look_up = std::max(table_look_up, maximum_consulted_value);

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
}

int NeuralNetworkLookUp::consult_neural_network(const vec<State> &states) const
{
    str states_string = "";
    for(auto state : states)
    {
        states_string += this->task.bitset_representation_of_state(state) + ",";
    }
    states_string.pop_back();
    std::cout << "LOG::NeuralNetworkLookUp::consult_neural_network::START" << std::endl;
    std::stringstream ss{get_output("lookup", "python3 ./misc/tools/lab/neural_network.py --operation=predict --states=" + states_string)};
    std::cout << "LOG::NeuralNetworkLookUp::consult_neural_network::END" << std::endl;
    vec<str> states_values = split(ss.str(), ',');
    assert (states_values.size() == states.size());
    int maximum_value = -INFTY;
    for(int i = 0; i < states.size(); i++)
    {
        int state_value = std::stoi(states_values[i]);
        this->table_nd[states[i].id] = state_value;
        maximum_value = std::max(maximum_value, state_value);
    }
    return maximum_value;
}