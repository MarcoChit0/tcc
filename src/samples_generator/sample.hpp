#pragma once

#include "../task.hpp"

class Sample : public Object
{
    using Object::Object;
    public:
        bool& is_valid() const;
        class Treatment;
        State& state() const;
        int& non_deterministic_value() const; // f*nd
        int& deterministic_value() const; // h*d
        int& policy_type() const;
        Sample(const State& state, int non_deterministic_value, int deterministic_value, int policy_type);
        friend std::ostream& operator<<(std::ostream &out, const Sample &self);
};
DEFINE_OBJECT_HASH(Sample);

class Sample::Treatment
{
    public:
        virtual void operator()(Sample& sample) const = 0;
};

class Ignore : public Sample::Treatment
{
    public:
        void operator()(Sample& sample) const;
};

class Keep : public Sample::Treatment
{
    public:
        void operator()(Sample& sample) const;
};
