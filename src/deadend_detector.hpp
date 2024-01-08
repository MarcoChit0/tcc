#pragma once

#include "general.hpp"
#include "./samples_generator/sample_generator.hpp"


class DeadEndDetector
{
    public:
        static map <int64_t, bool> has_non_deterministic_value;
        static int number_of_lookups;
        const SampleGenerator& samples_generator;
        const Sample::Treatment& sample_treatment;
        const State::Heuristic &state_heuristic;
        
        DeadEndDetector(const Task &task, const State::Heuristic &state_heuristic, const SampleGenerator& samples_generator, const Sample::Treatment& sample_treatment);
        bool operator[](const State &state) const;
};