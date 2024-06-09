#include "breadth_first_search.hpp"

BreadthFirstSearch::BreadthFirstSearch(const Task &task, const State::Heuristic &state_heuristic, const int number_of_samples) : SampleGenerator(task, state_heuristic, number_of_samples) {}

set<Sample> BreadthFirstSearch::generate_samples() const
{
    if (not(this->state_heuristic[this->task.initial_state()] == +INFTY))
    {
        return this->bfs().samples;
    }
    else
    {
        return set<Sample>{};
    }
}

BreadthFirstSearch::BFSReturn BreadthFirstSearch::bfs() const
{
    BreadthFirstSearch::BFSReturn bfs_return = BreadthFirstSearch::BFSReturn(set<PartialState>{}, set<State>{}, set<Sample>{});
    set<PartialState> visited = set<PartialState>{};
    std::queue<PartialState> queue;
    queue.push(this->task.goal_condition());
    int generated_samples = 0;
    while (not queue.empty())
    {
        PartialState partial_state = queue.front();
        queue.pop();
        if (visited.contains(partial_state))
        {
            continue;
        }
        visited.insert(partial_state);
        bfs_return.explored(partial_state);
        vec<vec<PartialState>> vec_regressed_partial_states = this->task.get_regressed_partial_states(partial_state);
        std::shuffle(vec_regressed_partial_states.begin(), vec_regressed_partial_states.end(), rng);
        for (vec<PartialState> regressed_partial_states : vec_regressed_partial_states)
        {
            if (regressed_partial_states.size() > 1)
            {
                std::shuffle(regressed_partial_states.begin(), regressed_partial_states.end(), rng);
            }
            for (PartialState regressed_partial_state : regressed_partial_states)
            {
                if (not visited.contains(regressed_partial_state))
                {
                    set<State> concrete_states = this->state_heuristic.get_concrete_states(regressed_partial_state);
                    // TODO: remove this print after debugging
                    std::cerr << "##############################################" << std::endl;
                    std::cerr << "LOG::BreadthFirstSearch::select_state::partial_state::" << regressed_partial_state << std::endl;
                    int count = 0;
                    for (State s : concrete_states)
                    {
                        std::cerr << "LOG::BreadthFirstSearch::select_state::concrete_state::"<< count++ << "\t--\t" << s << std::endl;
                    }
                    std::cerr << "##############################################" << std::endl;
                    for (State concrete_state : concrete_states)
                    {
                        if (bfs_return.sampled.contains(concrete_state))
                        {
                            continue;
                        }
                        queue.push(regressed_partial_state);
                        Sample sample = this->get_sample(concrete_state);
                        if (not sample.is_none())
                        {
                            bfs_return.update(regressed_partial_state, concrete_state, sample);
                        }
                        if (bfs_return.samples.size() >= this->number_of_samples or not enough_memory() or not enough_time(ALARM_TYPE_SAMPLE_GENERATION))
                        {
                            std::cout << ((bfs_return.samples.size() >= this->number_of_samples) ? 1 : 0) << std::endl;
                            std::cout << not enough_memory() << std::endl;
                            std::cout << not enough_time(ALARM_TYPE_SAMPLE_GENERATION) << std::endl;
                            std::cout << "LOG::BFS::EXIT 0" << std::endl;
                            return bfs_return;
                        }
                        else
                        {
                            break;
                        }
                    }
                }
            }
        }
    }
    std::cout << "LOG::BFS::EXIT 1" << std::endl;
    return bfs_return;
}