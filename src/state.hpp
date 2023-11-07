#pragma once
#include "./general.hpp"

class Task;
class Action;

#include "./partial_state.hpp"
class State : public PartialState
{
public:
    using PartialState::PartialState;

    class Heuristic;

    bool &is_goal(const PartialState &goal_condition) const;
    vec<Action> &get_applicable_actions(const vec<Action> &actions) const;
    bool can_receive_action(const Action &action) const;
    vec<State> &get_successors(const Action &action) const;
    State get_successor(const PartialState &effect) const;

    static map<Id, bool> are_states_goal;
    static map<Id, vec<Action>> states_applicable_actionss;
    static map<Id, map<int64_t, vec<State>>> states_actions_successor_statess;
};
DEFINE_OBJECT_HASH(State);

class State::Heuristic : public Object
{
public:
    const Task &task;

    Heuristic(const Task &task);

    virtual int operator[](const State &state) const = 0;

    virtual vec<State> get_concrete_states(const PartialState &partial_state) const = 0;
    static map<int64_t, vec<State>> partial_state_to_concrete_state;
};

#include "./task.hpp"
#include "./action.hpp"
