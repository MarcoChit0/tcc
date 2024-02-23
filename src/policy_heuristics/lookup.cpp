#include "lookup.hpp"

map<int64_t, double> LookUp::table_nd = map<int64_t, double>{};
int LookUp::number_of_lookups = 0;

LookUp::LookUp(const Task &task, const State::Heuristic &state_heuristic, const SampleGenerator &samples_generator, const Sample::Treatment &sample_treatment) : 
    Heuristic(task), 
    state_heuristic(state_heuristic), 
    samples_generator(samples_generator), 
    sample_treatment(sample_treatment),
    file_name(default_directory + SAMPLES_FILE_NAME)

{
    set<Sample> samples = this->samples_generator.generate_samples();
    std::fstream file;
    file.open(file_name, std::ios::out);
    file << "state_id,state,h_nd,h_d,policy_type\n";
    if (not file.is_open())
    {
        throw std::runtime_error("LOG::LookUp::LookUp::file not open");
    }
    for (Sample sample : samples)
    {
        this->sample_treatment(sample);
        if (sample.is_valid())
        {
            file 
            << sample.state().id << "," 
            << this->task.bitstring_representation_of_state(sample.state()) << "," 
            << sample.non_deterministic_value() << "," 
            << sample.deterministic_value() << "," 
            << policy_types_names[sample.policy_type()] << "\n";
            this->table_nd[sample.state().id] = sample.non_deterministic_value();
        }
    }
    file.close();
};
