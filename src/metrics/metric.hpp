#pragma once
#include "../task.hpp"

class Metric {
    protected:
        const Task &task;
    public:
        Metric(const Task &task) : task(task) {}
        virtual void compute() const = 0;
        virtual ~Metric() = default;
};