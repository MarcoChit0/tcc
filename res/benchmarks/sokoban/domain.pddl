(
    define 
        (domain sokoban-non-deterministic)
        (:requirements :typing :strips :non-deterministic :disjunctive-preconditions :existential-preconditions)
        (:types location direction)
        (:predicates 
            (is-clear ?loc - location)
            (box-at ?loc - location)
            (player-at ?loc - location)
            (boots-at ?loc - location)
            (is-slippery ?loc - location)
            (using-non-slippery-boots)
            (alive)
            (move-dir ?from ?to - location ?dir - direction)
        )
        (
            :action move
            :parameters (?from ?to - location ?dir - direction)
            :precondition 
            (
                and 
                    (alive)
                    (player-at ?from)
                    (is-clear ?to)
                    (is-slippery ?to)
                    (move-dir ?from ?to ?dir)
            )
            :effect       
            (
                and 
                    (not (player-at ?from))
                    (is-clear ?from)
                    (not (is-clear ?to))
                    (player-at ?to)
                    (when
                        (not (using-non-slippery-boots))
                        (oneof 
                            (and)           ;; stays alive 
                            (not (alive))   ;; fall and die
                        )
                    )
            )
        )
        (
            :action push-box-slippery
            :parameters 
            (
                ?player_pos ?box_pos ?desired_box_pos ?undesired_box_pos - location
                ?dir - direction
            )
            :precondition
            (
                and
                    (alive)

                    ;; player and box at defined positions
                    (player-at ?player_pos)
                    (box-at ?box_pos)
                    
                    ;; all positions must be connected
                    (move-dir ?player_pos ?box_pos ?dir)
                    (move-dir ?box_pos ?desired_box_pos ?dir)
                    (move-dir ?desired_box_pos ?undesired_box_pos ?dir)

                    ;; desired poistion must be clear
                    (is-clear ?desired_box_pos)

                    ;; desired position is slippery & undesired position is clear -> move box to desired position | move box to undesired position 
                    (is-slippery ?desired_box_pos)
                    (is-clear ?undesired_box_pos)
            )
            :effect
            (
                
                    and
                        ;; remove player and box from theirs previous positions
                        (not (player-at ?player_pos))
                        (not (box-at ?box_pos))
                        (
                            oneof        
                            ;; move box to desired position, and player stays on previous box position
                            (
                                and
                                    ;; place player on box's previous position and box on desired box position
                                    (player-at ?box_pos)
                                    (box-at ?desired_box_pos)

                                    ;; clear player position and mark desired box position as occupied
                                    (is-clear ?player_pos)
                                    (not (is-clear ?desired_box_pos))
                            )
                            ;; move box to undesired position, and player stays on previous box position
                            (
                                and
                                    ;; place player on box's previous position and box on undesired box position
                                    (player-at ?box_pos)
                                    (box-at ?undesired_box_pos)

                                    ;; clear player position and mark desired box position as occupied
                                    (is-clear ?player_pos)
                                    (not (is-clear ?undesired_box_pos))
                            )
                        )
            )

        )
        (
            :action push-box-not-slippery
            :parameters 
            (
                ?player_pos ?box_pos ?desired_box_pos ?undesired_box_pos - location
                ?dir - direction
            )
            :precondition
            (
                and
                    (alive)

                    ;; player and box at defined positions
                    (player-at ?player_pos)
                    (box-at ?box_pos)
                    
                    ;; all positions must be connected
                    (move-dir ?player_pos ?box_pos ?dir)
                    (move-dir ?box_pos ?desired_box_pos ?dir)
                    (move-dir ?desired_box_pos ?undesired_box_pos ?dir)

                    ;; desired poistion must be clear
                    (is-clear ?desired_box_pos)

                    ;; desired location is not slippery | undesired location is not clear -> box goes to desired position
                    (or
                        (not (is-slippery ?desired_box_pos))
                        (not (is-clear ?undesired_box_pos))
                    )
            )
            :effect
            (
                and

                    ;; remove player and box from theirs previous positions
                    (not (player-at ?player_pos))
                    (not (box-at ?box_pos))

                    ;; place player on box's previous position and box on desired box position
                    (player-at ?box_pos)
                    (box-at ?desired_box_pos)

                    ;; clear player position and mark desired box position as occupied
                    (is-clear ?player_pos)
                    (not (is-clear ?desired_box_pos))
            )
        )
                    
        (
            :action put-boots
            :parameters (?player_pos ?boots_pos - location ?dir - direction)
            :precondition
            (
                and
                    (alive)

                    (player-at ?player_pos)
                    (boots-at ?boots_pos)
                    
                    boots should be on reach 
                    (exists (?dir - direction)
                        (move-dir ?player_pos ?boots_pos ?dir)
                    )
            )
            :effect
            (
                and
                    (using-non-slippery-boots)
                    (not (boots-at ?boots_pos))
                    (is-clear ?boots_pos)
            )
        )
)