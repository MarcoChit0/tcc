;;	#######
;;	#7~34##
;;	#9FB*C#
;;	#6825##
;;	#######

(define (problem p1-sokoban-non-deterministic)
	(:domain sokoban-non-deterministic)
	(:objects
		r0c0 - location
		r0c1 - location
		r0c2 - location
		r0c3 - location
		r0c4 - location
		r0c5 - location
		r0c6 - location
		r1c0 - location
		r1c1 - location
		r1c2 - location
		r1c3 - location
		r1c4 - location
		r1c5 - location
		r1c6 - location
		r2c0 - location
		r2c1 - location
		r2c2 - location
		r2c3 - location
		r2c4 - location
		r2c5 - location
		r2c6 - location
		r3c0 - location
		r3c1 - location
		r3c2 - location
		r3c3 - location
		r3c4 - location
		r3c5 - location
		r3c6 - location
		r4c0 - location
		r4c1 - location
		r4c2 - location
		r4c3 - location
		r4c4 - location
		r4c5 - location
		r4c6 - location
		up - direction
		down - direction
		left - direction
		right - direction

	)
	(:init
		

		;; r0c0 - wall
		

		;; r0c1 - wall
		

		;; r0c2 - wall
		

		;; r0c3 - wall
		

		;; r0c4 - wall
		

		;; r0c5 - wall
		

		;; r0c6 - wall
		

		;; r1c0 - wall
		

		;; r1c1 - box_on_goal
		(at-goal r1c1)
		(box-at r1c1)
		(is-goal r1c1)
		(move-dir r1c1 r2c1 down)
		(move-dir r1c1 r1c2 right)
		

		;; r1c2 - slipper_floor
		(is-clear r1c2)
		(slippery-floor r1c2)
		(move-dir r1c2 r2c2 down)
		(move-dir r1c2 r1c1 left)
		(move-dir r1c2 r1c3 right)
		

		;; r1c3 - player_on_slipper_floor
		(player-at r1c3)
		(alive)
		(slippery-floor r1c3)
		(move-dir r1c3 r2c3 down)
		(move-dir r1c3 r1c2 left)
		(move-dir r1c3 r1c4 right)
		

		;; r1c4 - box_on_slipper_floor
		(box-at r1c4)
		(slippery-floor r1c4)
		(move-dir r1c4 r2c4 down)
		(move-dir r1c4 r1c3 left)
		

		;; r1c5 - wall
		

		;; r1c6 - wall
		

		;; r2c0 - wall
		

		;; r2c1 - player_on_goal_on_slipper_floor
		(player-at r2c1)
		(alive)
		(slippery-floor r2c1)
		(is-goal r2c1)
		(move-dir r2c1 r1c1 up)
		(move-dir r2c1 r3c1 down)
		(move-dir r2c1 r2c2 right)
		

		;; r2c2 - player_with_boots_on_goal_on_slipper_floor
		(using-non-slippery-boots)
		(player-at r2c2)
		(alive)
		(boots-at r2c2)
		(slippery-floor r2c2)
		(is-goal r2c2)
		(move-dir r2c2 r1c2 up)
		(move-dir r2c2 r3c2 down)
		(move-dir r2c2 r2c1 left)
		(move-dir r2c2 r2c3 right)
		

		;; r2c3 - boots_on_goal_on_slipper_floor
		(boots-at r2c3)
		(slippery-floor r2c3)
		(is-goal r2c3)
		(move-dir r2c3 r1c3 up)
		(move-dir r2c3 r3c3 down)
		(move-dir r2c3 r2c2 left)
		(move-dir r2c3 r2c4 right)
		

		;; r2c4 - goal
		(is-clear r2c4)
		(is-goal r2c4)
		(move-dir r2c4 r1c4 up)
		(move-dir r2c4 r3c4 down)
		(move-dir r2c4 r2c3 left)
		(move-dir r2c4 r2c5 right)
		

		;; r2c5 - player_with_boots
		(using-non-slippery-boots)
		(player-at r2c5)
		(alive)
		(boots-at r2c5)
		(move-dir r2c5 r2c4 left)
		

		;; r2c6 - wall
		

		;; r3c0 - wall
		

		;; r3c1 - player_on_goal
		(player-at r3c1)
		(alive)
		(is-goal r3c1)
		(move-dir r3c1 r2c1 up)
		(move-dir r3c1 r3c2 right)
		

		;; r3c2 - boots_on_goal
		(boots-at r3c2)
		(is-goal r3c2)
		(move-dir r3c2 r2c2 up)
		(move-dir r3c2 r3c1 left)
		(move-dir r3c2 r3c3 right)
		

		;; r3c3 - boots
		(boots-at r3c3)
		(move-dir r3c3 r2c3 up)
		(move-dir r3c3 r3c2 left)
		(move-dir r3c3 r3c4 right)
		

		;; r3c4 - boots_on_slipper_floor
		(boots-at r3c4)
		(slippery-floor r3c4)
		(move-dir r3c4 r2c4 up)
		(move-dir r3c4 r3c3 left)
		

		;; r3c5 - wall
		

		;; r3c6 - wall
		

		;; r4c0 - wall
		

		;; r4c1 - wall
		

		;; r4c2 - wall
		

		;; r4c3 - wall
		

		;; r4c4 - wall
		

		;; r4c5 - wall
		

		;; r4c6 - wall

	)
	(:goal
		(and
			(at-goal r1c1)
			(at-goal r2c1)
			(at-goal r2c2)
			(at-goal r2c3)
			(at-goal r2c4)
			(at-goal r3c1)
			(at-goal r3c2)
		)
	)
)
