(
    define 
        (domain sokoban-non-deterministic)
        (:requirements :typing :strips :non-deterministic)
        (:types location direction)
        (:predicates 
            (is-clear ?loc - location)
            (at-goal ?loc - location)
            (stone-at ?loc - location)
            (is-goal ?loc - location)
            (player-at ?loc - location)
            (move-dir ?from ?to - location ?dir - direction)
        )

        (
            :action move
            :parameters (?from ?to - location ?dir - direction)
            :precondition 
            (
                and 
                    (player-at ?from)
                    (is-clear ?to)
                    (move-dir ?from ?to ?dir)
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

        (
            :action push-stone-clear
            :parameters 
            (
                ?player_pos ?stone_pos ?desired_stone_pos ?undesired_stone_pos - location
                ?dir - direction
            )
            :precondition
            (
                and
                    ;; player and stone at defined positions
                    (player-at ?player_pos)
                    (stone-at ?stone_pos)
                    
                    ;; all positions must be connected
                    (move-dir ?player_pos ?stone_pos ?dir)
                    (move-dir ?stone_pos ?desired_stone_pos ?dir)
                    (move-dir ?desired_stone_pos ?undesired_stone_pos ?dir)

                    ;; desired and undesired positions must be clear
                    (is-clear ?desired_stone_pos)
                    (is-clear ?undesired_stone_pos)
            )
            :effect
            (
                oneof        
                (
                    ;; move stone to desired position, and player stays on previous stone position
                    and
                        ;; remove player and stone from theirs previous positions
                        (not (player-at ?player_pos))
                        (not (stone-at ?stone_pos))

                        ;; place player on stone's previous position and stone on desired stone position
                        (player-at ?stone_pos)
                        (stone-at ?desired_stone_pos)

                        ;; clear player position and mark desired stone position as occupied
                        (is-clear ?player_pos)
                        (not (is-clear ?desired_stone_pos))

                        ;; if stone was placed upon a goal, mark it
                        (
                            when
                                (is-goal ?desired_stone_pos)
                                (at-goal ?desired_stone_pos)
                        )

                        ;; if the previous position the stone were in was a goal, turn off the mark
                        (
                            when
                                (is-goal ?stone_pos)
                                (not (at-goal ?stone_pos))
                        )
                )
                (
                    ;; move stone to undesired position, and player stays on previous stone position
                    and
                        ;; remove player and stone from theirs previous positions
                        (not (player-at ?player_pos))
                        (not (stone-at ?stone_pos))

                        ;; place player on stone's previous position and stone on undesired stone position
                        (player-at ?stone_pos)
                        (stone-at ?undesired_stone_pos)

                        ;; clear player position and mark desired stone position as occupied
                        (is-clear ?player_pos)
                        (not (is-clear ?undesired_stone_pos))

                        ;; if stone was placed upon a goal, mark it
                        (
                            when
                                (is-goal ?undesired_stone_pos)
                                (at-goal ?undesired_stone_pos)
                        )

                        ;; if the previous position the stone were in was a goal, turn off the mark
                        (
                            when
                                (is-goal ?stone_pos)
                                (not (at-goal ?stone_pos))
                        )
                )

            )

        )
(
            :action push-stone-not-clear
            :parameters 
            (
                ?player_pos ?stone_pos ?desired_stone_pos ?undesired_stone_pos - location
                ?dir - direction
            )
            :precondition
            (
                and
                    ;; player and stone at defined positions
                    (player-at ?player_pos)
                    (stone-at ?stone_pos)
                    
                    ;; all positions must be connected
                    (move-dir ?player_pos ?stone_pos ?dir)
                    (move-dir ?stone_pos ?desired_stone_pos ?dir)
                    (move-dir ?desired_stone_pos ?undesired_stone_pos ?dir)

                    ;; desired position must be clear, while undesired must not be clear
                    (is-clear ?desired_stone_pos)
                    (not (is-clear ?undesired_stone_pos))
            )
            :effect
            (
                ;; move stone to desired position, since it cannot make an undesired movimente
                and
                    ;; remove player and stone from theirs previous positions
                    (not (player-at ?player_pos))
                    (not (stone-at ?stone_pos))

                    ;; place player on stone's previous position and stone on desired stone position
                    (player-at ?stone_pos)
                    (stone-at ?desired_stone_pos)

                    ;; clear player position and mark desired stone position as occupied
                    (is-clear ?player_pos)
                    (not (is-clear ?desired_stone_pos))

                    ;; if stone was placed upon a goal, mark it
                    (
                        when
                            (is-goal ?desired_stone_pos)
                            (at-goal ?desired_stone_pos)
                    )

                    ;; if the previous position the stone were in was a goal, turn off the mark
                    (
                        when
                            (is-goal ?stone_pos)
                            (not (at-goal ?stone_pos))
                    )
                
            )
        )
)