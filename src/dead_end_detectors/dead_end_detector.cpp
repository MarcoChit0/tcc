#include "dead_end_detector.hpp"

map<int64_t, int> DeadEndDetector::labeled_states = {};

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