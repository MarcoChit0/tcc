#include "./general.hpp"

#include "./task.hpp"
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
#include "./state_heuristics/star.hpp"
#include "./task_solvers/and_star.hpp"
#include "./samples_generator/random_walk.hpp"
#include "./samples_generator/breadth_first_search.hpp"
#include "./samples_generator/samples_generator.hpp"
#include "./samples_generator/union.hpp"

#define HEURISTIC std::pair<Policy::Heuristic*, State::Heuristic*>

int number_of_samples = 0;
int random_walk_length = 0;
int breadth_first_search_depth = 0;

void print_end(const str &termination, const opt<Policy> &opt_solution, const AndStar &and_star, const str &domain_file_name, const str &task_file_name)
{
    std::cout << std::endl;
    std::cout << "Termination: " << termination << std::endl;
    std::cout << "Final Memory Usage: " << get_memory_usage() << std::endl;
    std::cout << "Total Elapsed Time: " << get_ellapsed_time() << std::endl;
    std::cout << "Number of generated policies: " << and_star.number_of_generated_policies << std::endl;
    std::cout << "Number of inserted policies: " << and_star.number_of_inserted_policies << std::endl;
    std::cout << "Number of removed policies: " << and_star.number_of_removed_policies << std::endl;
    std::cout << "Number of expanded policies: " << and_star.number_of_expanded_policies << std::endl;

    if (opt_solution.has_value())
    {
        std::cout << std::endl;
        std::cout << "A Solution Policy:" << std::endl;
        std::cout << *opt_solution << std::endl;
        std::cout << "Size: " << opt_solution->size() << std::endl;
    }
}

void compare_multiple_policies(const Task& task, const vec<HEURISTIC>& heuristics, const str &domain_file_name, const str &task_file_name)
{
    for(const HEURISTIC& heuristic : heuristics)
    {
        AndStar and_star = AndStar(*heuristic.first, *heuristic.second);
        opt<Policy> opt_solution = and_star.get_solution(task);
        print_end("optimal", opt_solution, and_star, domain_file_name, task_file_name);
    }
}

vec<str> strtok(str s, char delim)
{
    vec<str> tokens;
    std::stringstream ss(s);
    str token;
    while (std::getline(ss, token, delim))
    {
        tokens.push_back(token);
    }
    return tokens;
}

vec<HEURISTIC> parse_policies_heuristics(const Task& task, vec<State::Heuristic*> state_heuristics, str heuristic_policies_string, SamplesGenerator* samples_generator)
{
    vec<HEURISTIC> heuristics;
    for(const str& heuristic_policy_string : strtok(heuristic_policies_string, ','))
    {
        for(State::Heuristic* state_heuristic : state_heuristics)
        {    
            if (heuristic_policy_string == "count")
            {
                heuristics.push_back(std::make_pair(new Count(task),state_heuristic));
            }
            else
            if (heuristic_policy_string == "nearest")
            {
                heuristics.push_back(std::make_pair(new Nearest(task, *state_heuristic), state_heuristic));
            }
            else
            if (heuristic_policy_string == "delta")
            {
                heuristics.push_back(std::make_pair(new Delta(task, *state_heuristic), state_heuristic));
            }
            else
            if (heuristic_policy_string == "delta-nearest")
            {
                heuristics.push_back(std::make_pair(new DeltaNearest(task, *state_heuristic), state_heuristic));
            }
            else
            if (heuristic_policy_string == "lookup")
            {
                heuristics.push_back(std::make_pair(new LookUp(task, *state_heuristic, samples_generator), state_heuristic));
            }
            else
            {
                throw std::domain_error("Invalid policy heuristic.");
            }
        }
    }
    return heuristics;
}

vec<State::Heuristic*> parse_states_heuristics(const Task& task, str heuristic_states_string)
{
    vec<State::Heuristic*> state_heuristics;
    for(const str& heuristic_state_string : strtok(heuristic_states_string, ','))
    {
        if (heuristic_state_string == "blind")
        {
            state_heuristics.push_back(new Blind(task));
        }
        else
        if (heuristic_state_string == "max")
        {
            state_heuristics.push_back(new Max(task));
        }
        else
        if (heuristic_state_string == "add")
        {
            state_heuristics.push_back(new Add(task));
        }
        else
        if (heuristic_state_string == "ff")
        {
            state_heuristics.push_back(new Ff(task));
        }
        else
        if (heuristic_state_string == "lmcut")
        {
            state_heuristics.push_back(new Lmcut(task));
        }
        else
        if (heuristic_state_string == "star")
        {
            state_heuristics.push_back(new Star(task));
        }
        else
        {
            throw std::domain_error("Invalid state heuristic.");
        }
    }
    return state_heuristics;
}

SamplesGenerator* parse_samples_generator(const Task& task, str sample_generator)
{
    if (sample_generator == "random-walk")
    {
        return new RandomWalk(task);
    }
    else
    if (sample_generator == "breadth-first-search")
    {
        return new BreadthFirstSearch(task);
    }
    else
    if (sample_generator == "union")
    {
        return new Union(task);
    }
    else
    {
        throw std::domain_error("Invalid sample generator.");
    }
}


int main(int argc, char** argv)
{
    assert(get_memory_limit() <= 8);
    // assert(get_time_limit() <= 1800);
    number_of_samples = std::atoi(argv[5]);
    random_walk_length = std::atoi(argv[6]);
    breadth_first_search_depth = std::atoi(argv[7]);
    Task task = Task(str(argv[1]), str(argv[2]));
    SamplesGenerator* samples_generator = parse_samples_generator(task, str(argv[8]));
    vec<State::Heuristic*> states_heuristics = parse_states_heuristics(task, str(argv[4]));
    vec<HEURISTIC> heuristics = parse_policies_heuristics(task, states_heuristics, str(argv[3]), samples_generator);
    compare_multiple_policies(task, heuristics, str(argv[1]), str(argv[2]));
    return 0;
}
