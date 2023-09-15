#include "./fact.hpp"

Fact::Fact(const Variable &variable, const str &value, const mpz_class &hash)
{
    this->id = ++last_used_id;
    this->variable() = variable;
    this->value() = value;
    this->hash() = hash;
}

std::ostream& operator<<(std::ostream &out, const Fact &self)
{
    out << self.variable() << " = " << self.value();
    return out;
}
