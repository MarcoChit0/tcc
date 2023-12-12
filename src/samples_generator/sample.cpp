#include "sample.hpp"

Sample::Sample(const State &state, int non_deterministic_value, int deterministic_value, int policy_type)
{
    // if(non_deterministic_value <= 0)
    // {
    //     this->id = NONE;
    //     this->is_valid() = false;
    // }
    // else
    // {
    //     this->id = ++last_used_id;
    //     this->deterministic_value() = deterministic_value;
    //     this->non_deterministic_value() = non_deterministic_value;
    //     this->state() = state;
    //     this->policy_type() = policy_type;   
    //     this->is_valid() = true;     
    // }

    this->id = ++last_used_id;
    this->deterministic_value() = deterministic_value;
    this->non_deterministic_value() = non_deterministic_value;
    this->state() = state;
    this->policy_type() = policy_type;   
    this->is_valid() = true;   
}

// TODO: should I also ignore unsolvable policies?
void Ignore::operator()(Sample& sample) const
{
    if(sample.policy_type() == SUBOPTIMAL_POLICY)
    {
        sample.id = NONE;
        sample.is_valid() = false;
    }
}


void Keep::operator()(Sample& sample) const
{
    // Do nothing
}

std::ostream& operator<<(std::ostream &out, const Sample &self)
{

    str valid = self.is_valid() ? "valid" : "invalid";
    out 
    << "Sample(" 
    << self.id << "," 
    << self.state() << ","
    << self.non_deterministic_value() << "," 
    << self.deterministic_value() << "," 
    << policy_types_names[self.policy_type()] << "," 
    << valid << ")";
    return out;
}
