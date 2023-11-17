#pragma once

#include "../state.hpp"
class DeleteRelaxationHeuristic : public State::Heuristic
{
public:

    static void set_start_action(const State &state);

    DeleteRelaxationHeuristic(const Task &task);

    virtual int operator[](const State &state) const = 0;

    static map<Fact, set<Action>> facts_successor_actions;
    static map<Fact, set<Action>> facts_predecessor_actions;
    static map<Action, set<Fact>> actions_successor_facts;
    static map<Action, set<Fact>> actions_predecessor_facts;
    static Fact start_fact;
    static Fact final_fact;
    static Action start_action;
    static Action final_action;

    set<State> get_concrete_states(const PartialState &partial_state) const override;
};
