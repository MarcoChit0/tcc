#pragma once

#include "../policy.hpp"
class Count : public Policy::Heuristic
{
public:
    using Policy::Heuristic::Heuristic;

    double operator[](const Policy &policy) const;
};
