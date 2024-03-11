(define (domain kitchen-domain)
  (:requirements :typing :fluents :conditional-effects)
  (:types
    ingredient dish client
  )
  
  (:predicates
    (is-cooking ?d - dish)
    (dish-ready ?d - dish)
    (ingredient-available ?i - ingredient)
    (contains ?d - dish ?i - ingredient)
    (satisfies-preferences ?d - dish ?c - client)
    (avoids-restrictions ?d - dish ?c - client)
  )

  (:functions
    (ingredient-quantity ?i - ingredient) ; Current quantity of an ingredient
    (dish-flavor ?d - dish) ; Accumulated flavor points of a dish
  )

  (:action start-cooking
    :parameters (?d - dish)
    :precondition (not (is-cooking ?d))
    :effect (and
              (is-cooking ?d)
              (not (dish-ready ?d))
            )
  )

  (:action add-ingredient
    :parameters (?i - ingredient ?d - dish ?amount - number ?flavor-points - number)
    :precondition (and
                    (is-cooking ?d)
                    (ingredient-available ?i)
                    (>= (ingredient-quantity ?i) ?amount)
                  )
    :effect (and
              (decrease (ingredient-quantity ?i) ?amount)
              (increase (dish-flavor ?d) ?flavor-points)
              (contains ?d ?i)
              (when (probabilistic 0.1)
                (decrease (dish-flavor ?d) ?flavor-points) ; Accidentally ruin the ingredient
              )
            )
  )

  (:action taste-dish
    :parameters (?d - dish ?adjustment - number)
    :precondition (is-cooking ?d)
    :effect (increase (dish-flavor ?d) ?adjustment)
  )

  (:action discard-dish
    :parameters (?d - dish)
    :precondition (is-cooking ?d)
    :effect (not (is-cooking ?d))
  )

  (:action finish-dish
    :parameters (?d - dish)
    :precondition (and (is-cooking ?d) (not (dish-ready ?d)))
    :effect (and
              (not (is-cooking ?d))
              (dish-ready ?d)
            )
  )
)
