#include "./and_star.hpp"
AndStar::AndStar(const Policy::Heuristic &policy_heuristic, const State::Heuristic &state_heuristic, const int &comparator, const opt<std::shared_ptr<DeadEndDetector>> &dead_end_detector) : policy_heuristic(policy_heuristic),
                                                                                                                                                                                              state_heuristic(state_heuristic),
                                                                                                                                                                                              dead_end_detector(dead_end_detector)
{
    switch (comparator)
    {
    case GREEDY:
    {
        this->is_policy_worse_than = [this](const Policy &policy_1, const Policy &policy_2)
        {
            // greedy: ONLY WORKS WHEN USING DEAD END DETECTOR
            // min h = f -g
            // tiebreak: max g
            int h1 = this->policy_heuristic[policy_1] - policy_1.size();
            int h2 = this->policy_heuristic[policy_2] - policy_2.size();
            // if h1 < h2, then policy_1 is better
            // is policy policy_1 worse than policy_2? if policy_1 has a greater h value, then it is worse
            if (h1 != h2)
            {
                return h1 > h2;
            }
            else
            {
                // if g1 > g2, then policy_1 is better
                // is policy policy_1 worse than policy_2? if policy_1 has a lower g value, then it is worse
                return policy_1.size() < policy_2.size();
            }
        };
    }; break;
    case WEIGHTED:
    {
        this->is_policy_worse_than = [this](const Policy &policy_1, const Policy &policy_2)
        {
            int f1 = policy_1.size() + 2 * (this->policy_heuristic[policy_1] - policy_1.size());
            int f2 = policy_2.size() + 2 * (this->policy_heuristic[policy_2] - policy_2.size());
            if (f1 != f2)
            {
                // if f1 < f2, then policy_1 is better
                // is pociy policy_1 worse than policy_2? if policy_1 has a higher f value, then it is worse
                return f1 > f2;
            }
            else
            {
                // if g1 > g2, then policy_1 is better
                // is policy policy_1 worse than policy_2? if policy_1 has a lower g value, then it is worse
                return policy_1.size() < policy_2.size();
            }
        };
    }; break;
    case DEPTH_FIRST:
    {
        this->is_policy_worse_than = [this](const Policy &policy_1, const Policy &policy_2)
        {
            // depth first search
            // last in, first out
            if (policy_1.is_none() || policy_2.is_none())
            {
                return true;
            }

            if (policy_1.parent_policy().id != policy_2.parent_policy().id)
            {
                return policy_1.parent_policy().id < policy_2.parent_policy().id;
            }

            int min_1 = INFTY;
            int min_2 = INFTY;
            for (const State &succ_state: policy_1.state().get_successors(policy_1.action()))
            {
                min_1 = std::min(min_1, this->state_heuristic[succ_state]);
            }
            for (const State &succ_state: policy_2.state().get_successors(policy_2.action()))
            {
                min_2 = std::min(min_2, this->state_heuristic[succ_state]);
            }

            return min_1 > min_2;
        };
    }; break;
    case BREADTH_FIRST:
    {
        this->is_policy_worse_than = [this](const Policy &policy_1, const Policy &policy_2)
        {
            // breadth first search
            // first in, first out
            return policy_1.id > policy_2.id;
        };
    }; break;
    case DEFAULT:
    {
        this->is_policy_worse_than = [this](const Policy &policy_1, const Policy &policy_2)
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
    }; break;
    }
    this->queue = boost::heap::pairing_heap<Policy, boost::heap::stable<true>, boost::heap::compare<std::function<bool(const Policy &, const Policy &)>>>(this->is_policy_worse_than);
}


// TODO: receive task solver as parameter
// SELECT WHICH SOLVER TO USE
Policy AndStar::get_solution(const Task &task)
{
    double last_recurrent_procedure_time = EMPTY_OBJECT;
    auto recurrent_procedure = [*this]()
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
        if (get_elapsed_time() - last_recurrent_procedure_time >= 1)
        {
            recurrent_procedure();
            last_recurrent_procedure_time = get_elapsed_time();
        }

        Policy policy = queue.top();
        queue.pop();
        number_of_removed_policies++;

        // std::cout << number_of_removed_policies << " " << this->policy_heuristic[policy] << " " << policy.size() << " " << policy.id << std::endl;

        if (policy.outgoing_non_goal_states(task.goal_condition()).empty())
        {
            set_policy_type(OPTIMAL_POLICY);
            return policy;
        }

        if (timer_expired())
        {
            set_policy_type(SUBOPTIMAL_POLICY);
            return policy;
        }

        State state;
        if (policy.is_none())
        {
            state = task.initial_state();
        }
        Policy cursor_policy = policy;
        while (state.is_none())
        {
            for (const State &successor_state : cursor_policy.state().get_successors(cursor_policy.action()))
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
        for (const Action &action : state.get_applicable_actions(task.actions()))
        {

            Policy successor_policy = Policy(state, action, policy);
            number_of_generated_policies++;

            bool has_infinite_f_value = false;
            for (const State &successor_state : state.get_successors(action))
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
                for (const State &other_state_successor : other_state.get_successors(successor_policy[other_state]))
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