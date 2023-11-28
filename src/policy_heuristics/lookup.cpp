#include "lookup.hpp"

map<int64_t, int> LookUp::table_nd = map<int64_t, int>{};
int LookUp::number_of_lookups = 0;

LookUp::LookUp(const Task &task, const State::Heuristic &state_heuristic, const SampleGenerator &samples_generator, const Sample::Treatment &sample_treatment, str file_name) : Heuristic(task), state_heuristic(state_heuristic), samples_generator(samples_generator), sample_treatment(sample_treatment)
{
    set<Sample> samples = this->samples_generator.generate_samples();
    std::fstream file;
    file.open(file_name, std::ios::out);
    file << "state_id,h_nd,h_d,policy_type\n";
    if (not file.is_open())
    {
        throw std::runtime_error("LOG::LookUp::LookUp::file not open");
    }
    for (Sample sample : samples)
    {
        this->sample_treatment(sample);
        if (sample.is_valid())
        {
            file << sample.state().id << "," << sample.non_deterministic_value() << "," << sample.deterministic_value() << "," << policy_types_names[sample.policy_type()] << "\n";
            this->table_nd[sample.state().id] = sample.non_deterministic_value();
            // this->table_d[sample.state().id] = sample.deterministic_value();
        }
    }
    file.close();
};
