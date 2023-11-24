#pragma once
#include "./general.hpp"

class Fact;
class Variable;
class Action;
class PartialState;
class State;
class Policy;

class Task : public Object
{
private:
    vec<vec<PartialState>> equality(const PartialState &partial_state) const;
    vec<vec<PartialState>> action_proportionality(const PartialState &partial_state) const;
public:
    using Object::Object;

    class Solver;
    class Regressor;
    vec<Variable> &variables() const;
    vec<Fact> &facts() const;
    State &initial_state() const;
    PartialState &goal_condition() const;
    vec<str> &action_classes() const;
    vec<Action> &actions() const;
    set<set<Fact>> &mutex_groups() const;
    const Regressor& regressor;

    bool violate_mutex(const PartialState &partial_state) const;
    vec<vec<PartialState>> get_regressed_partial_states(const PartialState& partial_state) const;
    Task(const str &domain_file_name, const str &task_file_name, const Regressor& regressor);

    static map<int64_t, int64_t> variable_to_index;
    static map<int64_t, int64_t> variable_to_variable_domain_size;
    static map<int64_t, int64_t> fact_to_fact_offset;
};

DEFINE_OBJECT_HASH(Task);

class Task::Regressor
{
public:
    virtual vec<vec<PartialState>> operator()(const PartialState &partial_state, const Task& task) const = 0;
};

class Equality : public Task::Regressor
{
public:
    vec<vec<PartialState>> operator()(const PartialState &partial_state, const Task& task) const;
};

class ActionProportionality : public Task::Regressor
{
public:
    vec<vec<PartialState>> operator()(const PartialState &partial_state, const Task& task) const;
};


class Task::Solver
{
public:
    virtual Policy get_solution(const Task &task) = 0; // TODO: I think it should be a const method, but currently it is impossible.
};

#include "./fact.hpp"
#include "./variable.hpp"
#include "./action.hpp"
#include "./partial_state.hpp"
#include "./state.hpp"
#include "./policy.hpp"
