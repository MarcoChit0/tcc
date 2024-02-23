#pragma once

#include "../lookup.hpp"

class LookUpOnDeltaNearest : public LookUp
{
public:
    LookUpOnDeltaNearest(const Task &task, const State::Heuristic &state_heuristic, const SampleGenerator &sample_generator, const Sample::Treatment& sample_treatment);

    double operator[](const Policy &policy) const;
    // double compute_score(int optimal_policy_size) const;
};