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

#define HEURISTIC std::pair<Policy::Heuristic *, State::Heuristic *>

int number_of_samples = 0;
int random_walk_length = 0;
int breadth_first_search_depth = 0;

void print_end(const str& domain, const str& problem, const str &termination, const opt<Policy> &opt_solution, const AndStar &and_star, str policy_heuristic_string, str state_heuristic_string, Policy::Heuristic* policy_heuristic)
{
    std::cout << "domain,problem,termination,memory,time,generated,inserted,removed,expanded,solution_size,policy_heuristic,state_heuristic,number_of_samples,random_walk_length,breadth_first_search_depth,number_of_lookups" << std::endl;
    std::cout << domain;
    std::cout << "," << problem; 
    std::cout << "," << termination;
    std::cout << "," << get_memory_usage();
    std::cout << "," << get_ellapsed_time();
    std::cout << "," << and_star.number_of_generated_policies;
    std::cout << "," << and_star.number_of_inserted_policies;
    std::cout << "," << and_star.number_of_removed_policies;
    std::cout << "," << and_star.number_of_expanded_policies;
    std::cout << "," << opt_solution.has_value() ? opt_solution->size() : -1;
    std::cout << "," << policy_heuristic_string;
    std::cout << "," << state_heuristic_string;
    std::cout << "," << number_of_samples;
    std::cout << "," << random_walk_length;
    std::cout << "," << breadth_first_search_depth;
    std::cout << "," << (policy_heuristic_string == "lookup") ? static_cast<LookUp *>(policy_heuristic)->number_of_lookups : -1;
    std::cout << std::endl;
}

Policy::Heuristic *parse_policies_heuristics(const Task &task, const State::Heuristic *state_heuristic, str policy_heuristic, SamplesGenerator *samples_generator)
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
        return new LookUp(task, *state_heuristic, samples_generator);
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
    else
    {
        throw std::domain_error("Invalid state heuristic.");
    }
}

SamplesGenerator *parse_samples_generator(const Task &task, str sample_generator)
{
    if (sample_generator == "random-walk")
    {
        return new RandomWalk(task);
    }
    else if (sample_generator == "breadth-first-search")
    {
        return new BreadthFirstSearch(task);
    }
    else if (sample_generator == "union")
    {
        return new Union(task);
    }
    else
    {
        throw std::domain_error("Invalid sample generator.");
    }
}

int main(int argc, char **argv)
{
    assert(get_memory_limit() <= 8);
    // assert(get_time_limit() <= 1800);
    number_of_samples = std::atoi(argv[5]);
    random_walk_length = std::atoi(argv[6]);
    breadth_first_search_depth = std::atoi(argv[7]);
    Task task = Task(str(argv[1]), str(argv[2]));
    SamplesGenerator *samples_generator = parse_samples_generator(task, str(argv[8]));
    State::Heuristic* state_heuristic = parse_states_heuristics(task, str(argv[4]));
    Policy::Heuristic* policy_heuristic = parse_policies_heuristics(task, state_heuristic, str(argv[3]), samples_generator);
    // run
    AndStar and_star = AndStar(*policy_heuristic, *state_heuristic);
    opt<Policy> opt_solution = and_star.get_solution(task);
    print_end(str(argv[1]), str(argv[2]), "optimal", opt_solution, and_star, str(argv[3]), str(argv[4]), policy_heuristic);
    return 0;
}
