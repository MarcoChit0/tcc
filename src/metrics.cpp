#include "metrics.hpp"

void find_reachable_states_that_do_not_lead_to_dead_end_states(
    const Task &task,
    const State::Heuristic &state_heuristic,
    std::optional<std::shared_ptr<DeadEndDetector>>& dead_end_detector){
        set<State> reachable_states;
        int alive = 0, non_deterministic =0;
        if(dead_end_detector.has_value())
        {
            std::queue<State> q;
            q.push(task.initial_state());
            set<State> inserted;
            while(not q.empty()){
                State state = q.front();
                q.pop();
                if(state.is_goal(task.goal_condition()))
                    continue;
                for(auto action : state.get_applicable_actions(task.actions()))
                {
                    set<State> successors = {};
                    for(auto action_effect : action.effects())
                    {
                        State successor = state.get_successor(action_effect);
                        
                        if((*dead_end_detector)->get_state_label(successor) == EASY_DEAD_END)
                        {
                            successors.clear();
                            break;
                        }
                        successors.insert(successor);
                        
                    }
                    if(not successors.empty())
                    {   
                        if(not reachable_states.contains(state))
                        {
                            reachable_states.insert(state);
                            if((*dead_end_detector)->get_state_label(state) == ALIVE)
                                alive++;
                            else if((*dead_end_detector)->get_state_label(state) == HARD_DEAD_END)
                                non_deterministic++;
                        }
                        for(auto successor : successors)
                            if(inserted.find(successor) == inserted.end())
                            {
                                inserted.insert(successor);
                                q.push(successor);
                            }
                    }
                }
            }
        }
        else
        {
            std::cerr << "LOG::metrics::find_reachable_states_that_do_not_lead_to_dead_end_states::No Dead End Detector Found\n";
        }
        std::ofstream file;
        file.open(default_directory + "reachable_states.txt");
        file << "Reachable States: " << reachable_states.size() << std::endl;
        file << "Alive States: " << alive << std::endl;
        file << "Non-Deterministic States: " << non_deterministic << std::endl;
        file.close();

}