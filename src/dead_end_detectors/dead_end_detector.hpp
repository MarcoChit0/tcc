#pragma once

#include "../task.hpp"
#include <unordered_set>

#define DEAD_END_LOG_FILE "log.txt"
#define DEAD_END_DIR "dead-end/"
#define DEAD_END_LABEL_FILE "labeled_states.txt"


enum StateLabel
{
    ALIVE = INFTY,
    HARD_DEAD_END = -INFTY,
    EASY_DEAD_END = 0,
    WEAK_ALIVE = 1,
};

static std::map<int, str> state_label_to_string = {
    {HARD_DEAD_END, "hard dead end"},
    {EASY_DEAD_END, "easy dead end"},
    {WEAK_ALIVE, "weak alive"},
    {ALIVE, "alive"},
};

str print_state_label(const int state_label);

static std::map<str, int> string_to_state_label = {
    {"hard dead end", HARD_DEAD_END},
    {"easy dead end", EASY_DEAD_END},
    {"weak alive", WEAK_ALIVE},
    {"alive", ALIVE},
};

typedef std::pair<State, Action> StateActionPair;

struct hash_StateActionPair
{
    size_t operator()(const StateActionPair &state_action_pair) const
    {
        return std::hash<State>()(state_action_pair.first) ^ std::hash<Action>()(state_action_pair.second);
    }
};

typedef std::unordered_set<StateActionPair, hash_StateActionPair> StateActionPairSet;
typedef std::unordered_map<StateActionPair, bool, hash_StateActionPair> StateActionPairToBoolMap;
class DeadEndDetector
{
    protected:
        const Task &task;
        static map<int64_t, int> labeled_states;
        const str dead_end_directory = default_directory + DEAD_END_DIR;
        double first_dead_end_detected_time = -1;
        double first_hard_dead_end_detected_time = -1;
        void set_labeled_states(const map<int64_t, int> &labeled_states);
        
    public:
        static int64_t number_of_lookups;
        static int64_t number_of_useful_lookups;
        static int64_t number_of_hard_dead_end_lookups;
        static int64_t number_of_easy_dead_end_lookups;
        DeadEndDetector(const Task &task) : task(task) {
            if(not directory_created_successfully(DEAD_END_DIR))
            {
                throw std::runtime_error("LOG::DeadEndDetector::DeadEndDetector::directory not created");
            }
        };
        
        virtual double is_deadend(const State &state) const = 0;
        virtual void label_states(const bool save_metadata=true) = 0;
        str get_statistics() const;
        str get_statistics_header() const;
        virtual void save_labeled_states() const;
        virtual void load_labeled_states();
        map<int64_t, int> get_labeled_states() const;
        int get_state_label(const State &state) const;
};