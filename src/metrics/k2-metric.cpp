#include "./k2-metric.hpp"

void K2Metric::compute() const
{
    int iteration = 0;
    std::shared_ptr<SetDeadEndDetector> dead_end_detector = std::make_shared<SetDeadEndDetector>(task);
    bool found_all_dead_ends = false;
    map<int64_t, vec<int>> heuristic;
    if (not meta_gpm(Star(task)))
    {
        do
        {
            std::cerr << "LOG::metrics::k2_metric::compute::start running set dead end detector at " << get_elapsed_time() << std::endl;
            found_all_dead_ends = dead_end_detector->iterative_states_labeling(iteration);
            std::cerr << "LOG::metrics::k2_metric::compute::finish running set dead end detector at " << get_elapsed_time() << std::endl;

            std::cerr << "LOG::metrics::k2_metric::compute::iteration::" << iteration << std::endl;

            std::cerr << "LOG::metrics::k2_metric::compute::start building star heuristic at " << get_elapsed_time() << std::endl;
            Star h_star = Star(task, dead_end_detector);
            std::cerr << "LOG::metrics::k2_metric::compute::finish building star heuristic at " << get_elapsed_time() << std::endl;

            State s;
            std::cerr << "LOG::metrics::k2_metric::compute::start building heuristic at " << get_elapsed_time() << std::endl;
            for (auto p : dead_end_detector->get_labeled_states())
            {
                if (iteration == 1)
                    heuristic[p.first] = {};
                s.id = p.first;
                heuristic[p.first].push_back(h_star[s]);
            }

            std::cerr << "LOG::metrics::k2_metric::compute::starting running meta gpm at " << get_elapsed_time() << std::endl;
            if (meta_gpm(h_star))
            {
                std::cerr << "LOG::metrics::k2_metric::compute::last iteration of meta gpm at " << get_elapsed_time() << std::endl;
                break;
            }
            std::cerr << "LOG::metrics::k2_metric::compute::finish running meta gpm at " << get_elapsed_time() << std::endl;
            h_star.clear_pdb();
        } while (not found_all_dead_ends);
    }
    std::cerr << "LOG::metrics::k2_metric::compute::k2 metric is " << iteration << std::endl;
    std::ofstream out(default_directory + "k2_metric.txt");
    if (out.is_open())
    {
        out << iteration << std::endl;
        out.close();
    }
    else
    {
        std::cerr << "LOG::metrics::k2_metric::compute::Could not open output file\n";
    }
}

bool K2Metric::meta_gpm(const Star &h) const
{
    auto is_good_action = [&](const State &state, const Action &action)
    {
        for (const State &successor_state : state.get_successors(action))
        {
            // for meta_gpm the dead end checking is h[state] == INFTY and not is_deadend()
            if (h[successor_state] == INFTY)
            {
                return false;
            }
        }
        return true;
    };
    auto makes_deterministic_progress = [&](const State &state, const Action &action)
    {
        for (const State &successor_state : state.get_successors(action))
        {
            if (h[state] == h[successor_state] + 1)
            {
                return true;
            }
        }
        return false;
    };

    if (h[task.initial_state()] == INFTY)
    {
        return false;
    }
    if (h[task.initial_state()] == 0)
    {
        return true;
    }

    std::stack<State> stack;
    stack.push(task.initial_state());

    std::unordered_set<State> visited = {task.initial_state()};

    while (not stack.empty())
    {
        State state = stack.top();
        stack.pop();
        if (h[state] == 0)
        {
            continue;
        }

        bool good_action = false;
        for (auto action : state.get_applicable_actions(task.actions()))
        {
            if (is_good_action(state, action) and makes_deterministic_progress(state, action))
            {
                good_action = true;
                for (auto succ : state.get_successors(action))
                {
                    if (not visited.contains(succ))
                    {
                        stack.push(succ);
                        visited.insert(state);
                    }
                }
            }
        }
        if (not good_action)
        {
            return false;
        }
    }
    return true;
}
