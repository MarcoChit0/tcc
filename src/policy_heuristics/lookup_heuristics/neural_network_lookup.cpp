#include "neural_network_lookup.hpp"

NeuralNetworkLookUp::NeuralNetworkLookUp(const Task &task, const State::Heuristic &state_heuristic, const SampleGenerator &samples_generator, const Sample::Treatment &sample_treatment, str file_name) : LookUp(task, state_heuristic, samples_generator, sample_treatment, file_name)
{
    std::cerr << "LOG::NeuralNetworkLookUp::NeuralNetworkLookUp::START" << std::endl;
    str command =  "python3 ./misc/tools/lab/neural_network.py --operation=train --samples_file=" + file_name;
    std::cerr << "command: " << command << std::endl;
    auto start = std::chrono::high_resolution_clock::now();
    std::stringstream ss{get_output("build-and-train", command)};
    auto end = std::chrono::high_resolution_clock::now();
    auto difference = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
    decrease_itimer(difference.count()/1000000LL, difference.count()%1000000LL);
    std::cerr << "LOG::NeuralNetworkLookUp::NeuralNetworkLookUp::END::" << difference << std::endl;
    this->table_nd = map<int64_t, double>{};
}

double NeuralNetworkLookUp::operator[](const Policy &policy) const
{
    // if not found, return max(delta-nearest, random-walk-lookup)
    Function this_function{&NeuralNetworkLookUp::operator[], *this};
    auto &cache = functions_cache[this_function];
    if (not cache.contains(policy))
    {
        double table_look_up = 0;
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
        double maximum_consulted_value = this->consult_neural_network(states_to_consult);
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

double NeuralNetworkLookUp::consult_neural_network(const vec<State> &states) const
{
    str input_string = "";
    for(auto state : states)
    {
        input_string += this->task.bitset_representation_of_state(state) + ",";
    }
    input_string.pop_back();
    std::cerr << "LOG::NeuralNetworkLookUp::consult_neural_network::input = [" << input_string << "]" << std::endl;
    std::cerr << get_memory_usage() << "/" << get_memory_limit() << std::endl;
    std::cerr << "LOG::NeuralNetworkLookUp::consult_neural_network::START" << std::endl;
    auto start = std::chrono::high_resolution_clock::now();
    std::stringstream ss{get_output("lookup", "python3 ./misc/tools/lab/neural_network.py --operation=predict --states=" + input_string)};
    auto end = std::chrono::high_resolution_clock::now();
    auto difference = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
    decrease_itimer(difference.count()/1000000LL, difference.count()%1000000LL);
    str output_string = ss.str();
    size_t pos = output_string.find('\n');
    if(pos != std::string::npos)
    {
        output_string.erase(pos);
    }
    std::cerr << "LOG::NeuralNetworkLookUp::consult_neural_network::END::"<< difference << std::endl;
    std::cerr << "LOG::NeuralNetworkLookUp::consult_neural_network::output = [" << output_string << "]" << std::endl;
    vec<str> states_values = split(output_string, ',');
    std::cerr << "LOG::NeuralNetworkLookUp::consult_neural_network::states_values:" << std::endl;
    for(auto state_value : states_values)
    {
        std::cerr << state_value << std::endl;
    }
    assert (states_values.size() == states.size());
    double maximum_value = -INFTY;
    for(int i = 0; i < states.size(); i++)
    {
        double state_value = std::stod(states_values[i]);
        this->table_nd[states[i].id] = state_value;
        std::cerr << "LOG::NeuralNetworkLookUp::consult_neural_network::state_value = " << state_value << std::endl;
        maximum_value = std::max(maximum_value, state_value);
    }
    return maximum_value;
}