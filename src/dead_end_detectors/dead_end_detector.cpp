#include "dead_end_detector.hpp"

map<int64_t, int> DeadEndDetector::labeled_states = {};
int64_t DeadEndDetector::number_of_lookups = 0;
int64_t DeadEndDetector::number_of_useful_lookups = 0;
int64_t DeadEndDetector::number_of_hard_dead_end_lookups = 0;
int64_t DeadEndDetector::number_of_easy_dead_end_lookups = 0;

void DeadEndDetector::save_labeled_states() const
{
    std::ofstream file;
    file.open(dead_end_directory + DEAD_END_LABEL_FILE);
    for (auto &pair : labeled_states)
    {
        State state;
        state.id = pair.first;

        // save facts ids because it is stable unless we change how we read the task
        str content = "";
        for(auto &fact : state.true_facts())
        {
            content += std::to_string(fact.id) + ",";
        }
        content = content.substr(0, content.size() - 1) + ";" + state_label_to_string[pair.second] + "\n";
        file << content;
    }
    file.close();
}

str print_state_label(const int state_label)
{
    if (ALIVE <= state_label and state_label <= WEAK_ALIVE)
    {
        return state_label_to_string.at(state_label);
    }
    else if(state_label > WEAK_ALIVE)
    {
        return state_label_to_string.at(WEAK_ALIVE);
    }
    else
    {
        throw std::invalid_argument("LOG::print_state_label::invalid_state_label::" + std::to_string(state_label) + " is not a valid state label id");
    }
}

void DeadEndDetector::load_labeled_states()
{
    std::ifstream file;
    file.open(dead_end_directory + DEAD_END_LABEL_FILE);
    if (file.is_open())
    {
        str line;
        while (getline(file, line))
        {
            vec<str> tokens = split(line, ';');
            vec<str> fact_ids = split(tokens[0], ',');
            vec<Fact> facts;
            for(auto &fact_id : fact_ids)
            {
                Fact fact;
                fact.id = std::stoi(fact_id);
                facts.push_back(fact);
            }
            State state(facts);
            labeled_states[state.id] = string_to_state_label.at(tokens[1]);
        }
        file.close();
    }
}

str DeadEndDetector::get_statistics_header() const
{
    return "number_of_lookups,number_of_useful_lookups,number_of_hard_dead_end_lookups,number_of_easy_dead_end_lookups";
}

str DeadEndDetector::get_statistics() const
{
    str statistics = "";
    statistics += std::to_string(number_of_lookups) + ",";
    statistics += std::to_string(number_of_useful_lookups) + ",";
    statistics += std::to_string(number_of_hard_dead_end_lookups) + ",";
    statistics += std::to_string(number_of_easy_dead_end_lookups);
    return statistics;
}
