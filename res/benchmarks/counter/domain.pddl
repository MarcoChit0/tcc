(define (domain simple_numeric)
  (:requirements :typing)
  
  ;; No specific types needed for this simple example.
  ;; No predicates needed for numeric operations.

  ;; Define a numeric function.
  (:functions (counter))

  ;; Define an action to increase the counter by 1.
  (:action increase_by_one
    :parameters ()
    :precondition (true) ;; No specific precondition needed.
    :effect (increase (counter) 1)
  )
)
