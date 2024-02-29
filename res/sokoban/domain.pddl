(define (domain sokoban-sequential)
  (:requirements :typing :action-costs)
  (:types thing location direction - object
          player stone - thing)
  (:predicates 
        (clear ?l - location)
	    (at ?t - thing ?l - location)
	    (at-goal ?s - stone)
	    (is-goal ?l - location)
	    (is-nongoal ?l - location)
        (move-dir ?from ?to - location ?dir - direction)
        (is-wall-on ?l - location ?dir - direction)
    )
  (:functions (total-cost) - number)

  (:action move
   :parameters (?p - player ?from ?to - location ?dir - direction)
   :precondition (and (at ?p ?from)
                      (clear ?to)
                      (move-dir ?from ?to ?dir)
                      )
   :effect       (and (not (at ?p ?from))
                      (not (clear ?to))
                      (at ?p ?to)
                      (clear ?from)
                      )
   )

    (
        :action push-stone-not-wall-and-clear-next
        :parameters 
        (
            ?p - player
            ?s - stone
            ?player_position ?from ?to ?next - location
            ?dir - direction
        )
        :precondition
        (
            and
                (at ?p ?player_position)
                (at ?s ?from)
                (clear ?to)
                (move-dir ?player_position ?from ?dir)
                (move-dir ?from ?to ?dir)
                
                ;; "to" location cannot be adjacent to the wall on "dir" direction.

                (not (is-wall-on ?to ?dir))

                ;; "next" location needs to be connected and clear.

                (move-dir ?to ?next ?dir)
                (clear ?next)
        )
        :effect
        (
            oneof        
            (
                ;; move stone normally to 
                and
                    (not (at ?p ?player_position))
                    (not (at ?s ?from))
                    (not (clear ?to))
                    (at ?p ?from)
                    (at ?s ?to)
                    (clear ?player_position)
                    (increase (total-cost) 1)
                    (
                        when
                            (is-goal ?to)
                            (at-goal ?s)
                    )
                    (
                        when
                            (is-nongoal ?to)
                            (not (at-goal ?s))
                    )
            )
            (
                ;; push stone one block further to next position
                and
                    (not (at ?p ?player_position))
                    (not (at ?s ?from))
                    (not (clear ?to))
                    (clear ?player_position)

                    ;; player position may change on next version
                    (clear ?from)
                    (not (clear ?next))
                    (at ?p ?to)
                    (at ?s ?next)

                    ;; increase total cost may change on next version
                    (increase (total-cost) 1)
                    (
                        when
                            (is-goal ?next)
                            (at-goal ?s)
                    )
                    (
                        when
                            (is-nongoal ?next)
                            (not (at-goal ?next))
                    )
            )

        )

    )

    (
        :action push-stone-wall-next
        :parameters 
        (
            ?p - player
            ?s - stone
            ?player_position ?from ?to - location
            ?dir - direction
        )
        :precondition
        (
            and
                (at ?p ?player_position)
                (at ?s ?from)
                (clear ?to)
                (move-dir ?player_position ?from ?dir)
                (move-dir ?from ?to ?dir)
                
                ;; "to" location is adjacent to the wall on that direction.

                (is-wall-on ?to ?dir)
        )
        :effect
        (
            
            ;; move stone normally to, because there is no way you could push further on that direction.
            and
                (not (at ?p ?player_position))
                (not (at ?s ?from))
                (not (clear ?to))
                (at ?p ?from)
                (at ?s ?to)
                (clear ?player_position)
                (increase (total-cost) 1)
                (
                    when
                        (is-goal ?to)
                        (at-goal ?s)
                )
                (
                    when
                        (is-nongoal ?to)
                        (not (at-goal ?s))
                )
        )
    )

    (
        :action push-stone-not-wall-and-not-clear-next
        :parameters 
        (
            ?p - player
            ?s - stone
            ?player_position ?from ?to ?next - location
            ?dir - direction
        )
        :precondition
        (
            and
                (at ?p ?player_position)
                (at ?s ?from)
                (clear ?to)
                (move-dir ?player_position ?from ?dir)
                (move-dir ?from ?to ?dir)
                
                ;; next position needs to be free and connected
                (not (is-wall-on ?to ?dir))

                (move-dir ?to ?next ?dir)
                (not (clear ?next))
        )
        :effect
        (
            
            ;; move stone normally to, because there is no way you could push further on that direction.
            and
                (not (at ?p ?player_position))
                (not (at ?s ?from))
                (not (clear ?to))
                (at ?p ?from)
                (at ?s ?to)
                (clear ?player_position)
                (increase (total-cost) 1)
                (
                    when
                        (is-goal ?to)
                        (at-goal ?s)
                )
                (
                    when
                        (is-nongoal ?to)
                        (not (at-goal ?s))
                )
        )
    )
)