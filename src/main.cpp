#include "./general.hpp"

#include "./task.hpp"
#include "./trie.hpp"
#include "./policy_heuristics/count.hpp"
#include "./policy_heuristics/nearest.hpp"
#include "./policy_heuristics/delta.hpp"
#include "./policy_heuristics/delta_nearest.hpp"
#include "./policy_heuristics/lookup.hpp"
#include "./policy_heuristics/lookup_heuristics/lookup_on_delta_nearest.hpp"
#include "./policy_heuristics/lookup_heuristics/max_lookup_delta_nearest.hpp"
#include "./state_heuristics/blind.hpp"
#include "./state_heuristics/delete_relaxation_heuristics/max.hpp"
#include "./state_heuristics/delete_relaxation_heuristics/add.hpp"
#include "./state_heuristics/delete_relaxation_heuristics/ff.hpp"
#include "./state_heuristics/delete_relaxation_heuristics/lmcut.hpp"
#include "./state_heuristics/trie_based_implementations/trie_star.hpp"
#include "./state_heuristics/star.hpp"
#include "./task_solvers/and_star.hpp"
#include "./samples_generator/sample_generator.hpp"
#include "./samples_generator/random_walk.hpp"
#include "./samples_generator/breadth_first_search.hpp"
#include "./samples_generator/fsm.hpp"
#include "./samples_generator/sample.hpp"

static Trie trie = Trie();
int concrete_states_generator = ConcreteStatesGenerator::ALL;

Policy::Heuristic *parse_policies_heuristics(const Task &task, State::Heuristic *state_heuristic, str policy_heuristic, SampleGenerator *samples_generator, Sample::Treatment *sample_treatment, str file_name)
{
    if (policy_heuristic == "count")
    {
        return new Count(task);
    }
    else if (policy_heuristic == "nearest")
    {
        return new Nearest(task, *state_heuristic);
    }
    else if (policy_heuristic == "delta")
    {
        return new Delta(task, *state_heuristic);
    }
    else if (policy_heuristic == "delta-nearest")
    {
        return new DeltaNearest(task, *state_heuristic);
    }
    else if (policy_heuristic == "lookup-on-delta-nearest")
    {
        return new LookUpOnDeltaNearest(task, *state_heuristic, *samples_generator, *sample_treatment, file_name);
    }
    else if (policy_heuristic == "max-lookup-delta-nearest")
    {
        return new MaxLookUpDeltaNearest(task, *state_heuristic, *samples_generator, *sample_treatment, file_name);
    }
    else
    {
        throw std::domain_error("Invalid policy heuristic.");
    }
}

State::Heuristic *parse_states_heuristics(const Task &task, str state_heuristic_string)
{

    if (state_heuristic_string == "blind")
    {
        return new Blind(task);
    }
    else if (state_heuristic_string == "max")
    {
        return new Max(task);
    }
    else if (state_heuristic_string == "add")
    {
        return new Add(task);
    }
    else if (state_heuristic_string == "ff")
    {
        return new Ff(task);
    }
    else if (state_heuristic_string == "lmcut")
    {
        return new Lmcut(task);
    }
    else if (state_heuristic_string == "star")
    {
        return new Star(task);
    }
    else if (state_heuristic_string == "trie-star")
    {
        return new TrieStar(task);
    }
    else
    {
        throw std::domain_error("Invalid state heuristic.");
    }
}

SampleGenerator *parse_samples_generator(str sample_generator, const Task &task, const State::Heuristic &state_heuristic, const RandomWalk::Walker &walker, int number_of_samples, int length, float porcentage)
{
    if (sample_generator == "rw")
    {
        return new RandomWalk(task, state_heuristic, walker, number_of_samples, length);
    }
    else if (sample_generator == "bfs")
    {
        return new BreadthFirstSearch(task, state_heuristic, number_of_samples);
    }
    else if (sample_generator == "fsm")
    {
        return new Fsm(task, state_heuristic, walker, number_of_samples, length, porcentage);
    }
    else
    {
        throw std::domain_error("Invalid sample generator.");
    }
}

Sample::Treatment *parse_sample_treatment(str sample_treatment)
{
    if (sample_treatment == "ignore")
    {
        return new Ignore();
    }
    else if (sample_treatment == "keep")
    {
        return new Keep();
    }
    else
    {
        throw std::domain_error("Invalid sample treatment.");
    }
}

bool is_number(const std::string &str)
{
    try
    {
        size_t pos;
        std::stoi(str, &pos);
        return pos == str.length();
    }
    catch (const std::invalid_argument &)
    {
        return false;
    }
    catch (const std::out_of_range &)
    {
        return false;
    }
}

int parse_length_data(str length, const Task &task)
{
    if (is_number(length))
    {
        return std::atoi(length.c_str());
    }
    else if (length == "facts")
    {
        return task.facts().size();
    }
    else if (length == "facts-over-effects-mean")
    {
        int counter = 0;
        int number_of_effects = 0;
        for (auto action : task.actions())
        {
            for (auto effect : action.effects())
            {
                number_of_effects++;
                for (auto fact : effect.true_facts())
                {
                    if (not fact.is_none())
                    {
                        counter++;
                    }
                }
            }
        }
        return std::ceil(counter / number_of_effects);
    }
    else if (length == "facts-over-effects-mean-over-actions-mean")
    {
        double counter = 0;
        for (auto action : task.actions())
        {
            int action_counter = 0;
            for (auto effect : action.effects())
            {
                for (auto fact : effect.true_facts())
                {
                    if (not fact.is_none())
                    {
                        action_counter++;
                    }
                }
            }
            counter += double(action_counter) / action.effects().size();
        }
        return std::ceil(counter / task.actions().size());
    }
    else
    {
        throw std::domain_error("Invalid length.");
    }
}

RandomWalk::Walker *parse_random_walk_walker(str walker)
{
    if (walker == "backtracking")
    {
        return new BackTracking();
    }
    else if (walker == "stop")
    {
        return new Stop();
    }
    else if (walker == "restart")
    {
        return new Restart();
    }
    else
    {
        throw std::domain_error("Invalid walker.");
    }
}

void parse_concrete_states_generator(str concrete_states_generator_string)
{
    if (concrete_states_generator_string == "all")
    {
        concrete_states_generator = ConcreteStatesGenerator::ALL;
    }
    else if (concrete_states_generator_string == "random")
    {
        concrete_states_generator = ConcreteStatesGenerator::RANDOM;
    }
    else
    {
        throw std::domain_error("Invalid concrete states generator.");
    }
}

std::vector<std::string> split(const std::string &s, char delimiter)
{
    std::vector<std::string> tokens;
    std::istringstream ss(s);
    std::string token;

    while (std::getline(ss, token, delimiter))
    {
        tokens.push_back(token);
    }

    return tokens;
}

str get_domain(str domain_path)
{
    vec<str> tokens = split(domain_path, '/');
    tokens = split(tokens[tokens.size() - 2], '.');
    return tokens[0];
}

str get_problem(str problem_path)
{
    vec<str> tokens = split(problem_path, '/');
    tokens = split(tokens[tokens.size() - 1], '.');
    return tokens[0];
}

Task::Regressor* parse_regressor(str regressor_string)
{
    if(regressor_string == "equality")
    {
        return new Equality();
    }
    else
    if (regressor_string == "action-proportionality")
    {
        return new ActionProportionality();
    }
    else
    {
        throw std::domain_error("Invalid regressor.");
    }
}

void print_end(char** argv, const Task& task, Policy::Heuristic* policy_heuristic, AndStar& and_star, opt<Policy> opt_solution, int number_of_states_generated_on_state_heuristic_table = -1)
{
    std::cout << "domain,problem,policy_heuristic,state_heuristic,number_of_samples,length,percentage_fsm,sample_generator,sample_treatment_class,percentage_timer,percentage_time_limit,percentage_memory_limit,walker,concrete_states_generator,regressor,termination,memory_usage,time,number_of_generated_policies,number_of_inserted_policies,number_of_removed_policies,number_of_expanded_policies,solution_length,number_of_lookups,number_of_states_generated_on_state_heuristic_table" << std::endl;
    std::cout << get_domain(str(argv[1])); // domain
    std::cout << "," << get_problem(str(argv[2])); // problem
    std::cout << "," << str(argv[3]); // policy_heuristic
    std::cout << "," << str(argv[4]); // state_heuristic
    std::cout << "," << std::atoi(argv[5]); // number_of_samples
    std::cout << "," << parse_length_data(argv[6], task); // length
    std::cout << "," << std::atof(argv[7]); // percentage_fsm
    std::cout << "," << str(argv[8]); // sample_generator
    std::cout << "," << str(argv[9]); // sample_treatment_class
    std::cout << "," << std::atof(argv[10]); // percentage_timer
    std::cout << "," << std::atof(argv[11]); // percentage_time_limit
    std::cout << "," << std::atof(argv[12]); // percentage_memory_limit
    std::cout << "," << str(argv[13]); // walker
    std::cout << "," << str(argv[14]); // concrete_states_generator
    std::cout << "," << str(argv[15]); // regressor
    std::cout << "," << policy_types_names[get_policy_type()]; // termination
    std::cout << "," << get_memory_usage(); // memory_usage
    std::cout << "," << get_ellapsed_time(); // time
    std::cout << "," << and_star.number_of_generated_policies; // number_of_generated_policies
    std::cout << "," << and_star.number_of_inserted_policies; // number_of_inserted_policies
    std::cout << "," << and_star.number_of_removed_policies; // number_of_removed_policies
    std::cout << "," << and_star.number_of_expanded_policies; // number_of_expanded_policies
    std::cout << "," << (opt_solution.has_value() ? opt_solution->size() : -1); // solution_length
    std::cout << "," << (str(argv[3]) == "lookup") ? static_cast<LookUp *>(policy_heuristic)->number_of_lookups : -1; // number_of_lookups
    std::cout << "," << number_of_states_generated_on_state_heuristic_table; // number_of_states_generated_on_state_heuristic_table
}

double percentage_timer = 0.1;
double percentage_memory_limit = 0.9;
double sample_generation_alarm = 0.7;
double policy_alarm;
double step;

void set_step_and_policy_alarm()
{
    assert (0 <= sample_generation_alarm and sample_generation_alarm <= 1);
    step = percentage_timer * sample_generation_alarm * (get_time_limit() - get_ellapsed_time());
    policy_alarm = 1 - sample_generation_alarm;
}

int main(int argc, char **argv)
{
    assert(get_memory_limit() <= 8);
    assert(get_time_limit() <= 1800);
    Task::Regressor *regressor = parse_regressor(str(argv[15]));
    Task task = Task(str(argv[1]), str(argv[2]), *regressor);
    int number_of_samples = std::atoi(argv[5]);
    int length = parse_length_data(argv[6], task);
    float porcentage = std::atof(argv[7]);
    percentage_timer = std::atof(argv[10]);
    sample_generation_alarm = std::atof(argv[11]);
    set_step_and_policy_alarm();
    percentage_memory_limit = std::atof(argv[12]);
    parse_concrete_states_generator(str(argv[14]));
    RandomWalk::Walker *walker = parse_random_walk_walker(str(argv[13]));
    State::Heuristic *state_heuristic = parse_states_heuristics(task, str(argv[4]));
    SampleGenerator *samples_generator = parse_samples_generator(str(argv[8]), task, *state_heuristic, *walker, number_of_samples, length, porcentage);
    Sample::Treatment *sample_treatment = parse_sample_treatment(str(argv[9]));
    str samples_file_name = argv[argc - 1]; // the last argument is the samples file name
    Policy::Heuristic *policy_heuristic = parse_policies_heuristics(task, state_heuristic, str(argv[3]), samples_generator, sample_treatment, samples_file_name);
    AndStar and_star = AndStar(*policy_heuristic, *state_heuristic);
    Policy opt_solution = and_star.get_solution(task);
    print_end(argv, task, policy_heuristic, and_star, opt_solution, state_heuristic->size());
    return 0;
}
