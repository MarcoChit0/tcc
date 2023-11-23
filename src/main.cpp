#include "./general.hpp"

#include "./task.hpp"
#include "./trie.hpp"
#include "./policy_heuristics/count.hpp"
#include "./policy_heuristics/nearest.hpp"
#include "./policy_heuristics/delta.hpp"
#include "./policy_heuristics/delta_nearest.hpp"
#include "./policy_heuristics/lookup.hpp"
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

void print_end(const str& domain, const str& problem, const opt<Policy> &opt_solution, const AndStar &and_star, str policy_heuristic_string, str state_heuristic_string, Policy::Heuristic* policy_heuristic, int number_of_samples, int length, float percentage)
{
    std::cout << "domain,problem,termination,memory,time,generated,inserted,removed,expanded,solution_size,policy_heuristic,state_heuristic,number_of_samples,length,percentage,number_of_lookups" << std::endl;
    std::cout << domain;
    std::cout << "," << problem; 
    std::cout << "," << (opt_solution.has_value() ? "optimal" : "suboptimal");
    std::cout << "," << get_memory_usage();
    std::cout << "," << get_ellapsed_time();
    std::cout << "," << and_star.number_of_generated_policies;
    std::cout << "," << and_star.number_of_inserted_policies;
    std::cout << "," << and_star.number_of_removed_policies;
    std::cout << "," << and_star.number_of_expanded_policies;
    std::cout << "," << (opt_solution.has_value() ? opt_solution->size() : -1);
    std::cout << "," << policy_heuristic_string;
    std::cout << "," << state_heuristic_string;
    std::cout << "," << number_of_samples;
    std::cout << "," << length;
    std::cout << "," << percentage;
    std::cout << "," << (policy_heuristic_string == "lookup") ? static_cast<LookUp *>(policy_heuristic)->number_of_lookups : -1;
    std::cout << std::endl;
}

Policy::Heuristic *parse_policies_heuristics(const Task &task, State::Heuristic *state_heuristic, str policy_heuristic, SampleGenerator *samples_generator, Sample::Treatment* sample_treatment, str file_name)
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
    else if (policy_heuristic == "lookup")
    {
        return new LookUp(task, *state_heuristic, *samples_generator, *sample_treatment, file_name);
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

SampleGenerator *parse_samples_generator(str sample_generator, const Task &task, const State::Heuristic &state_heuristic, const RandomWalk::Walker& walker,int number_of_samples, int length, float porcentage)
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

Sample::Treatment* parse_sample_treatment(str sample_treatment)
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

bool is_number(const std::string& str) {
    try {
        size_t pos;
        std::stoi(str, &pos);
        return pos == str.length();
    } catch (const std::invalid_argument&) {
        return false;
    } catch (const std::out_of_range&) {
        return false;
    }
}

int parse_length_data(str length, const Task& task)
{
    if (is_number(length))
    {
        return std::atoi(length.c_str());
    }
    else
    if(length == "facts")
    {
        return task.facts().size();
    }
    else
    if(length == "facts-over-mean")
    {
        int counter = 0;
        int number_of_effects = 0;
        for(auto action : task.actions())
        {
            for(auto effect : action.effects())
            {
                number_of_effects++;
                for(auto fact : effect.facts())
                {
                    if(not fact.is_none())
                    {
                        counter++;
                    }
                }
            }
        }
        return std::ceil(counter / number_of_effects);
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

std::vector<std::string> split(const std::string& s, char delimiter) {
    std::vector<std::string> tokens;
    std::istringstream ss(s);
    std::string token;

    while (std::getline(ss, token, delimiter)) {
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

str get_samples_file_name(int argc, char** argv)
{
    str file_name = "misc/data/samples/samples_";
    str domain = get_domain(str(argv[1]));
    str problem = get_problem(str(argv[2]));
    file_name += domain + "_" + problem + "_";
    for(int i = 3; i < argc; i++)
    {
        file_name += str(argv[i]);
        if(i < argc - 1)
        {
            file_name += "_";
        }
    }
    file_name += ".csv";
    return file_name;
}

double percentage_timer = 0.1;
double percentage_time_limit = 0.9;
double percentage_memory_limit = 0.9;

int main(int argc, char **argv)
{
    // assert(get_memory_limit() <= 8);
    // assert(get_time_limit() <= 1800);
    Task task = Task(str(argv[1]), str(argv[2]));
    int number_of_samples = std::atoi(argv[5]);
    int length = parse_length_data(argv[6], task);
    float porcentage = std::atof(argv[7]);
    percentage_timer = std::atof(argv[10]);
    percentage_time_limit = std::atof(argv[11]);
    percentage_memory_limit = std::atof(argv[12]);
    parse_concrete_states_generator(str(argv[14]));
    RandomWalk::Walker *walker = parse_random_walk_walker(str(argv[13]));
    State::Heuristic* state_heuristic = parse_states_heuristics(task, str(argv[4]));
    SampleGenerator *samples_generator = parse_samples_generator(str(argv[8]), task, *state_heuristic, *walker, number_of_samples, length, porcentage);
    Sample::Treatment* sample_treatment = parse_sample_treatment(str(argv[9]));
    str samples_file_name = get_samples_file_name(argc, argv);
    Policy::Heuristic* policy_heuristic = parse_policies_heuristics(task, state_heuristic, str(argv[3]), samples_generator, sample_treatment, samples_file_name);
    AndStar and_star = AndStar(*policy_heuristic, *state_heuristic);
    Policy opt_solution = and_star.get_solution(task);
    print_end(get_domain(str(argv[1])), get_problem(str(argv[2])), opt_solution, and_star, str(argv[3]), str(argv[4]), policy_heuristic, number_of_samples, length, porcentage);
    return 0;
}

