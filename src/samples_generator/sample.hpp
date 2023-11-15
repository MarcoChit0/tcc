#pragma once

#include "../task.hpp"

class Sample : public Object
{
    using Object::Object;
    public:
        class Treatment;
        State& state() const;
        int& non_deterministic_value() const; // f*nd
        int& deterministic_value() const; // h*d
        int& policy_type() const;

        Sample(const State& state, int non_deterministic_value, int deterministic_value, int policy_type);
};
DEFINE_OBJECT_HASH(Sample);

class Sample::Treatment
{
    public:
        virtual void operator()(const Sample& sample) const = 0;
};

class Destroy : public Sample::Treatment
{
    public:
        void operator()(const Sample& sample) const;
};

class Keep : public Sample::Treatment
{
    public:
        void operator()(const Sample& sample) const;
};
