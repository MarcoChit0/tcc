#include "./task.hpp"

Task::Task(const str &domain_file_name, const str &task_file_name)
{
    std::stringstream sas{get_output("translate", "python3 ./dep/translate/translate.py " + domain_file_name + " " + task_file_name)};
    str buffer;

    sas >> buffer;
    assert(buffer == "begin_version");
    sas >> buffer;
    assert(buffer == "3");
    sas >> buffer;
    assert(buffer == "end_version");

    sas >> buffer;
    assert(buffer == "begin_metric");
    sas >> buffer;
    assert(buffer == "0" or buffer == "1");
    bool using_metric = buffer == "1";
    sas >> buffer;
    assert(buffer == "end_metric");

    int number_of_variables;
    sas >> number_of_variables;
    mpz_class current_variable_hash = 1;
    for (int i = 0; i < number_of_variables; i++)
    {
        sas >> buffer;
        assert(buffer == "begin_variable");
        sas >> buffer;
        str variable_name = buffer;
        Variable variable = Variable(variable_name);
        this->variable_to_index[variable.id] = i;
        this->variables().push_back(variable);
        sas >> buffer;
        int variable_domain_size;
        sas >> variable_domain_size;
        std::getline(sas, buffer);
        for (int j = 0; j < variable_domain_size; j++)
        {
            std::getline(sas, buffer);
            this->facts().emplace_back(variable, buffer, (j + 1) * current_variable_hash);
            variable.facts().push_back(this->facts().back());
            this->fact_to_fact_offset[this->facts().back().id] = j;
        }
        sas >> buffer;
        assert(buffer == "end_variable");
        current_variable_hash *= variable_domain_size + 1;
        this->variable_to_variable_domain_size[variable.id] = variable_domain_size;
    }

    int number_of_mutexes_groups;
    sas >> number_of_mutexes_groups;
    for (int group = 0; group < number_of_mutexes_groups; group++)
    {
        sas >> buffer;
        assert(buffer == "begin_mutex_group");
        int number_of_mutexes_in_group;
        sas >> number_of_mutexes_in_group;
        set<Fact> mutex_group;
        for (int mutex_index = 0; mutex_index < number_of_mutexes_in_group; mutex_index++)
        {
            int variable, value;
            sas >> variable;
            sas >> value;
            mutex_group.insert(this->variables()[variable].facts()[value]);
        }
        sas >> buffer;
        assert(buffer == "end_mutex_group");
        this->mutex_groups().insert(mutex_group);
    }

    sas >> buffer;
    assert(buffer == "begin_state");
    vec<Fact> initial_state_true_facts;
    for (int i = 0; i < number_of_variables; i++)
    {
        int j;
        sas >> j;
        initial_state_true_facts.push_back(this->variables()[i].facts()[j]);
    }
    sas >> buffer;
    assert(buffer == "end_state");
    this->initial_state() = State(initial_state_true_facts);

    sas >> buffer;
    assert(buffer == "begin_goal");
    vec<Fact> goal_condition_true_facts = vec<Fact>(number_of_variables);
    int number_of_goal_condition_facts;
    sas >> number_of_goal_condition_facts;
    for (int _ = 0; _ < number_of_goal_condition_facts; _++)
    {
        int i, j;
        sas >> i;
        sas >> j;
        goal_condition_true_facts[i] = this->variables()[i].facts()[j];
    }
    sas >> buffer;
    assert(buffer == "end_goal");
    this->goal_condition() = PartialState(goal_condition_true_facts);

    str action_name;
    vec<Fact> action_precondition_true_facts;
    vec<PartialState> action_effects;
    int action_cost;
    int number_of_actions_effects;
    sas >> number_of_actions_effects;
    for (int _ = 0; _ < number_of_actions_effects; _++)
    {
        sas >> buffer;
        assert(buffer == "begin_operator");
        std::getline(sas, buffer);
        std::getline(sas, buffer);
        if (buffer != action_name)
        {
            if (action_name != str())
            {
                if (this->action_classes().empty() or this->action_classes().back() != action_name.substr(0, action_name.find(" ")))
                {
                    this->action_classes().push_back(action_name.substr(0, action_name.find(" ")));
                }
                this->actions().emplace_back(action_name, PartialState(action_precondition_true_facts), action_effects, action_cost);
            }
            action_name = buffer;
            action_precondition_true_facts = vec<Fact>(number_of_variables);
            action_effects = vec<PartialState>();
            action_cost = NONE;
        }
        vec<Fact> action_effect_true_facts = vec<Fact>(number_of_variables);
        int action_number_of_precondition_raw_facts;
        sas >> action_number_of_precondition_raw_facts;
        for (int _ = 0; _ < action_number_of_precondition_raw_facts; _++)
        {
            int i, j;
            sas >> i;
            sas >> j;
            action_precondition_true_facts[i] = this->variables()[i].facts()[j];
        }
        int action_effect_number_of_atomic_effects;
        sas >> action_effect_number_of_atomic_effects;
        for (int _ = 0; _ < action_effect_number_of_atomic_effects; _++)
        {
            int action_effect_atomic_effect_condition_number_of_facts;
            sas >> action_effect_atomic_effect_condition_number_of_facts;
            assert(action_effect_atomic_effect_condition_number_of_facts == 0);
            int i;
            sas >> i;
            int j;
            sas >> j;
            if (j != NONE)
            {
                action_precondition_true_facts[i] = this->variables()[i].facts()[j];
            }
            sas >> j;
            action_effect_true_facts[i] = this->variables()[i].facts()[j];
        }
        action_effects.emplace_back(action_effect_true_facts);
        sas >> action_cost;
        if (not using_metric)
        {
            action_cost = 1;
        }
        assert(action_cost == 1);
        sas >> buffer;
        assert(buffer == "end_operator");
    }
    if (action_name != str())
    {
        if (this->action_classes().empty() or this->action_classes().back() != action_name.substr(0, action_name.find(" ")))
        {
            this->action_classes().push_back(action_name.substr(0, action_name.find(" ")));
        }
        this->actions().emplace_back(action_name, PartialState(action_precondition_true_facts), action_effects, action_cost);
    }

    sas >> buffer;
    assert(buffer == "0");
};

bool Task::violate_mutex(const PartialState &partial_state) const
{
    int count = -1;
    for (set<Fact> mutex_group : this->mutex_groups())
    {
        count ++;
        int number_of_violated_mutexes = 0;
        for (Fact fact : mutex_group)
        {
            if(partial_state.contains(fact, this->variable_to_index[fact.variable().id]) and ++number_of_violated_mutexes >= 2)
            {
                return true;
            }
        }
    }
    return false;
}

vec<PartialState> Task::get_regressed_partial_states(const PartialState &partial_state) const
{
    if (not regressed_partial_states.contains(partial_state.id))
    {
        if (this->violate_mutex(partial_state))
        {
            return vec<PartialState>();
        }
        vec<PartialState> predecessors;
        set<int64_t> predecessors_ids;
        for (auto action : this->actions())
        {
            for (auto effect : action.effects())
            {
                if (partial_state.does_model(effect))
                {
                    vec<Fact> predecessor_facts = partial_state.true_facts();
                    for (int i = 0; i < effect.true_facts().size(); i++)
                    {
                        if (not effect.true_facts()[i].is_none())
                        {
                            predecessor_facts[i].id = NONE;
                        }
                    }
                    for (int i = 0; i < action.precondition().true_facts().size(); i++)
                    {
                        if (not action.precondition().true_facts()[i].is_none())
                        {
                            predecessor_facts[i].id = action.precondition().true_facts()[i].id;
                        }
                    }
                    PartialState predecessor = PartialState(predecessor_facts);
                    if (not predecessors_ids.contains(predecessor.id) and not this->violate_mutex(predecessor))
                    {
                        predecessors_ids.insert(predecessor.id);
                        predecessors.push_back(predecessor);
                    }
                }
            }
        }
        regressed_partial_states[partial_state.id] = predecessors;
    }
    return regressed_partial_states[partial_state.id];
}

map<int64_t, vec<PartialState>> Task::regressed_partial_states;
map<int64_t, int64_t> Task::variable_to_index;
map<int64_t, int64_t> Task::variable_to_variable_domain_size;
map<int64_t, int64_t> Task::fact_to_fact_offset;