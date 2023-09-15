#include "./task.hpp"

Task::Task(const str &domain_file_name, const str &task_file_name)
{
    std::stringstream sas {get_output("translate", "python3 ./dep/translate/translate.py " + domain_file_name + " " + task_file_name)};
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
        }
        sas >> buffer;
        assert(buffer == "end_variable");
        current_variable_hash *= variable_domain_size + 1;
    }

    int number_of_mutexes;
    sas >> number_of_mutexes;
    for (int _ = 0; _ < number_of_mutexes; _++)
    {
        sas >> buffer;
        assert(buffer == "begin_mutex_group");
        while (sas >> buffer, buffer != "end_mutex_group");
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
