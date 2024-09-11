#pragma once

#include "../state.hpp"
#include "../dead_end_detectors/dead_end_detector.hpp"
class Star : public State::Heuristic
{
protected:
    const opt<std::shared_ptr<DeadEndDetector>> &dead_end_detector;
public:

    Star(const Task &task, const opt<std::shared_ptr<DeadEndDetector>>&dead_end_detector = std::nullopt);

    int operator[](const State &state) const;

    set<State> get_concrete_states(const PartialState &partial_state) const override;

    int size() const;

    void clear_pdb()
    {
        functions_storage[Function{&Star::operator[], *this}].clear();
    }
};