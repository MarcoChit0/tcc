#include "sample.hpp"

Sample::Sample(const State& state, int non_deterministic_value, int deterministic_value) {
    this->id = ++last_used_id;
    this->deterministic_value() = deterministic_value;
    this->non_deterministic_value() = non_deterministic_value;
    this->state() = state;    
}