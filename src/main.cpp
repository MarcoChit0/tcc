#include "./general.hpp"

#include "./task.hpp"
#include "./policy_heuristics/count.hpp"
#include "./policy_heuristics/nearest.hpp"
#include "./policy_heuristics/delta.hpp"
#include "./policy_heuristics/delta_nearest.hpp"
#include "./state_heuristics/blind.hpp"
#include "./state_heuristics/delete_relaxation_heuristics/max.hpp"
#include "./state_heuristics/delete_relaxation_heuristics/add.hpp"
#include "./state_heuristics/delete_relaxation_heuristics/ff.hpp"
#include "./state_heuristics/delete_relaxation_heuristics/lmcut.hpp"
#include "./state_heuristics/star.hpp"
#include "./task_solvers/and_star.hpp"

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

int main(int argc, char** argv)
{
    assert(argc == 5);
    assert(get_memory_limit() <= 8);
    // assert(get_time_limit() <= 1800);

    Task task = Task(str(argv[1]), str(argv[2]));

    State::Heuristic* state_heuristic_ptr;
    if (str(argv[4]) == "blind")
    {
        state_heuristic_ptr = new Blind(task);
    }
    else
    if (str(argv[4]) == "max")
    {
        state_heuristic_ptr = new Max(task);
    }
    else
    if (str(argv[4]) == "add")
    {
        state_heuristic_ptr = new Add(task);
    }
    else
    if (str(argv[4]) == "ff")
    {
        state_heuristic_ptr = new Ff(task);
    }
    else
    if (str(argv[4]) == "lmcut")
    {
        state_heuristic_ptr = new Lmcut(task);
    }
    else
    if (str(argv[4]) == "star")
    {
        state_heuristic_ptr = new Star(task);
    }
    else
    {
        throw std::domain_error("Invalid state heuristic.");
    }

    Policy::Heuristic* policy_heuristic_ptr;
    if (str(argv[3]) == "count")
    {
        policy_heuristic_ptr = new Count(task);
    }
    else
    if (str(argv[3]) == "nearest")
    {
        policy_heuristic_ptr = new Nearest(task, *state_heuristic_ptr);
    }
    else
    if (str(argv[3]) == "delta")
    {
        policy_heuristic_ptr = new Delta(task, *state_heuristic_ptr);
    }
    else
    if (str(argv[3]) == "delta-nearest")
    {
        policy_heuristic_ptr = new DeltaNearest(task, *state_heuristic_ptr);
    }
    else
    {
        throw std::domain_error("Invalid policy heuristic.");
    }

    AndStar and_star = AndStar(*policy_heuristic_ptr, *state_heuristic_ptr);
    Policy solution = and_star.get_solution(task);

    print_end("Solved.", {solution}, and_star, str(argv[1]), str(argv[2]));
    return 0;
}
