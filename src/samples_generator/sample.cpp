#include "sample.hpp"

Sample::Sample(const State &state, int non_deterministic_value, int deterministic_value, int policy_type)
{
    if(non_deterministic_value <= 0)
    {
        this->id = NONE;
    }
    else
    {
        this->id = ++last_used_id;
        this->deterministic_value() = deterministic_value;
        this->non_deterministic_value() = non_deterministic_value;
        this->state() = state;
        this->policy_type() = policy_type;        
    }
}

void Destroy::operator()(const Sample &sample) const
{
    delete &sample;
}

void Keep::operator()(const Sample &sample) const
{
    // do nothing
}
