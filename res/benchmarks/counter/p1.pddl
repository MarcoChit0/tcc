(define (problem simple_numeric_problem)
  (:domain simple_numeric)

  ;; Define the initial state.
  (:init
    (= (counter) 0)  ;; Starting value of the counter is 0.
  )

  ;; Define the goal state.
  (:goal
    (= (counter) 7)  ;; Goal is for the counter to reach 7.
  )
)
