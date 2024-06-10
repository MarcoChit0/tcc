(define (domain sokoban-non-deterministic)
        (:requirements :typing :strips :non-deterministic :disjunctive-preconditions :existential-preconditions)
        (:types location direction box)
        (:predicates 
            (is-clear ?loc - location)
            (box-at ?b - box ?loc - location)
            (player-at ?loc - location)
            (boots-at ?loc - location)
            (is-slippery ?loc - location)
            (using-non-slippery-boots)
            (alive)
            (move-dir ?from ?to - location ?dir - direction)
            (at-goal ?b - box)
            (is-goal ?loc - location)
        )
        (:action move-slippery
            :parameters (?from ?to - location ?dir - direction)
            :precondition 
            (
                and 
                    (alive)
                    (player-at ?from)
                    (is-clear ?to)
                    (move-dir ?from ?to ?dir)
                    (not (using-non-slippery-boots))
                    (is-slippery ?to)
            )
            :effect       
            (
                and 
                    (not (player-at ?from))
                    (is-clear ?from)
                    (not (is-clear ?to))
                    (player-at ?to)
                    (oneof 
                        (and)           ;; stays alive 
                        (not (alive))   ;; fall and die
                    )
                    
            )
        )
        (:action move-non-slippery
            :parameters (?from ?to - location ?dir - direction)
            :precondition 
            (
                and 
                    (alive)
                    (player-at ?from)
                    (is-clear ?to)
                    (move-dir ?from ?to ?dir)
                    (or
                        (using-non-slippery-boots)
                        (not (is-slippery ?to))
                    )
            )
            :effect       
            (
                and 
                    (not (player-at ?from))
                    (is-clear ?from)
                    (not (is-clear ?to))
                    (player-at ?to)
            )
        )
        (:action push-box-slippery
            :parameters (?ppos ?bpos ?dpos ?upos - location ?dir - direction ?b - box)
            :precondition
            (
                and
                    (alive)

                    ;; player and box at defined positions
                    (player-at ?ppos)
                    (box-at ?b ?bpos)
                    
                    ;; all positions must be connected
                    (move-dir ?ppos ?bpos ?dir)
                    (move-dir ?bpos ?dpos ?dir)
                    (move-dir ?dpos ?upos ?dir)

                    ;; desired poistion must be clear
                    (is-clear ?dpos)

                    ;; desired position is slippery & undesired position is clear -> move box to desired position | move box to undesired position 
                    (is-slippery ?dpos)
                    (is-clear ?upos)
            )
            :effect
            (
                and
                    ;; remove player and box from theirs previous positions
                    (not (player-at ?ppos))
                    (not (box-at ?b ?bpos))
                    (not (at-goal ?b))

                    ;; place player on box's previous position and clear theirs previous position
                    (player-at ?bpos)
                    (is-clear ?ppos)
                    
                    (
                        oneof        
                        ;; place box on desired box position and mark desired box position as occupied
                        (
                            and
                                (box-at ?b ?dpos)
                                (not (is-clear ?dpos))
                        )
                        ;; place box on undesired box position and mark undesired box position as occupied
                        (
                            and
                                (box-at ?b ?upos)
                                (not (is-clear ?upos))
                        )
                    )
            )

        )
        (:action push-box-not-slippery
            :parameters  (?ppos ?bpos ?dpos ?upos - location ?dir - direction ?b - box)
            :precondition
            (
                and
                    (alive)

                    ;; player and box at defined positions
                    (player-at ?ppos)
                    (box-at ?b ?bpos)
                    
                    ;; all positions must be connected
                    (move-dir ?ppos ?bpos ?dir)
                    (move-dir ?bpos ?dpos ?dir)
                    (move-dir ?dpos ?upos ?dir)

                    ;; desired poistion must be clear
                    (is-clear ?dpos)

                    ;; desired location is not slippery | undesired location is not clear -> box goes to desired position
                    (or
                        (not (is-slippery ?dpos))
                        (not (is-clear ?upos))
                    )
            )
            :effect
            (
                and

                    ;; remove player and box from theirs previous positions
                    (not (player-at ?ppos))
                    (not (box-at ?b ?bpos))
                    (not (at-goal ?b))

                    ;; place player on box's previous position and box on desired box position
                    (player-at ?bpos)
                    (box-at ?b ?dpos)

                    ;; clear player position and mark desired box position as occupied
                    (is-clear ?ppos)
                    (not (is-clear ?dpos))
            )
        )
        (:action box-at-goal
            :parameters 
            (
                ?loc - location ?b - box
            )
            :precondition
            (
                and
                    (alive)
                    (is-goal ?loc)
                    (box-at ?b ?loc)
            )
            :effect
            (
                and
                    (at-goal ?b)
            )
        )
        (:action put-boots
            :parameters (?ppos ?boots-pos - location)
            :precondition
            (
                and
                    (alive)

                    (player-at ?ppos)
                    (boots-at ?boots-pos)

                    (not (using-non-slippery-boots))
                    
                    ;; boots should be on reach 
                    (exists (?dir - direction)
                        (move-dir ?ppos ?boots-pos ?dir)
                    )
            )
            :effect
            (
                and
                    (using-non-slippery-boots)
                    (not (boots-at ?boots-pos))
                    (is-clear ?boots-pos)
            )
        )
)