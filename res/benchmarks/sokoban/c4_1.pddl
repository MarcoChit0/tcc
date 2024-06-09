(define (problem c4_1-sokoban-non-deterministic)
	(:domain sokoban-non-deterministic)
	(:objects
		r0c0 - location
		r0c1 - location
		r0c2 - location
		r0c3 - location
		r0c4 - location
		r0c5 - location
		r0c6 - location
		r0c7 - location
		r0c8 - location
		r1c0 - location
		r1c1 - location
		r1c2 - location
		r1c3 - location
		r1c4 - location
		r1c5 - location
		r1c6 - location
		r1c7 - location
		r1c8 - location
		r2c0 - location
		r2c1 - location
		r2c2 - location
		r2c3 - location
		r2c4 - location
		r2c5 - location
		r2c6 - location
		r2c7 - location
		r2c8 - location
		r3c0 - location
		r3c1 - location
		r3c2 - location
		r3c3 - location
		r3c4 - location
		r3c5 - location
		r3c6 - location
		r3c7 - location
		r3c8 - location
		r4c0 - location
		r4c1 - location
		r4c2 - location
		r4c3 - location
		r4c4 - location
		r4c5 - location
		r4c6 - location
		r4c7 - location
		r4c8 - location
		r5c0 - location
		r5c1 - location
		r5c2 - location
		r5c3 - location
		r5c4 - location
		r5c5 - location
		r5c6 - location
		r5c7 - location
		r5c8 - location
		r6c0 - location
		r6c1 - location
		r6c2 - location
		r6c3 - location
		r6c4 - location
		r6c5 - location
		r6c6 - location
		r6c7 - location
		r6c8 - location
		up - direction
		down - direction
		left - direction
		right - direction
		box_0 - box
		box_1 - box
		box_2 - box
		box_3 - box
		box_4 - box

	)
	(:init
		

		;; r0c0 - wall
		(not (is-clear r0c0))
		(move-dir r0c0 r1c0 down)
		(move-dir r0c0 r0c1 right)
		

		;; r0c1 - wall
		(not (is-clear r0c1))
		(move-dir r0c1 r1c1 down)
		(move-dir r0c1 r0c0 left)
		(move-dir r0c1 r0c2 right)
		

		;; r0c2 - wall
		(not (is-clear r0c2))
		(move-dir r0c2 r1c2 down)
		(move-dir r0c2 r0c1 left)
		(move-dir r0c2 r0c3 right)
		

		;; r0c3 - wall
		(not (is-clear r0c3))
		(move-dir r0c3 r1c3 down)
		(move-dir r0c3 r0c2 left)
		(move-dir r0c3 r0c4 right)
		

		;; r0c4 - wall
		(not (is-clear r0c4))
		(move-dir r0c4 r1c4 down)
		(move-dir r0c4 r0c3 left)
		(move-dir r0c4 r0c5 right)
		

		;; r0c5 - wall
		(not (is-clear r0c5))
		(move-dir r0c5 r1c5 down)
		(move-dir r0c5 r0c4 left)
		(move-dir r0c5 r0c6 right)
		

		;; r0c6 - wall
		(not (is-clear r0c6))
		(move-dir r0c6 r1c6 down)
		(move-dir r0c6 r0c5 left)
		(move-dir r0c6 r0c7 right)
		

		;; r0c7 - wall
		(not (is-clear r0c7))
		(move-dir r0c7 r1c7 down)
		(move-dir r0c7 r0c6 left)
		(move-dir r0c7 r0c8 right)
		

		;; r0c8 - wall
		(not (is-clear r0c8))
		(move-dir r0c8 r1c8 down)
		(move-dir r0c8 r0c7 left)
		

		;; r1c0 - wall
		(not (is-clear r1c0))
		(move-dir r1c0 r0c0 up)
		(move-dir r1c0 r2c0 down)
		(move-dir r1c0 r1c1 right)
		

		;; r1c1 - goal
		(is-clear r1c1)
		(is-goal r1c1)
		(move-dir r1c1 r0c1 up)
		(move-dir r1c1 r2c1 down)
		(move-dir r1c1 r1c0 left)
		(move-dir r1c1 r1c2 right)
		

		;; r1c2 - box
		(box-at box_0 r1c2)
		(move-dir r1c2 r0c2 up)
		(move-dir r1c2 r2c2 down)
		(move-dir r1c2 r1c1 left)
		(move-dir r1c2 r1c3 right)
		

		;; r1c3 - empty
		(is-clear r1c3)
		(move-dir r1c3 r0c3 up)
		(move-dir r1c3 r2c3 down)
		(move-dir r1c3 r1c2 left)
		(move-dir r1c3 r1c4 right)
		

		;; r1c4 - empty
		(is-clear r1c4)
		(move-dir r1c4 r0c4 up)
		(move-dir r1c4 r2c4 down)
		(move-dir r1c4 r1c3 left)
		(move-dir r1c4 r1c5 right)
		

		;; r1c5 - empty
		(is-clear r1c5)
		(move-dir r1c5 r0c5 up)
		(move-dir r1c5 r2c5 down)
		(move-dir r1c5 r1c4 left)
		(move-dir r1c5 r1c6 right)
		

		;; r1c6 - box
		(box-at box_1 r1c6)
		(move-dir r1c6 r0c6 up)
		(move-dir r1c6 r2c6 down)
		(move-dir r1c6 r1c5 left)
		(move-dir r1c6 r1c7 right)
		

		;; r1c7 - goal
		(is-clear r1c7)
		(is-goal r1c7)
		(move-dir r1c7 r0c7 up)
		(move-dir r1c7 r2c7 down)
		(move-dir r1c7 r1c6 left)
		(move-dir r1c7 r1c8 right)
		

		;; r1c8 - wall
		(not (is-clear r1c8))
		(move-dir r1c8 r0c8 up)
		(move-dir r1c8 r2c8 down)
		(move-dir r1c8 r1c7 left)
		

		;; r2c0 - wall
		(not (is-clear r2c0))
		(move-dir r2c0 r1c0 up)
		(move-dir r2c0 r3c0 down)
		(move-dir r2c0 r2c1 right)
		

		;; r2c1 - empty
		(is-clear r2c1)
		(move-dir r2c1 r1c1 up)
		(move-dir r2c1 r3c1 down)
		(move-dir r2c1 r2c0 left)
		(move-dir r2c1 r2c2 right)
		

		;; r2c2 - empty
		(is-clear r2c2)
		(move-dir r2c2 r1c2 up)
		(move-dir r2c2 r3c2 down)
		(move-dir r2c2 r2c1 left)
		(move-dir r2c2 r2c3 right)
		

		;; r2c3 - empty
		(is-clear r2c3)
		(move-dir r2c3 r1c3 up)
		(move-dir r2c3 r3c3 down)
		(move-dir r2c3 r2c2 left)
		(move-dir r2c3 r2c4 right)
		

		;; r2c4 - slipper_floor
		(is-clear r2c4)
		(is-slippery r2c4)
		(move-dir r2c4 r1c4 up)
		(move-dir r2c4 r3c4 down)
		(move-dir r2c4 r2c3 left)
		(move-dir r2c4 r2c5 right)
		

		;; r2c5 - empty
		(is-clear r2c5)
		(move-dir r2c5 r1c5 up)
		(move-dir r2c5 r3c5 down)
		(move-dir r2c5 r2c4 left)
		(move-dir r2c5 r2c6 right)
		

		;; r2c6 - empty
		(is-clear r2c6)
		(move-dir r2c6 r1c6 up)
		(move-dir r2c6 r3c6 down)
		(move-dir r2c6 r2c5 left)
		(move-dir r2c6 r2c7 right)
		

		;; r2c7 - wall
		(not (is-clear r2c7))
		(move-dir r2c7 r1c7 up)
		(move-dir r2c7 r3c7 down)
		(move-dir r2c7 r2c6 left)
		(move-dir r2c7 r2c8 right)
		

		;; r2c8 - wall
		(not (is-clear r2c8))
		(move-dir r2c8 r1c8 up)
		(move-dir r2c8 r3c8 down)
		(move-dir r2c8 r2c7 left)
		

		;; r3c0 - wall
		(not (is-clear r3c0))
		(move-dir r3c0 r2c0 up)
		(move-dir r3c0 r4c0 down)
		(move-dir r3c0 r3c1 right)
		

		;; r3c1 - player_with_boots
		(using-non-slippery-boots)
		(player-at r3c1)
		(alive)
		(boots-at r3c1)
		(move-dir r3c1 r2c1 up)
		(move-dir r3c1 r4c1 down)
		(move-dir r3c1 r3c0 left)
		(move-dir r3c1 r3c2 right)
		

		;; r3c2 - box
		(box-at box_2 r3c2)
		(move-dir r3c2 r2c2 up)
		(move-dir r3c2 r4c2 down)
		(move-dir r3c2 r3c1 left)
		(move-dir r3c2 r3c3 right)
		

		;; r3c3 - goal_on_slipper_floor
		(is-clear r3c3)
		(is-slippery r3c3)
		(is-goal r3c3)
		(move-dir r3c3 r2c3 up)
		(move-dir r3c3 r4c3 down)
		(move-dir r3c3 r3c2 left)
		(move-dir r3c3 r3c4 right)
		

		;; r3c4 - empty
		(is-clear r3c4)
		(move-dir r3c4 r2c4 up)
		(move-dir r3c4 r4c4 down)
		(move-dir r3c4 r3c3 left)
		(move-dir r3c4 r3c5 right)
		

		;; r3c5 - wall
		(not (is-clear r3c5))
		(move-dir r3c5 r2c5 up)
		(move-dir r3c5 r4c5 down)
		(move-dir r3c5 r3c4 left)
		(move-dir r3c5 r3c6 right)
		

		;; r3c6 - empty
		(is-clear r3c6)
		(move-dir r3c6 r2c6 up)
		(move-dir r3c6 r4c6 down)
		(move-dir r3c6 r3c5 left)
		(move-dir r3c6 r3c7 right)
		

		;; r3c7 - wall
		(not (is-clear r3c7))
		(move-dir r3c7 r2c7 up)
		(move-dir r3c7 r4c7 down)
		(move-dir r3c7 r3c6 left)
		(move-dir r3c7 r3c8 right)
		

		;; r3c8 - wall
		(not (is-clear r3c8))
		(move-dir r3c8 r2c8 up)
		(move-dir r3c8 r4c8 down)
		(move-dir r3c8 r3c7 left)
		

		;; r4c0 - wall
		(not (is-clear r4c0))
		(move-dir r4c0 r3c0 up)
		(move-dir r4c0 r5c0 down)
		(move-dir r4c0 r4c1 right)
		

		;; r4c1 - empty
		(is-clear r4c1)
		(move-dir r4c1 r3c1 up)
		(move-dir r4c1 r5c1 down)
		(move-dir r4c1 r4c0 left)
		(move-dir r4c1 r4c2 right)
		

		;; r4c2 - empty
		(is-clear r4c2)
		(move-dir r4c2 r3c2 up)
		(move-dir r4c2 r5c2 down)
		(move-dir r4c2 r4c1 left)
		(move-dir r4c2 r4c3 right)
		

		;; r4c3 - empty
		(is-clear r4c3)
		(move-dir r4c3 r3c3 up)
		(move-dir r4c3 r5c3 down)
		(move-dir r4c3 r4c2 left)
		(move-dir r4c3 r4c4 right)
		

		;; r4c4 - slipper_floor
		(is-clear r4c4)
		(is-slippery r4c4)
		(move-dir r4c4 r3c4 up)
		(move-dir r4c4 r5c4 down)
		(move-dir r4c4 r4c3 left)
		(move-dir r4c4 r4c5 right)
		

		;; r4c5 - empty
		(is-clear r4c5)
		(move-dir r4c5 r3c5 up)
		(move-dir r4c5 r5c5 down)
		(move-dir r4c5 r4c4 left)
		(move-dir r4c5 r4c6 right)
		

		;; r4c6 - empty
		(is-clear r4c6)
		(move-dir r4c6 r3c6 up)
		(move-dir r4c6 r5c6 down)
		(move-dir r4c6 r4c5 left)
		(move-dir r4c6 r4c7 right)
		

		;; r4c7 - wall
		(not (is-clear r4c7))
		(move-dir r4c7 r3c7 up)
		(move-dir r4c7 r5c7 down)
		(move-dir r4c7 r4c6 left)
		(move-dir r4c7 r4c8 right)
		

		;; r4c8 - wall
		(not (is-clear r4c8))
		(move-dir r4c8 r3c8 up)
		(move-dir r4c8 r5c8 down)
		(move-dir r4c8 r4c7 left)
		

		;; r5c0 - wall
		(not (is-clear r5c0))
		(move-dir r5c0 r4c0 up)
		(move-dir r5c0 r6c0 down)
		(move-dir r5c0 r5c1 right)
		

		;; r5c1 - goal
		(is-clear r5c1)
		(is-goal r5c1)
		(move-dir r5c1 r4c1 up)
		(move-dir r5c1 r6c1 down)
		(move-dir r5c1 r5c0 left)
		(move-dir r5c1 r5c2 right)
		

		;; r5c2 - box
		(box-at box_3 r5c2)
		(move-dir r5c2 r4c2 up)
		(move-dir r5c2 r6c2 down)
		(move-dir r5c2 r5c1 left)
		(move-dir r5c2 r5c3 right)
		

		;; r5c3 - empty
		(is-clear r5c3)
		(move-dir r5c3 r4c3 up)
		(move-dir r5c3 r6c3 down)
		(move-dir r5c3 r5c2 left)
		(move-dir r5c3 r5c4 right)
		

		;; r5c4 - empty
		(is-clear r5c4)
		(move-dir r5c4 r4c4 up)
		(move-dir r5c4 r6c4 down)
		(move-dir r5c4 r5c3 left)
		(move-dir r5c4 r5c5 right)
		

		;; r5c5 - empty
		(is-clear r5c5)
		(move-dir r5c5 r4c5 up)
		(move-dir r5c5 r6c5 down)
		(move-dir r5c5 r5c4 left)
		(move-dir r5c5 r5c6 right)
		

		;; r5c6 - box
		(box-at box_4 r5c6)
		(move-dir r5c6 r4c6 up)
		(move-dir r5c6 r6c6 down)
		(move-dir r5c6 r5c5 left)
		(move-dir r5c6 r5c7 right)
		

		;; r5c7 - goal
		(is-clear r5c7)
		(is-goal r5c7)
		(move-dir r5c7 r4c7 up)
		(move-dir r5c7 r6c7 down)
		(move-dir r5c7 r5c6 left)
		(move-dir r5c7 r5c8 right)
		

		;; r5c8 - wall
		(not (is-clear r5c8))
		(move-dir r5c8 r4c8 up)
		(move-dir r5c8 r6c8 down)
		(move-dir r5c8 r5c7 left)
		

		;; r6c0 - wall
		(not (is-clear r6c0))
		(move-dir r6c0 r5c0 up)
		(move-dir r6c0 r6c1 right)
		

		;; r6c1 - wall
		(not (is-clear r6c1))
		(move-dir r6c1 r5c1 up)
		(move-dir r6c1 r6c0 left)
		(move-dir r6c1 r6c2 right)
		

		;; r6c2 - wall
		(not (is-clear r6c2))
		(move-dir r6c2 r5c2 up)
		(move-dir r6c2 r6c1 left)
		(move-dir r6c2 r6c3 right)
		

		;; r6c3 - wall
		(not (is-clear r6c3))
		(move-dir r6c3 r5c3 up)
		(move-dir r6c3 r6c2 left)
		(move-dir r6c3 r6c4 right)
		

		;; r6c4 - wall
		(not (is-clear r6c4))
		(move-dir r6c4 r5c4 up)
		(move-dir r6c4 r6c3 left)
		(move-dir r6c4 r6c5 right)
		

		;; r6c5 - wall
		(not (is-clear r6c5))
		(move-dir r6c5 r5c5 up)
		(move-dir r6c5 r6c4 left)
		(move-dir r6c5 r6c6 right)
		

		;; r6c6 - wall
		(not (is-clear r6c6))
		(move-dir r6c6 r5c6 up)
		(move-dir r6c6 r6c5 left)
		(move-dir r6c6 r6c7 right)
		

		;; r6c7 - wall
		(not (is-clear r6c7))
		(move-dir r6c7 r5c7 up)
		(move-dir r6c7 r6c6 left)
		(move-dir r6c7 r6c8 right)
		

		;; r6c8 - wall
		(not (is-clear r6c8))
		(move-dir r6c8 r5c8 up)
		(move-dir r6c8 r6c7 left)

	)
	(:goal
		(and
			(at-goal box_0)
			(at-goal box_1)
			(at-goal box_2)
			(at-goal box_3)
			(at-goal box_4)
		)
	)
)
