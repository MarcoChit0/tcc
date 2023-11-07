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
public:
    using Object::Object;

    class Solver;

    vec<Variable> &variables() const;
    vec<Fact> &facts() const;
    State &initial_state() const;
    PartialState &goal_condition() const;
    vec<str> &action_classes() const;
    vec<Action> &actions() const;
    set<set<Fact>> &mutex_groups() const;

    bool violate_mutex(const PartialState &partial_state) const;
    vec<PartialState> get_regressed_partial_states(const PartialState& partial_state) const;
    Task(const str &domain_file_name, const str &task_file_name);

    static map<int64_t, vec<PartialState>> regressed_partial_states;
};

DEFINE_OBJECT_HASH(Task);

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
