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

NeuralNetworkLookUp::NeuralNetworkLookUp(const Task &task, const State::Heuristic &state_heuristic, const SampleGenerator &samples_generator, const Sample::Treatment &sample_treatment, str file_name) : LookUp(task, state_heuristic, samples_generator, sample_treatment, file_name),
                                                                                                                                                                                                          state_network(task, NUMBER_OF_HIDDEN_UNITS),
                                                                                                                                                                                                          model_path{get_directory_path(file_name)}
{
    str model_file_name = model_path + "model.pt";
    vec<int64_t> states = {};
    vec<double> targets = {};
    for (auto pair : this->table_nd)
    {
        states.push_back(pair.first);
        targets.push_back(pair.second);
    }
    auto optimizer = torch::optim::Adam(state_network.parameters(), torch::optim::AdamOptions(1e-5));
    state_network.train(
        optimizer,
        states,
        targets,
        NUMBER_OF_EPOCHS,
        BATCH_SIZE);
    for (auto pair : this->table_nd)
    {
        std::cout << "LOG::NeuralNetworkLookUp::NeuralNetworkLookUp::"<< pair.first << " -> ("<< pair.second << ",";
        this->table_nd[pair.first] = state_network.predict(pair.first);
        std::cout << this->table_nd[pair.first] << ")" << "\n";
    }
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
            if (not this->table_nd.contains(domain_state.id))
            {
                this->table_nd[domain_state.id] = this->state_network.predict(domain_state.id);
            }
            table_look_up = std::max(this->table_nd[domain_state.id], table_look_up);
            this->number_of_lookups++;
        }
        // look for state on OUT~
        cursor_policy = policy;
        for (const State &outgoing_non_goal_state : cursor_policy.outgoing_non_goal_states(this->task.goal_condition()))
        {
            if (not this->table_nd.contains(outgoing_non_goal_state.id))
            {
                this->table_nd[outgoing_non_goal_state.id] = this->state_network.predict(outgoing_non_goal_state.id);
            }
            table_look_up = std::max(this->table_nd[outgoing_non_goal_state.id], table_look_up);
            this->number_of_lookups++;
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
}