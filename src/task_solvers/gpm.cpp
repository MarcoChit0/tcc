#include "gpm.hpp"

GPM::GPM(const State::Heuristic &state_heuristic, const opt<std::shared_ptr<DeadEndDetector>> &dead_end_detector) : state_heuristic(state_heuristic), dead_end_detector(dead_end_detector)
{
}

Policy GPM::get_solution(const Task &task)
{
    if (not this->state_heuristic[task.initial_state()] == INFTY)
    {
        std::cerr << "LOG::GPM::get_solution::state heuristic for initial state is infty::" << task.initial_state() << "\n";
        set_policy_type(UNSOLVABLE_POLICY);
        return Policy();
    }
    
    Policy policy = Policy();
    std::priority_queue<State, vec<State>, CompareStateState> heap(CompareStateState(this->state_heuristic));
    heap.push(task.initial_state());
    set<State> visited;

    while (not heap.empty())
    {
        State state = heap.top();
        heap.pop();
        
        if(state.is_goal(task.goal_condition()))
        {
            continue;
        }
        
        bool action_found = false;
        Action action;
        for (const Action &act : state.get_applicable_actions(task.actions()))
        {
            for (const State &succ : state.get_successors(act))
            {
                if (this->state_heuristic[succ] == this->state_heuristic[state] - 1)
                {
                    action_found = true;
                    break;
                }
            }
            if (action_found)
            {
                action = act;
                break;
            }
        }

        if (action_found)
        {
            policy = Policy(state, action, policy);

            for (const State &succ : state.get_successors(action))
            {
                if (visited.find(succ) == visited.end())
                {
                    visited.insert(succ);
                    heap.push(succ);
                }
            }
        }
        else
        {
            set_policy_type(UNSOLVABLE_POLICY);
            return Policy();
        }
    }

    set_policy_type(OPTIMAL_POLICY);
    return policy;
}