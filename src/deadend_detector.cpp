#include "deadend_detector.hpp"
#include <fstream>

map<int64_t, int> DeadEndDetector::labeled_states;

void create_states(const Task &task, const vec<Fact> &facts, set<State> &states, const int depth)
{
    if (depth == task.variables().size())
    {
        State s(facts);
        states.insert(s);
    }
    else
    {
        for (auto fact : task.variables()[depth].facts())
        {
            vec<Fact> newFacts = facts;
            newFacts.emplace_back(fact); // Append fact to the end of the vector
            create_states(task, newFacts, states, depth + 1);
        }
    }
}

void DeadEndDetector::find_weak_alive_states(const set<State> &goal_states, map<State, StateActionPairSet> &reversed_edges, set<State> &weak_alive_states, StateActionPairSet &bad_state_action_pairs)
{
    vec<State> states_at_next_depth;
    vec<State> states_at_current_depth = vec<State>(goal_states.begin(), goal_states.end());
    set<State> visited = goal_states;

    while (not(states_at_current_depth.empty() and states_at_next_depth.empty()))
    {
        if (states_at_current_depth.empty())
        {
            states_at_current_depth.swap(states_at_next_depth);
        }
        State state = states_at_current_depth.back();
        states_at_current_depth.pop_back();
        if (this->labeled_states.contains(state.id) and this->labeled_states[state.id] == DEAD_END)
        {
            continue;
        }
        for (auto state_action_pair : reversed_edges[state])
        {
            if (bad_state_action_pairs.contains(state_action_pair))
            {
                continue;
            }
            State predecessor_state = state_action_pair.first;
            Action action = state_action_pair.second;
            if (visited.contains(predecessor_state))
            {
                continue;
            }
            else
            {
                states_at_next_depth.push_back(predecessor_state);
                visited.insert(predecessor_state);
                if (not this->labeled_states.contains(predecessor_state.id))
                {
                    this->labeled_states[predecessor_state.id] = WEAK_ALIVE;
                    // std::cerr << "LOG::DeadEndDetector::State: [" << predecessor_state << "] marked as WeakAlive." << std::endl;
                    weak_alive_states.insert(predecessor_state);
                }
            }
        }
    }
    // std::cerr << "LOG::DeadEndDetector::#3.\n";
    // std::cerr << "LOG::DeadEndDetector::WeakAliveStates after adding new states: " << weak_alive_states.size() << std::endl;
}

void DeadEndDetector::find_dead_end_states(const set<State> &states, set<State> &dead_end_states)
{
    for (const State &state : states)
    {
        if (not this->labeled_states.contains(state.id))
        {
            this->labeled_states[state.id] = DEAD_END;
            // std::cerr << "LOG::DeadEndDetector::State: [" << state << "] marked as DeadEnd." << std::endl;
            dead_end_states.insert(state);
        }
    }
    // std::cerr << "LOG::DeadEndDetector::#4.\n";
    // std::cerr << "LOG::DeadEndDetector::States: " << states.size() << std::endl;
    // std::cerr << "LOG::DeadEndDetector::DeadEndStates: " << dead_end_states.size() << std::endl;
}

void DeadEndDetector::test_whether_weak_alive_states_are_dead_end_states(set<State> &weak_alive_states, set<State> &dead_end_states)
{
    bool all_actions_are_bad = true;
    do
    {
        State weak_alive_state;
        all_actions_are_bad = true;
        for (auto it = weak_alive_states.begin(); it != weak_alive_states.end(); it++)
        {
            all_actions_are_bad = true;
            weak_alive_state = *it;
            for (const Action &action : weak_alive_state.get_applicable_actions(task.actions()))
            {
                bool is_dead_end = false;
                for (const State &successor_state : weak_alive_state.get_successors(action))
                {
                    if (dead_end_states.contains(successor_state))
                    {
                        is_dead_end = true;
                        break;
                    }
                }
                if (not is_dead_end)
                {
                    all_actions_are_bad = false;
                    break;
                }
            }
            if (all_actions_are_bad)
                break;
        }
        if (all_actions_are_bad)
        {
            this->labeled_states[weak_alive_state.id] = DEAD_END;
            // std::cerr << "LOG::DeadEndDetector::WeakAliveState: [" << weak_alive_state << "] now marked as DeadEnd." << std::endl;
            dead_end_states.insert(weak_alive_state);
            weak_alive_states.erase(weak_alive_state);
        }
    } while (all_actions_are_bad);
    // std::cerr << "LOG::DeadEndDetector::#5." << std::endl;
    // std::cerr << "LOG::DeadEndDetector::WeakAliveStates: " << weak_alive_states.size() << std::endl;
}

void DeadEndDetector::mark_goal_states_as_alive(const Task &task, const set<State> &states, map<State, StateActionPairSet> &reversed_edges, set<State> &goal_states, set<State> &non_goal_states)
{
    vec<State> stack;
    set<State> states_to_explore = states;
    // 2.
    stack.push_back(task.initial_state());
    while (not states_to_explore.empty() or not stack.empty())
    {
        while (not stack.empty())
        {
            State state = stack.back();
            stack.pop_back();
            states_to_explore.erase(state);

            if (state.is_goal(task.goal_condition()))
            {
                this->labeled_states[state.id] = ALIVE;
                // std::cerr << "LOG::DeadEndDetector::GoalState: [" << state << "] marked as alive directly." << std::endl;
                goal_states.insert(state);
                continue;
            }

            non_goal_states.insert(state);
            for (const Action &action : state.get_applicable_actions(task.actions()))
            {
                for (const State &succesor_state : state.get_successors(action))
                {
                    reversed_edges[succesor_state].insert(std::make_pair(state, action));
                    if(states_to_explore.contains(succesor_state))
                    {
                        stack.push_back(succesor_state);
                    }
                }
            }
        }
        if (stack.empty() and not states_to_explore.empty())
        {
            stack.push_back(*states_to_explore.begin());
            states_to_explore.erase(states_to_explore.begin());
        }
    }
    std::cerr << "LOG::DeadEndDetector::#2.\n";
    std::cerr << "LOG::DeadEndDetector::#States: " << states.size() << std::endl;
    std::cerr << "LOG::DeadEndDetector::#GoalStates: " << goal_states.size() << std::endl;
    std::cerr << "LOG::DeadEndDetector::#NonGoalStates: " << non_goal_states.size() << std::endl;
    std::cerr << "LOG::DeadEndDetector::#StatesToExplore: " << states_to_explore.size() << std::endl;
    assert(states.size() == goal_states.size() + non_goal_states.size());
}

void DeadEndDetector::transform_weak_alive_states_into_alive_states(const set<State> &weak_alive_states)
{
    for (auto weak_alive_state : weak_alive_states)
    {
        this->labeled_states[weak_alive_state.id] = ALIVE;
        // std::cerr << "LOG::DeadEndDetector::WeakAliveState: [" << weak_alive_state << "] now marked as Alive." << std::endl;
    }
}

void count_and_print(const set<State> &states, const set<State> &goal_states, const set<State> &non_goal_states, const map<int64_t, int> &labeled_states)
{
    int dead_end_states_count = 0, alive_count = 0, weak_alive_count = 0;
    std::ofstream file("deadend_states.txt");
    for (auto [state_id, label] : labeled_states)
    {
        file << state_id << " -> " << state_label_to_string[label] << std::endl;
        switch (label)
        {
        case DEAD_END:
            dead_end_states_count++;
            break;
        case ALIVE:
            alive_count++;
            break;
        case WEAK_ALIVE:
            weak_alive_count++;
            break;
        default:
            break;
        }
    }
    std::cerr << "LOG::DeadEndDetector::-------------------------------------------------------\n";
    std::cerr << "LOG::DeadEndDetector::DeadEndStates: " << dead_end_states_count << std::endl;
    std::cerr << "LOG::DeadEndDetector::AliveStates: " << alive_count << std::endl;
    std::cerr << "LOG::DeadEndDetector::WeakAliveStates: " << weak_alive_count << std::endl;
    std::cerr << "LOG::DeadEndDetector::#States: " << states.size() << std::endl;
    std::cerr << "LOG::DeadEndDetector::#GoalStates: " << goal_states.size() << std::endl;
    std::cerr << "LOG::DeadEndDetector::#NonGoalStates: " << non_goal_states.size() << std::endl;
    assert(states.size() == goal_states.size() + non_goal_states.size());
    assert(weak_alive_count == 0);
    assert(states.size() == dead_end_states_count + alive_count);
    std::cerr << "LOG::DeadEndDetector::-------------------------------------------------------\n";
}

DeadEndDetector::DeadEndDetector(const Task &task) : task(task)
{
    // 1.
    set<State> states;
    create_states(this->task, vec<Fact>(), states, 0);
    // std::cerr << "LOG::DeadEndDetector::#1.\n";
    // std::cerr << "LOG::DeadEndDetector::#States: " << states.size() << std::endl;

    // 2.
    map<int64_t, int64_t> predecessor;
    map<State, StateActionPairSet> reversed_edges;
    set<State> goal_states;
    set<State> non_goal_states;
    this->mark_goal_states_as_alive(this->task, states, reversed_edges, goal_states, non_goal_states);

    // loop 3,4,5 until there is no change in the number of weak alive states
    set<State> weak_alive_states;
    set<State> dead_end_states;
    StateActionPairSet bad_state_action_pairs;
    int number_of_weak_alive_states_on_previous_iteration = 0, it = 0;
    do
    {
        number_of_weak_alive_states_on_previous_iteration = weak_alive_states.size();
        if (not weak_alive_states.empty())
        {
            // unlabel weak alive states and repeat 3,4,5
            for (auto weak_alive_state : weak_alive_states)
            {
                this->labeled_states.erase(weak_alive_state.id);
            }
        }

        for (auto dead_end_state : dead_end_states)
        {
            for (auto pair_state_action : reversed_edges[dead_end_state])
            {
                bad_state_action_pairs.insert(pair_state_action);
            }
        }

        // 3.
        this->find_weak_alive_states(goal_states, reversed_edges, weak_alive_states, bad_state_action_pairs);

        // 4.
        this->find_dead_end_states(non_goal_states, dead_end_states);

        // 5.
        this->test_whether_weak_alive_states_are_dead_end_states(weak_alive_states, dead_end_states);

        std::cerr << "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$\n";
        std::cerr << "LOG::DeadEndDetector::iteration: " << ++it << std::endl;
        std::cerr << "LOG::DeadEndDetector::WeakAliveStates: " << weak_alive_states.size() << std::endl;
        std::cerr << "LOG::DeadEndDetector::DeadEndStates: " << dead_end_states.size() << std::endl;
        std::cerr << "LOG::DeadEndDetector::#States: " << states.size() << std::endl;
        std::cerr << "LOG::DeadEndDetector::#GoalStates: " << goal_states.size() << std::endl;
        std::cerr << "LOG::DeadEndDetector::#NonGoalStates: " << non_goal_states.size() << std::endl;
        std::cerr << "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$\n";

    } while (not(number_of_weak_alive_states_on_previous_iteration == weak_alive_states.size()));

    // 6.
    this->transform_weak_alive_states_into_alive_states(weak_alive_states);

    for (auto dead_end_state : dead_end_states)
    {
        std::cerr << "LOG::DeadEndDetector::DeadEndState: [" << dead_end_state << "]" << std::endl;
    }

    count_and_print(states, goal_states, non_goal_states, this->labeled_states);

    map<str, vec<State>> actions_statess = {
        {"deadend", vec<State>()},
        {"alive", vec<State>()},
    };
    map<State, str> mappings;
    map<str, set<Fact>> actions_factss = {
        {"deadend", set<Fact>()},
        {"alive", set<Fact>()},
    };
    map<State, set<Fact>> states_factss;
    std::ofstream file("states.txt");
    if (not file.is_open())
    {
        std::cerr << "LOG::DeadEndDetector::Error opening file." << std::endl;
        return;
    }
    for (auto [state_id, label] : this->labeled_states)
    {
        State state;
        state.id = state_id;
        file << state << " -> " << state_label_to_string[label] << std::endl;
        mappings[state] = state_label_to_string[label];
        actions_statess[state_label_to_string[label]].push_back(state);
        actions_factss[state_label_to_string[label]].insert(state.true_facts().begin(), state.true_facts().end());
        states_factss[state] = set<Fact>(state.true_facts().begin(), state.true_facts().end());
    }
    // print_integer_programming(actions_statess, mappings, actions_factss, states_factss);
    end_program();
};

bool DeadEndDetector::operator[](const State &state) const
{
    return true;
}

// key_action in your context is the label you are interested in listing, namely, "deadend"
// there are some structures you need to fill first, actions_statess for instance stores, for each label, the states with that label
// each partial state will be a line in your final result, y represents the number of lines in your final result
// the bizarre things when filling the output_str is a prettier way of outputing the relevant facts
void print_integer_programming(map<str, vec<State>> mapping_label_to_states, map<State, str> mapping_state_to_lebel, map<str, set<Fact>> mapping_label_to_facts, map<State, set<Fact>> map_state_to_facts)
{
    std::stringstream output_str;
    bool has_completed = false;
    str key_label = "deadend";

    for (int y = 1; y <= mapping_label_to_states[key_label].size() and not has_completed; y++)
    {
        IloEnv env;
        IloModel model(env);
        IloExpr objective_expr = IloExpr(env);
        vec<map<Fact, IloNumVar>> partial_states_factss_variabless;
        vec<map<State, IloNumVar>> partial_states_statess_variabless;
        for (int i = 0; i < y; i++)
        {
            partial_states_factss_variabless.emplace_back();
            for (const Fact &fact : mapping_label_to_facts[key_label])
            {
                partial_states_factss_variabless.back()[fact] = IloNumVar(env, 0, 1, ILOBOOL);
                objective_expr += partial_states_factss_variabless.back()[fact];
            }

            partial_states_statess_variabless.emplace_back();
            for (const std::pair<State, str> &state_action : mapping_state_to_lebel)
            {
                State state = state_action.first;
                str label = state_action.second;
                if (label == key_label)
                {
                    partial_states_statess_variabless.back()[state] = IloNumVar(env, 0, 1, ILOBOOL);
                    for (const Fact &fact : mapping_label_to_facts[key_label])
                    {
                        if (not map_state_to_facts[state].contains(fact))
                        {
                            model.add(partial_states_factss_variabless.back()[fact] + partial_states_statess_variabless.back()[state] <= 1);
                        }
                    }
                }
                else
                {
                    IloExpr expr = IloExpr(env);
                    for (const Fact &fact : mapping_label_to_facts[key_label])
                    {
                        if (not map_state_to_facts[state].contains(fact))
                        {
                            expr += partial_states_factss_variabless.back()[fact];
                        }
                    }
                    model.add(expr >= 1);
                    expr.end();
                }
            }
            // for (const State &state : policy_outgoing_states)
            // {
            //     IloExpr expr = IloExpr(env);
            //     for (const Fact &fact : actions_factss[key_action])
            //     {
            //         if (not states_factss[state].contains(fact))
            //         {
            //             expr += partial_states_factss_variabless.back()[fact];
            //         }
            //     }
            //     model.add(expr >= 1);
            //     expr.end();
            // }
        }
        for (const State &state : mapping_label_to_states[key_label])
        {
            IloExpr expr = IloExpr(env);
            for (int i = 0; i < y; i++)
            {
                expr += partial_states_statess_variabless[i][state];
            }
            model.add(expr >= 1);
            expr.end();
        }
        model.add(IloMinimize(env, objective_expr));
        objective_expr.end();

        IloCplex cplex = IloCplex(env);
        cplex.setOut(env.getNullStream());
        cplex.setWarning(env.getNullStream());
        cplex.setParam(IloCplex::Param::Threads, 1);
        cplex.extract(model);
        std::cerr << "LOG::DeadEndDetector::#rows: " << cplex.getNrows() << std::endl;
        std::cerr << "LOG::DeadEndDetector::#columns: " << cplex.getNcols() << std::endl;

        try
        {
            cplex.solve();
        }
        catch (IloException &e)
        {
            std::cout << e.getMessage() << std::endl;
            throw(e);
        }
        switch (cplex.getStatus())
        {
        case IloAlgorithm::Status::Optimal:
        {
            has_completed = true;
            for (int i = 0; i < y; i++)
            {
                vec<Fact> partial_state_true_facts;
                for (const Fact &fact : mapping_label_to_facts[key_label])
                {
                    if (cplex.isExtracted(partial_states_factss_variabless[i][fact]) and int(cplex.getValue(partial_states_factss_variabless[i][fact]) + 0.5) == 1)
                    {
                        partial_state_true_facts.push_back(fact);
                    }
                }
                PartialState partial_state = PartialState(partial_state_true_facts);
                std::cout << "[" << partial_state << "]"
                          << " -> " << key_label << std::endl;
                output_str << "If holds:";
                bool first = true;
                for (const Fact &fact : partial_state.true_facts())
                {
                    if (not fact.is_none())
                    {
                        if (not first)
                        {
                            output_str << "/";
                        }
                        first = false;

                        if (fact.value().starts_with("Atom "))
                        {
                            output_str << " " << fact.value().substr(5) << " ";
                        }
                        else if (fact.value().starts_with("NegatedAtom "))
                        {
                            output_str << " not(" << fact.value().substr(12) << ") ";
                        }
                        else
                        {
                            assert(fact.value() == "<none of those>");
                            bool first = true;
                            for (const Fact &other_fact : fact.variable().facts())
                            {
                                if (other_fact != fact)
                                {
                                    if (not first)
                                    {
                                        output_str << "/";
                                    }
                                    first = false;
                                    assert(other_fact.value().starts_with("Atom "));
                                    output_str << " not(" << other_fact.value().substr(5) << ") ";
                                }
                            }
                        }
                    }
                }
                output_str << std::endl;
                output_str << "Execute: " << key_label << std::endl;
                output_str << std::endl;
            }
        }
        break;

        case IloAlgorithm::Status::Infeasible:
            break;

        default:
            assert(false);
            break;
        }
        cplex.clear();
        env.end();
    }

    assert(has_completed);
}