#pragma once

#include "../task.hpp"

class Sample : public Object
{
    using Object::Object;
    public:
        State& state() const;
        int& non_deterministic_value() const; // f*nd
        int& deterministic_value() const; // h*d

        Sample(const State& state, int non_deterministic_value, int deterministic_value);
};
DEFINE_OBJECT_HASH(Sample);