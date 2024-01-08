#include "deadend_detector.hpp"

map<int64_t, bool> DeadEndDetector::has_non_deterministic_value = map<int64_t, bool>{};
int DeadEndDetector::number_of_lookups = 0;

DeadEndDetector::DeadEndDetector(const Task &task, const State::Heuristic &state_heuristic, const SampleGenerator& samples_generator, const Sample::Treatment& sample_treatment) : state_heuristic(state_heuristic), samples_generator(samples_generator), sample_treatment(sample_treatment)
{
    set<Sample> samples = this->samples_generator.generate_samples();
    for (Sample sample : samples)
    {
        this->sample_treatment(sample);
        if (sample.is_valid())
        {
            if(sample.policy_type() == policy_types::UNSOLVABLE_POLICY)
            {
                this->has_non_deterministic_value[sample.state().hash()] = 0;
            }
            else
            {
                this->has_non_deterministic_value[sample.state().hash()] = 1;
            }
        }   
    }
};