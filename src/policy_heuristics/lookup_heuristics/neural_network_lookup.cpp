#include "neural_network_lookup.hpp"

str get_directory_path(str file_path)
{
    vec<str> splitted_file_path = split(file_path, '/');
    splitted_file_path.pop_back();
    str directory_path = "";
    for (auto directory : splitted_file_path)
    {
        directory_path += directory + "/";
    }
    return directory_path;
}

NeuralNetworkLookUp::NeuralNetworkLookUp(const Task &task, const State::Heuristic &state_heuristic, const SampleGenerator &samples_generator, const Sample::Treatment &sample_treatment, str file_name) : LookUp(task, state_heuristic, samples_generator, sample_treatment, file_name), model_path{get_directory_path(file_name)}
{
    this->table_nd = map<int64_t, double>{};

    std::cerr << "LOG::NeuralNetworkLookUp::NeuralNetworkLookUp::start time:" << get_ellapsed_time() << std::endl;

    // client.write("timelimit", std::to_string(get_time_limit() - get_ellapsed_time()));
    // std::pair<str, str> response = client.read();

    // if(response.first != "timelimit")
    // {
    //     std::cerr << "LOG::NeuralNetworkLookUp::NeuralNetworkLookUp::response:" << response.first << ":" << response.second << std::endl;
    //     throw std::runtime_error("NeuralNetworkLookUp::NeuralNetworkLookUp::response != OK");
    // }
    // std::cerr << "LOG::NeuralNetworkLookUp::NeuralNetworkLookUp::server timelimit set to " << response.second << " seconds" << std::endl;

    clients["lookup"]->write("build", file_name); // send samples file to the server so it could build the neural network
    auto response = clients["lookup"]->read(); // wait for the server to finish building the neural network

    if(response.first != "build" and response.second != "OK")
    {
        std::cerr << "LOG::NeuralNetworkLookUp::NeuralNetworkLookUp::response:" << response.first << ":" << response.second << std::endl;
        throw std::runtime_error("NeuralNetworkLookUp::NeuralNetworkLookUp::response != OK");
    }

    std::cerr << "LOG::NeuralNetworkLookUp::NeuralNetworkLookUp::end time:" << get_ellapsed_time() << std::endl;
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
    if (states.empty())
    {
        return 0;
    }
    str message_content = "";
    for (auto state : states)
    {
        message_content += this->task.bitset_representation_of_state(state) + ",";
    }
    message_content.pop_back();
    

    std::cerr << "LOG::NeuralNetworkLookUp::consult_neural_network::start time:" << get_ellapsed_time() << std::endl;
    clients["lookup"]->write("consult",message_content);
    std::pair<str, str> response = clients["lookup"]->read();
    if (response.first != "consult")
    {
        std::cerr << "LOG::NeuralNetworkLookUp::consult_neural_network::response:" << response.first << ":" << response.second << std::endl;
        throw std::runtime_error("NeuralNetworkLookUp::consult_neural_network::response != consult");
    }
    vec<str> states_values = split(response.second, ',');
    std::cerr << "LOG::NeuralNetworkLookUp::consult_neural_network::end time:" << get_ellapsed_time() << std::endl;
    assert(states_values.size() == states.size());


    double maximum_value = -INFTY;
    for (int i = 0; i < states.size(); i++)
    {
        double state_value = std::stod(states_values[i]);
        this->table_nd[states[i].id] = state_value;
        maximum_value = std::max(maximum_value, state_value);
        std::cerr << "state:" << states[i] << ", value:" << state_value << std::endl;
    }
    return maximum_value;
}