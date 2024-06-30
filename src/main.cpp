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
#include "./policy_heuristics/lookup_heuristics/neural_network_lookup.hpp"
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
#include "./dead_end_detectors/dead_end_detector.hpp"
#include "./dead_end_detectors/complete_dead_end_detector.hpp"
#include "./dead_end_detectors/reachable_dead_end_detector.hpp"
#include "./dead_end_detectors/easy_reachable_dead_end_detector.hpp"
#include "./dead_end_detectors/neural_network_dead_end_detector.hpp"
#include "./dead_end_detectors/set_dead_end_detector.hpp"
#include "./neural_networks/dead_end_neural_network.hpp"
#include "./neural_networks/state_neural_network.hpp"


static Trie trie = Trie();
int concrete_states_generator = ConcreteStatesGenerator::ALL;

Policy::Heuristic *parse_policies_heuristics(const Task &task, State::Heuristic *state_heuristic, str policy_heuristic, SampleGenerator *samples_generator, Sample::Treatment *sample_treatment)
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
        return new LookUpOnDeltaNearest(task, *state_heuristic, *samples_generator, *sample_treatment);
    }
    else if (policy_heuristic == "max-lookup-delta-nearest")
    {
        return new MaxLookUpDeltaNearest(task, *state_heuristic, *samples_generator, *sample_treatment);
    }
    else if (policy_heuristic == "neural-network-lookup")
    {
        return new NeuralNetworkLookUp(task, *state_heuristic, *samples_generator, *sample_treatment);
    }
    else
    {
        throw std::domain_error("Invalid policy heuristic.");
    }
}

State::Heuristic *parse_states_heuristics(const Task &task, str state_heuristic_string, const opt<std::shared_ptr<DeadEndDetector>>& dead_end_detector)
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
        return new Star(task, dead_end_detector);
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

Task::Regressor *parse_regressor(str regressor_string)
{
    if (regressor_string == "equality")
    {
        return new Equality();
    }
    else if (regressor_string == "action-proportionality")
    {
        return new ActionProportionality();
    }
    else
    {
        throw std::domain_error("Invalid regressor.");
    }
}

void print_end(char **argv, const Task &task, Policy::Heuristic *policy_heuristic, std::unique_ptr<Task::Solver>& solver, opt<Policy> opt_solution,  std::optional<std::shared_ptr<DeadEndDetector>>& dead_end_detector, int number_of_states_generated_on_state_heuristic_table = -1)
{
    str header = "solver,domain,problem,policy_heuristic,state_heuristic,number_of_samples,length,percentage_fsm,sample_generator,sample_treatment_class,percentage_timer,percentage_time_limit,percentage_memory_limit,walker,concrete_states_generator,regressor,termination,memory_usage,time,number_of_generated_policies,number_of_inserted_policies,number_of_removed_policies,number_of_expanded_policies,solution_length,number_of_lookups,number_of_states_generated_on_state_heuristic_table";
    if(dead_end_detector.has_value())
    {
        header += "," + (*(dead_end_detector))->get_statistics_header();
    }
    std::cout << header << std::endl;
    std::cout << str(argv[18]);                                                                                // solver
    std::cout << "," << get_domain(str(argv[1]));                                                                            // domain
    std::cout << "," << get_problem(str(argv[2]));                                                                    // problem
    std::cout << "," << str(argv[3]);                                                                                 // policy_heuristic
    std::cout << "," << str(argv[4]);                                                                                 // state_heuristic
    std::cout << "," << std::atoi(argv[5]);                                                                           // number_of_samples
    std::cout << "," << parse_length_data(argv[6], task);                                                             // length
    std::cout << "," << std::atof(argv[7]);                                                                           // percentage_fsm
    std::cout << "," << str(argv[8]);                                                                                 // sample_generator
    std::cout << "," << str(argv[9]);                                                                                 // sample_treatment_class
    std::cout << "," << std::atof(argv[10]);                                                                          // percentage_timer
    std::cout << "," << std::atof(argv[11]);                                                                          // percentage_time_limit
    std::cout << "," << std::atof(argv[12]);                                                                          // percentage_memory_limit
    std::cout << "," << str(argv[13]);                                                                                // walker
    std::cout << "," << str(argv[14]);                                                                                // concrete_states_generator
    std::cout << "," << str(argv[15]);                                                                                // regressor
    std::cout << "," << policy_types_names[get_policy_type()];                                                        // termination
    std::cout << "," << get_memory_usage();                                                                           // memory_usage
    std::cout << "," << get_elapsed_time();                                                                          // time
    std::cout << "," << solver->number_of_generated_policies;                                                        // number_of_generated_policies
    std::cout << "," << solver->number_of_inserted_policies;                                                         // number_of_inserted_policies
    std::cout << "," << solver->number_of_removed_policies;                                                          // number_of_removed_policies
    std::cout << "," << solver->number_of_expanded_policies;                                                         // number_of_expanded_policies
    std::cout << "," << (opt_solution.has_value() ? opt_solution->size() : -1);                                       // solution_length
    std::cout << "," << (str(argv[3]) == "lookup") ? static_cast<LookUp *>(policy_heuristic)->number_of_lookups : -1; // number_of_lookups
    std::cout << "," << number_of_states_generated_on_state_heuristic_table;                                          // number_of_states_generated_on_state_heuristic_table
    if(dead_end_detector.has_value())
    {
        std::cout << "," << (*(dead_end_detector))->get_statistics();
    }
}

double percentage_timer = 0.1;
double percentage_memory_limit = 0.9;
double sample_generation_alarm = 0.7;
double policy_alarm;
double step;
double timer = INFTY; 
double time_limit = INFTY;
bool cache_enabled = true;

str default_directory;

void set_step_and_policy_alarm()
{
    assert(0 <= sample_generation_alarm and sample_generation_alarm <= 1);
    step = percentage_timer * sample_generation_alarm * (get_time_limit() - get_elapsed_time());
    policy_alarm = 1 - sample_generation_alarm;
}

enum DeadEndLabelsProgramFlow
{
    GENERATE_LABELS_AND_END_PROGRAM = 0,
    GENERATE_LABELS_AND_CONTINUE_PROGRAM = 1,
    LOAD_LABELS_AND_CONTINUE_PROGRAM = 2
};

void select_dead_end_detector(const Task &task, str dead_end_detector_str, int dead_end_labels_program_flow, std::optional<std::shared_ptr<DeadEndDetector>> &optional_dead_end_detector, const opt<int> &time_limit_to_generate_state_space = std::nullopt)
{
    if (dead_end_detector_str.find("neural-network") != std::string::npos)
    {
        // // TODO: transform this into a json object
        // dead_end_detector_str = neural-network(<dead-end-detector>)
        std::string dead_end_detector_substr = dead_end_detector_str.substr(dead_end_detector_str.find("[") + 1, dead_end_detector_str.find("]") - dead_end_detector_str.find("[") - 1);
       
        DeadEndNeuralNetwork neural_network = DeadEndNeuralNetwork(task); // TODO: CHANGE THIS TO RECEIVE THE NETWORK PARAMETERS OVER JSON FILE

        std::optional<std::shared_ptr<DeadEndDetector>> dead_end_detector;

        if(dead_end_labels_program_flow == GENERATE_LABELS_AND_CONTINUE_PROGRAM or dead_end_labels_program_flow == GENERATE_LABELS_AND_END_PROGRAM)
        {
            // generate dead end labels and continue program so that the neural network could be generated
            std::cerr << "LOG::main::select_dead_end_detector::generate dead end labels and continue program" << std::endl;
            std::cerr << "LOG::main::select_dead_end_detector::started at time " << get_elapsed_time() << std::endl;
            select_dead_end_detector(task, dead_end_detector_substr, GENERATE_LABELS_AND_CONTINUE_PROGRAM, dead_end_detector, time_limit_to_generate_state_space);
            std::cerr << "LOG::main::select_dead_end_detector::finished at time " << get_elapsed_time() << std::endl;
        }        
        else
        {
            // load dead end labels and continue program so that the neural network could be loaded
            std::cerr << "LOG::main::select_dead_end_detector::load dead end labels and continue program" << std::endl;
            std::cerr << "LOG::main::select_dead_end_detector::started at time " << get_elapsed_time() << std::endl;
            select_dead_end_detector(task, dead_end_detector_substr, LOAD_LABELS_AND_CONTINUE_PROGRAM, dead_end_detector, time_limit_to_generate_state_space);
            std::cerr << "LOG::main::select_dead_end_detector::finished at time " << get_elapsed_time() << std::endl;
        }
        if(not dead_end_detector.has_value())
        {
            throw std::domain_error("Dead end detector to be passed to neural network is null.");
        }
        optional_dead_end_detector = std::make_shared<NeuralNetworkDeadEndDetector>(task, dead_end_detector.value(), neural_network, std::nullopt);
    }
    else if (dead_end_detector_str == "complete")
    {
        optional_dead_end_detector = std::make_shared<CompleteDeadEndDetector>(task, time_limit_to_generate_state_space);
    }
    else if(dead_end_detector_str == "reachable")
    {
        optional_dead_end_detector = std::make_shared<ReachableDeadEndDetector>(task, time_limit_to_generate_state_space);
    }
    else if (dead_end_detector_str == "easy-reachable")
    {
        optional_dead_end_detector = std::make_shared<EasyReachableDeadEndDetector>(task, time_limit_to_generate_state_space);
    }
    else if (dead_end_detector_str == "none")
    {
        optional_dead_end_detector = std::nullopt;
    }
    else if (dead_end_detector_str == "set")
    {
        optional_dead_end_detector = std::make_shared<SetDeadEndDetector>(task, time_limit_to_generate_state_space);
    }
    else
    {
        throw std::domain_error("Invalid dead end detector.");
    }

    if(not optional_dead_end_detector.has_value())
    {
        return;
    }

    switch(dead_end_labels_program_flow)
    {
        case DeadEndLabelsProgramFlow::GENERATE_LABELS_AND_END_PROGRAM:
            (*(optional_dead_end_detector))->label_states();
            (*(optional_dead_end_detector))->save_labeled_states();
            exit(0);
            break;
        case DeadEndLabelsProgramFlow::GENERATE_LABELS_AND_CONTINUE_PROGRAM:
            (*(optional_dead_end_detector))->label_states();
            (*(optional_dead_end_detector))->save_labeled_states();
            break;
        case DeadEndLabelsProgramFlow::LOAD_LABELS_AND_CONTINUE_PROGRAM:
            (*(optional_dead_end_detector))->load_labeled_states();
            break;
        default:
            throw std::domain_error("Invalid dead end labels program flow.");
    }
}

std::unique_ptr<Task::Solver> parse_task_solver(const std::string& task_solver, const Policy::Heuristic& policy_heuristic, const State::Heuristic& state_heuristic, const opt<std::shared_ptr<DeadEndDetector>>& dead_end_detector)
{
    std::unique_ptr<AndStar::Comparator> comparator; // Use smart pointers for comparators

    if(task_solver == "and-star")
    {
        return std::make_unique<AndStar>(policy_heuristic, state_heuristic, AndStar::DEFAULT, dead_end_detector);
    }
    else if(task_solver == "weighted-and-star" or task_solver == "wandstar")
    {
        return std::make_unique<AndStar>(policy_heuristic, state_heuristic, AndStar::WEIGHTED, dead_end_detector);
    }
    else if(task_solver == "greedy-and-star" or task_solver == "gbfsnd")
    {
        return std::make_unique<AndStar>(policy_heuristic, state_heuristic, AndStar::GREEDY, dead_end_detector);
    }
    else if(task_solver == "dfsnd+backtracking" or task_solver == "depth-first-and-star-with-backtracking")
    {
        return std::make_unique<AndStar>(policy_heuristic, state_heuristic, AndStar::DEPTH_FIRST_BACKTRACKING, dead_end_detector);
    }
    else if(task_solver == "dfsnd" or task_solver == "depth-first-and-star")
    {
        return std::make_unique<AndStar>(policy_heuristic, state_heuristic, AndStar::DEPTH_FIRST_THEORETICAL, dead_end_detector);
    }
    else if(task_solver == "breadth-first-and-star" or task_solver == "bfsnd")
    {
        return std::make_unique<AndStar>(policy_heuristic, state_heuristic, AndStar::BREADTH_FIRST, dead_end_detector);
    }
    else
    {
        throw std::domain_error("Invalid task solver.");
    }
}


int main(int argc, char **argv)
{
    time_limit = std::atof(argv[20]); 
    timer = time_limit;
    cache_enabled = std::atoi(argv[21]);
    std::cerr << "LOG::main::time limit: " << time_limit << std::endl;
    std::cerr << "LOG::main::timer: " << timer << std::endl;
    std::cerr << "LOG::main::cache enabled: " << cache_enabled << std::endl;
    // assert(get_memory_limit() <= 8);
    // assert(get_time_limit() <= 1800);
    default_directory = argv[argc - 1]; 
    std::cerr << "LOG::main::start of [" << get_domain(str(argv[1])) << ":" << get_problem(str(argv[2])) << "]" << std::endl;
    Task::Regressor *regressor = parse_regressor(str(argv[15]));
    Task task = Task(str(argv[1]), str(argv[2]), *regressor);
    std::optional<std::shared_ptr<DeadEndDetector>> optional_dead_end_detector;
    std::optional<int> time_limit_to_generate_state_space = std::nullopt;
    if(str(argv[19]) != "none")
    {
        time_limit_to_generate_state_space = std::atoi(argv[19]);
    }
    select_dead_end_detector(task, str(argv[16]), std::atoi(argv[17]), optional_dead_end_detector, time_limit_to_generate_state_space);

    // commented for running only dead-end detector on server 
    int number_of_samples = std::atoi(argv[5]);
    int length = parse_length_data(argv[6], task);
    float porcentage = std::atof(argv[7]);
    percentage_timer = std::atof(argv[10]);
    sample_generation_alarm = std::atof(argv[11]);
    set_step_and_policy_alarm();
    percentage_memory_limit = std::atof(argv[12]);
    parse_concrete_states_generator(str(argv[14]));
    RandomWalk::Walker *walker = parse_random_walk_walker(str(argv[13]));
    State::Heuristic *state_heuristic = parse_states_heuristics(task, str(argv[4]), optional_dead_end_detector);
    SampleGenerator *samples_generator = parse_samples_generator(str(argv[8]), task, *state_heuristic, *walker, number_of_samples, length, porcentage);
    Sample::Treatment *sample_treatment = parse_sample_treatment(str(argv[9]));
    Policy::Heuristic *policy_heuristic = parse_policies_heuristics(task, state_heuristic, str(argv[3]), samples_generator, sample_treatment);

    auto solver = parse_task_solver(str(argv[18]), *policy_heuristic, *state_heuristic, optional_dead_end_detector);
    Policy opt_solution = solver->get_solution(task);
    
    // std::cout << opt_solution << std::endl;
    print_end(argv, task, policy_heuristic, solver, opt_solution, optional_dead_end_detector, state_heuristic->size());
    std::cerr << "LOG::main::end of [" << get_domain(str(argv[1])) << ":" << get_problem(str(argv[2])) << "]" << std::endl;
    return 0;
}
