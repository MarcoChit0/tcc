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
            :action move-slippery
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
        (
            :action move-non-slippery
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

                    ;; place player on box's previous position and clear theirs previous position
                    (player-at ?box_pos)
                    (is-clear ?player_pos)
                    
                    (
                        oneof        
                        ;; place box on desired box position and mark desired box position as occupied
                        (
                            and
                                (box-at ?desired_box_pos)
                                (not (is-clear ?desired_box_pos))
                        )
                        ;; place box on undesired box position and mark undesired box position as occupied
                        (
                            and
                                (box-at ?undesired_box_pos)
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
            :parameters (?player_pos ?boots_pos - location)
            :precondition
            (
                and
                    (alive)

                    (player-at ?player_pos)
                    (boots-at ?boots_pos)

                    (not (using-non-slippery-boots))
                    
                    ;; boots should be on reach 
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