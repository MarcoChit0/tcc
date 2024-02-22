#include "./and_star.hpp"

AndStar::AndStar(const Policy::Heuristic &policy_heuristic, const State::Heuristic &state_heuristic, const opt<std::shared_ptr<DeadEndDetector>>&dead_end_detector) : 
    policy_heuristic(policy_heuristic), 
    state_heuristic(state_heuristic), 
    dead_end_detector(dead_end_detector) {}


Policy AndStar::get_solution(const Task &task)
{
    std::function<bool(const Policy &, const Policy &)> is_policy_worse_than = [*this](const Policy policy_1, const Policy policy_2)
    {
        if (this->policy_heuristic[policy_1] != this->policy_heuristic[policy_2])
        {
            return this->policy_heuristic[policy_1] > this->policy_heuristic[policy_2];
        }
        else
        {
            return policy_1.size() < policy_2.size();
        }
    };

    boost::heap::pairing_heap<Policy, boost::heap::stable<true>, boost::heap::compare<std::function<bool(const Policy &, const Policy &)>>> queue {is_policy_worse_than};

    double last_recurrent_procedure_time = EMPTY_OBJECT;
    auto recurrent_procedure = [*this, &queue]()
    {
        // std::cout << "Current f: " << policy_heuristic[queue.top()] << std::endl;
        double memory_limit = get_memory_limit();
        double memory_usage = get_memory_usage();
        if (memory_usage > 0.95 * memory_limit)
        {
            throw std::runtime_error("Out of memory: AND* exceeded 95% memory limit.");
        }
    };

    Policy initial_policy = Policy();
    number_of_generated_policies++;

    if (task.initial_state().is_goal(task.goal_condition()))
    {
        functions_cache[Function{&Policy::outgoing_non_goal_states, initial_policy}][task.goal_condition()] = {};
        functions_cache[Function{&Policy::does_reach_the_goal, initial_policy}][task.goal_condition()] = true;
    }
    else
    {
        functions_cache[Function{&Policy::outgoing_non_goal_states, initial_policy}][task.goal_condition()] = {task.initial_state()};
        functions_cache[Function{&Policy::does_reach_the_goal, initial_policy}][task.goal_condition()] = false;
    }

    if (policy_heuristic[initial_policy] != INFTY)
    {
        queue.push(initial_policy);
        number_of_inserted_policies++;
    }

    while (not queue.empty())
    {
        if (get_ellapsed_time() - last_recurrent_procedure_time >= 1)
        {
            recurrent_procedure();
            last_recurrent_procedure_time = get_ellapsed_time();
        }

        Policy policy = queue.top();
        queue.pop();
        number_of_removed_policies++;

        if (policy.outgoing_non_goal_states(task.goal_condition()).empty())
        {
            set_policy_type(OPTIMAL_POLICY);
            return policy;
        }

        if(timer_expired())
        {
            set_policy_type(SUBOPTIMAL_POLICY);
            return policy;
        }

        State state;
        if (policy.is_none()) {state = task.initial_state();}
        Policy cursor_policy = policy;
        while (state.is_none())
        {
            for (const State &successor_state: cursor_policy.state().get_successors(cursor_policy.action()))
            {
                if (state.is_none() and not policy.contains(successor_state) and not successor_state.is_goal(task.goal_condition()))
                {
                    state = successor_state;
                    break;
                }
            }
            cursor_policy = cursor_policy.parent_policy();
        }

        number_of_expanded_policies++;
        for (const Action &action: state.get_applicable_actions(task.actions()))
        {

            Policy successor_policy = Policy(state, action, policy);
            number_of_generated_policies++;

            bool has_infinite_f_value = false;
            for (const State &successor_state: state.get_successors(action))
            {
                if ((this->dead_end_detector.has_value() && (*(this->dead_end_detector))->is_deadend(successor_state) == 1.0f) || state_heuristic[successor_state] == INFTY)
                {
                    has_infinite_f_value = true;
                    break;
                }
            }
            if (has_infinite_f_value)
            {
                continue;
            }

            bool has_escape_route = false;
            vec<State> stack;
            set<State> already_added_states;
            stack.push_back(state);
            already_added_states.insert(state);
            while (not stack.empty() and not has_escape_route)
            {
                State other_state = stack.back();
                stack.pop_back();
                for (const State &other_state_successor: other_state.get_successors(successor_policy[other_state]))
                {
                    if (not already_added_states.contains(other_state_successor))
                    {
                        if (not successor_policy.contains(other_state_successor))
                        {
                            has_escape_route = true;
                            break;
                        }
                        stack.push_back(other_state_successor);
                        already_added_states.insert(other_state_successor);
                    }
                }
            }
            if (not has_escape_route)
            {
                continue;
            }

            queue.push(successor_policy);
            number_of_inserted_policies++;
        }
    }

    set_policy_type(UNSOLVABLE_POLICY);
    return Policy();
}