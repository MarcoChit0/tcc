#include "./random_walk.hpp"

RandomWalk::RandomWalk() {}

vec<std::pair<State, int>> RandomWalk::generate_samples(const Task &task, const int number_of_samples, const int length)
{
    std::cout<<"LOG::RandomWalk::generate_samples()::begin\n";
    int generated_samples = 0;
    vec<std::pair<State, int>> samples;
    std::random_device rd;
    std::mt19937 gen(rd());

    //  1. Construir PDB determinístico caso seja possível para a tarefa. Se não for, pular tarefa.
    Star h_star = Star(task);
    if (h_star[task.initial_state()] == +INFTY)
        return samples;
    
    while (++generated_samples <= number_of_samples)
    {
        bool match = false;
        PartialState partial_state = task.goal_condition();
        State state;
        while (not match)
        {
            //  2. Partindo do GOAL, random walk para trás de comprimento arbitrário.
            bool completed_regression = true;
            for (int i = 0; i < length; i++)
            {
                vec<PartialState> regressed_states = partial_state.get_regressed_partial_states(task.actions());
                for(auto regressed_state : regressed_states)
                {
                    std::cout << "LOG::RandomWalk::generate_samples()::partial stated: " << regressed_state << std::endl;
                }
                if (not regressed_states.empty())
                {
                    std::uniform_int_distribution<int> distribution(0, regressed_states.size() - 1);          
                    int random_index = distribution(gen);
                    partial_state = regressed_states[random_index];
                }
                else
                {
                    completed_regression = false;
                    break;
                }
            }
            //  3. Confere se o estado arbitrário encontrado dá match com algum dos estados do pdb.
            //      Se não der match, retornar para (2). 
            //      Se der match, continuar com o estado S.
            vec<State> concrete_states = h_star.get_concrete_states_from_pdb(partial_state);
            for(auto concrete_state : concrete_states)
            {
                std::cout << "LOG::RandomWalk::generate_samples()::state: " << concrete_state << std::endl;
            }
            if (not concrete_states.empty() and completed_regression)
            {
                std::uniform_int_distribution<int> distribution(0, concrete_states.size() - 1);          
                int random_index = distribution(gen);
                state = concrete_states[random_index];
                match = true;
                std::cout << "LOG::RandomWalk::generate_samples()::state selected: " << state << std::endl;
                break;
            }
            else
            {
                match = false;
                std::cout << "LOG::RandomWalk::generate_samples()::no state selected" << std::endl;
            }

        }
        // 4. Obter valor h*ND(S) através de AND*(S).
        Task random_walk_task = task;
        random_walk_task.initial_state().id = state.id;
        DeltaNearest policy_heuristic = DeltaNearest(random_walk_task, h_star);
        std::cout << "LOG::RandomWalk::generate_samples()::starting and-star execution" << std::endl;
        Policy optimal_policy = AndStar(policy_heuristic, h_star).get_solution(random_walk_task);   
        std::cout << "LOG::RandomWalk::generate_samples()::ending and-star execution" << std::endl;
        samples.push_back(std::make_pair(state, optimal_policy.size()));
        std::cout << "LOG::RandomWalk::generate_samples()::sample generated: (state: [" << state << "], value: [" << optimal_policy.size() << "])" << std::endl;
        std::cout << "LOG::RandomWalk::generate_samples()::h*value = " << h_star[state] << std::endl;
    }
    std::cout<<"LOG::RandomWalk::generate_samples()::end\n";
    // 5. Repetir (2-4) até condição de parada (ex.: número de instâncias geradas ou tempo esgotado).
    // 6. Comparar resultados H*ND(S) com os valores do PDB determinístico.
    return samples;
}