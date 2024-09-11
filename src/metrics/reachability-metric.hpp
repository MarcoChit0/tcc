// #pragma once

// #include "../task.hpp"
// #include "../dead_end_detectors/dead_end_detector.hpp"

// class ReachabilityMetric : public Metric {
//     private:
//         const std::optional<std::shared_ptr<DeadEndDetector>> dead_end_detector;
//     public:
//         void compute() const override;
//         ReachabilityMetric(const Task &task, const std::optional<std::shared_ptr<DeadEndDetector>> dead_end_detector) : Metric(task), dead_end_detector(dead_end_detector) {}
// };