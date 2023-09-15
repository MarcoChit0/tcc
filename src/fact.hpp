#pragma once
#include "./general.hpp"

class Task;
class Variable;

class Fact : public Object
{
public:
    using Object::Object;

    Variable &variable() const;
    str &value() const;
    mpz_class &hash() const;

    Fact(const Variable &variable, const str &value, const mpz_class &hash);

    friend std::ostream& operator<<(std::ostream &out, const Fact &self);
};
DEFINE_OBJECT_HASH(Fact);

#include "./task.hpp"
#include "./variable.hpp"
