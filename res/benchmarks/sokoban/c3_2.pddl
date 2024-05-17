(define (problem c3_2-sokoban-non-deterministic)
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
		r0c9 - location
		r0c10 - location
		r0c11 - location
		r0c12 - location
		r0c13 - location
		r0c14 - location
		r0c15 - location
		r0c16 - location
		r0c17 - location
		r0c18 - location
		r0c19 - location
		r1c0 - location
		r1c1 - location
		r1c2 - location
		r1c3 - location
		r1c4 - location
		r1c5 - location
		r1c6 - location
		r1c7 - location
		r1c8 - location
		r1c9 - location
		r1c10 - location
		r1c11 - location
		r1c12 - location
		r1c13 - location
		r1c14 - location
		r1c15 - location
		r1c16 - location
		r1c17 - location
		r1c18 - location
		r1c19 - location
		r2c0 - location
		r2c1 - location
		r2c2 - location
		r2c3 - location
		r2c4 - location
		r2c5 - location
		r2c6 - location
		r2c7 - location
		r2c8 - location
		r2c9 - location
		r2c10 - location
		r2c11 - location
		r2c12 - location
		r2c13 - location
		r2c14 - location
		r2c15 - location
		r2c16 - location
		r2c17 - location
		r2c18 - location
		r2c19 - location
		r3c0 - location
		r3c1 - location
		r3c2 - location
		r3c3 - location
		r3c4 - location
		r3c5 - location
		r3c6 - location
		r3c7 - location
		r3c8 - location
		r3c9 - location
		r3c10 - location
		r3c11 - location
		r3c12 - location
		r3c13 - location
		r3c14 - location
		r3c15 - location
		r3c16 - location
		r3c17 - location
		r3c18 - location
		r3c19 - location
		r4c0 - location
		r4c1 - location
		r4c2 - location
		r4c3 - location
		r4c4 - location
		r4c5 - location
		r4c6 - location
		r4c7 - location
		r4c8 - location
		r4c9 - location
		r4c10 - location
		r4c11 - location
		r4c12 - location
		r4c13 - location
		r4c14 - location
		r4c15 - location
		r4c16 - location
		r4c17 - location
		r4c18 - location
		r4c19 - location
		r5c0 - location
		r5c1 - location
		r5c2 - location
		r5c3 - location
		r5c4 - location
		r5c5 - location
		r5c6 - location
		r5c7 - location
		r5c8 - location
		r5c9 - location
		r5c10 - location
		r5c11 - location
		r5c12 - location
		r5c13 - location
		r5c14 - location
		r5c15 - location
		r5c16 - location
		r5c17 - location
		r5c18 - location
		r5c19 - location
		r6c0 - location
		r6c1 - location
		r6c2 - location
		r6c3 - location
		r6c4 - location
		r6c5 - location
		r6c6 - location
		r6c7 - location
		r6c8 - location
		r6c9 - location
		r6c10 - location
		r6c11 - location
		r6c12 - location
		r6c13 - location
		r6c14 - location
		r6c15 - location
		r6c16 - location
		r6c17 - location
		r6c18 - location
		r6c19 - location
		up - direction
		down - direction
		left - direction
		right - direction
		box_0 - box
		box_1 - box
		box_2 - box
		box_3 - box
		box_4 - box
		box_5 - box

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
		(move-dir r0c8 r0c9 right)
		

		;; r0c9 - wall
		(not (is-clear r0c9))
		(move-dir r0c9 r1c9 down)
		(move-dir r0c9 r0c8 left)
		(move-dir r0c9 r0c10 right)
		

		;; r0c10 - wall
		(not (is-clear r0c10))
		(move-dir r0c10 r1c10 down)
		(move-dir r0c10 r0c9 left)
		(move-dir r0c10 r0c11 right)
		

		;; r0c11 - wall
		(not (is-clear r0c11))
		(move-dir r0c11 r1c11 down)
		(move-dir r0c11 r0c10 left)
		(move-dir r0c11 r0c12 right)
		

		;; r0c12 - wall
		(not (is-clear r0c12))
		(move-dir r0c12 r1c12 down)
		(move-dir r0c12 r0c11 left)
		(move-dir r0c12 r0c13 right)
		

		;; r0c13 - wall
		(not (is-clear r0c13))
		(move-dir r0c13 r1c13 down)
		(move-dir r0c13 r0c12 left)
		(move-dir r0c13 r0c14 right)
		

		;; r0c14 - wall
		(not (is-clear r0c14))
		(move-dir r0c14 r1c14 down)
		(move-dir r0c14 r0c13 left)
		(move-dir r0c14 r0c15 right)
		

		;; r0c15 - wall
		(not (is-clear r0c15))
		(move-dir r0c15 r1c15 down)
		(move-dir r0c15 r0c14 left)
		(move-dir r0c15 r0c16 right)
		

		;; r0c16 - wall
		(not (is-clear r0c16))
		(move-dir r0c16 r1c16 down)
		(move-dir r0c16 r0c15 left)
		(move-dir r0c16 r0c17 right)
		

		;; r0c17 - wall
		(not (is-clear r0c17))
		(move-dir r0c17 r1c17 down)
		(move-dir r0c17 r0c16 left)
		(move-dir r0c17 r0c18 right)
		

		;; r0c18 - wall
		(not (is-clear r0c18))
		(move-dir r0c18 r1c18 down)
		(move-dir r0c18 r0c17 left)
		(move-dir r0c18 r0c19 right)
		

		;; r0c19 - wall
		(not (is-clear r0c19))
		(move-dir r0c19 r1c19 down)
		(move-dir r0c19 r0c18 left)
		

		;; r1c0 - wall
		(not (is-clear r1c0))
		(move-dir r1c0 r0c0 up)
		(move-dir r1c0 r2c0 down)
		(move-dir r1c0 r1c1 right)
		

		;; r1c1 - empty
		(is-clear r1c1)
		(move-dir r1c1 r0c1 up)
		(move-dir r1c1 r2c1 down)
		(move-dir r1c1 r1c0 left)
		(move-dir r1c1 r1c2 right)
		

		;; r1c2 - empty
		(is-clear r1c2)
		(move-dir r1c2 r0c2 up)
		(move-dir r1c2 r2c2 down)
		(move-dir r1c2 r1c1 left)
		(move-dir r1c2 r1c3 right)
		

		;; r1c3 - boots
		(boots-at r1c3)
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
		

		;; r1c6 - empty
		(is-clear r1c6)
		(move-dir r1c6 r0c6 up)
		(move-dir r1c6 r2c6 down)
		(move-dir r1c6 r1c5 left)
		(move-dir r1c6 r1c7 right)
		

		;; r1c7 - wall
		(not (is-clear r1c7))
		(move-dir r1c7 r0c7 up)
		(move-dir r1c7 r2c7 down)
		(move-dir r1c7 r1c6 left)
		(move-dir r1c7 r1c8 right)
		

		;; r1c8 - wall
		(not (is-clear r1c8))
		(move-dir r1c8 r0c8 up)
		(move-dir r1c8 r2c8 down)
		(move-dir r1c8 r1c7 left)
		(move-dir r1c8 r1c9 right)
		

		;; r1c9 - empty
		(is-clear r1c9)
		(move-dir r1c9 r0c9 up)
		(move-dir r1c9 r2c9 down)
		(move-dir r1c9 r1c8 left)
		(move-dir r1c9 r1c10 right)
		

		;; r1c10 - empty
		(is-clear r1c10)
		(move-dir r1c10 r0c10 up)
		(move-dir r1c10 r2c10 down)
		(move-dir r1c10 r1c9 left)
		(move-dir r1c10 r1c11 right)
		

		;; r1c11 - empty
		(is-clear r1c11)
		(move-dir r1c11 r0c11 up)
		(move-dir r1c11 r2c11 down)
		(move-dir r1c11 r1c10 left)
		(move-dir r1c11 r1c12 right)
		

		;; r1c12 - empty
		(is-clear r1c12)
		(move-dir r1c12 r0c12 up)
		(move-dir r1c12 r2c12 down)
		(move-dir r1c12 r1c11 left)
		(move-dir r1c12 r1c13 right)
		

		;; r1c13 - empty
		(is-clear r1c13)
		(move-dir r1c13 r0c13 up)
		(move-dir r1c13 r2c13 down)
		(move-dir r1c13 r1c12 left)
		(move-dir r1c13 r1c14 right)
		

		;; r1c14 - empty
		(is-clear r1c14)
		(move-dir r1c14 r0c14 up)
		(move-dir r1c14 r2c14 down)
		(move-dir r1c14 r1c13 left)
		(move-dir r1c14 r1c15 right)
		

		;; r1c15 - empty
		(is-clear r1c15)
		(move-dir r1c15 r0c15 up)
		(move-dir r1c15 r2c15 down)
		(move-dir r1c15 r1c14 left)
		(move-dir r1c15 r1c16 right)
		

		;; r1c16 - empty
		(is-clear r1c16)
		(move-dir r1c16 r0c16 up)
		(move-dir r1c16 r2c16 down)
		(move-dir r1c16 r1c15 left)
		(move-dir r1c16 r1c17 right)
		

		;; r1c17 - empty
		(is-clear r1c17)
		(move-dir r1c17 r0c17 up)
		(move-dir r1c17 r2c17 down)
		(move-dir r1c17 r1c16 left)
		(move-dir r1c17 r1c18 right)
		

		;; r1c18 - wall
		(not (is-clear r1c18))
		(move-dir r1c18 r0c18 up)
		(move-dir r1c18 r2c18 down)
		(move-dir r1c18 r1c17 left)
		(move-dir r1c18 r1c19 right)
		

		;; r1c19 - wall
		(not (is-clear r1c19))
		(move-dir r1c19 r0c19 up)
		(move-dir r1c19 r2c19 down)
		(move-dir r1c19 r1c18 left)
		

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
		

		;; r2c2 - wall
		(not (is-clear r2c2))
		(move-dir r2c2 r1c2 up)
		(move-dir r2c2 r3c2 down)
		(move-dir r2c2 r2c1 left)
		(move-dir r2c2 r2c3 right)
		

		;; r2c3 - slipper_floor
		(is-clear r2c3)
		(is-slippery r2c3)
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
		

		;; r2c5 - slipper_floor
		(is-clear r2c5)
		(is-slippery r2c5)
		(move-dir r2c5 r1c5 up)
		(move-dir r2c5 r3c5 down)
		(move-dir r2c5 r2c4 left)
		(move-dir r2c5 r2c6 right)
		

		;; r2c6 - goal
		(is-clear r2c6)
		(is-goal r2c6)
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
		(move-dir r2c8 r2c9 right)
		

		;; r2c9 - empty
		(is-clear r2c9)
		(move-dir r2c9 r1c9 up)
		(move-dir r2c9 r3c9 down)
		(move-dir r2c9 r2c8 left)
		(move-dir r2c9 r2c10 right)
		

		;; r2c10 - empty
		(is-clear r2c10)
		(move-dir r2c10 r1c10 up)
		(move-dir r2c10 r3c10 down)
		(move-dir r2c10 r2c9 left)
		(move-dir r2c10 r2c11 right)
		

		;; r2c11 - slipper_floor
		(is-clear r2c11)
		(is-slippery r2c11)
		(move-dir r2c11 r1c11 up)
		(move-dir r2c11 r3c11 down)
		(move-dir r2c11 r2c10 left)
		(move-dir r2c11 r2c12 right)
		

		;; r2c12 - goal
		(is-clear r2c12)
		(is-goal r2c12)
		(move-dir r2c12 r1c12 up)
		(move-dir r2c12 r3c12 down)
		(move-dir r2c12 r2c11 left)
		(move-dir r2c12 r2c13 right)
		

		;; r2c13 - wall
		(not (is-clear r2c13))
		(move-dir r2c13 r1c13 up)
		(move-dir r2c13 r3c13 down)
		(move-dir r2c13 r2c12 left)
		(move-dir r2c13 r2c14 right)
		

		;; r2c14 - wall
		(not (is-clear r2c14))
		(move-dir r2c14 r1c14 up)
		(move-dir r2c14 r3c14 down)
		(move-dir r2c14 r2c13 left)
		(move-dir r2c14 r2c15 right)
		

		;; r2c15 - empty
		(is-clear r2c15)
		(move-dir r2c15 r1c15 up)
		(move-dir r2c15 r3c15 down)
		(move-dir r2c15 r2c14 left)
		(move-dir r2c15 r2c16 right)
		

		;; r2c16 - slipper_floor
		(is-clear r2c16)
		(is-slippery r2c16)
		(move-dir r2c16 r1c16 up)
		(move-dir r2c16 r3c16 down)
		(move-dir r2c16 r2c15 left)
		(move-dir r2c16 r2c17 right)
		

		;; r2c17 - goal
		(is-clear r2c17)
		(is-goal r2c17)
		(move-dir r2c17 r1c17 up)
		(move-dir r2c17 r3c17 down)
		(move-dir r2c17 r2c16 left)
		(move-dir r2c17 r2c18 right)
		

		;; r2c18 - wall
		(not (is-clear r2c18))
		(move-dir r2c18 r1c18 up)
		(move-dir r2c18 r3c18 down)
		(move-dir r2c18 r2c17 left)
		(move-dir r2c18 r2c19 right)
		

		;; r2c19 - wall
		(not (is-clear r2c19))
		(move-dir r2c19 r1c19 up)
		(move-dir r2c19 r3c19 down)
		(move-dir r2c19 r2c18 left)
		

		;; r3c0 - wall
		(not (is-clear r3c0))
		(move-dir r3c0 r2c0 up)
		(move-dir r3c0 r4c0 down)
		(move-dir r3c0 r3c1 right)
		

		;; r3c1 - empty
		(is-clear r3c1)
		(move-dir r3c1 r2c1 up)
		(move-dir r3c1 r4c1 down)
		(move-dir r3c1 r3c0 left)
		(move-dir r3c1 r3c2 right)
		

		;; r3c2 - wall
		(not (is-clear r3c2))
		(move-dir r3c2 r2c2 up)
		(move-dir r3c2 r4c2 down)
		(move-dir r3c2 r3c1 left)
		(move-dir r3c2 r3c3 right)
		

		;; r3c3 - player
		(player-at r3c3)
		(alive)
		(move-dir r3c3 r2c3 up)
		(move-dir r3c3 r4c3 down)
		(move-dir r3c3 r3c2 left)
		(move-dir r3c3 r3c4 right)
		

		;; r3c4 - box
		(box-at box_0 r3c4)
		(move-dir r3c4 r2c4 up)
		(move-dir r3c4 r4c4 down)
		(move-dir r3c4 r3c3 left)
		(move-dir r3c4 r3c5 right)
		

		;; r3c5 - goal_on_slipper_floor
		(is-clear r3c5)
		(is-slippery r3c5)
		(is-goal r3c5)
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
		

		;; r3c7 - empty
		(is-clear r3c7)
		(move-dir r3c7 r2c7 up)
		(move-dir r3c7 r4c7 down)
		(move-dir r3c7 r3c6 left)
		(move-dir r3c7 r3c8 right)
		

		;; r3c8 - wall
		(not (is-clear r3c8))
		(move-dir r3c8 r2c8 up)
		(move-dir r3c8 r4c8 down)
		(move-dir r3c8 r3c7 left)
		(move-dir r3c8 r3c9 right)
		

		;; r3c9 - empty
		(is-clear r3c9)
		(move-dir r3c9 r2c9 up)
		(move-dir r3c9 r4c9 down)
		(move-dir r3c9 r3c8 left)
		(move-dir r3c9 r3c10 right)
		

		;; r3c10 - box
		(box-at box_1 r3c10)
		(move-dir r3c10 r2c10 up)
		(move-dir r3c10 r4c10 down)
		(move-dir r3c10 r3c9 left)
		(move-dir r3c10 r3c11 right)
		

		;; r3c11 - goal_on_slipper_floor
		(is-clear r3c11)
		(is-slippery r3c11)
		(is-goal r3c11)
		(move-dir r3c11 r2c11 up)
		(move-dir r3c11 r4c11 down)
		(move-dir r3c11 r3c10 left)
		(move-dir r3c11 r3c12 right)
		

		;; r3c12 - empty
		(is-clear r3c12)
		(move-dir r3c12 r2c12 up)
		(move-dir r3c12 r4c12 down)
		(move-dir r3c12 r3c11 left)
		(move-dir r3c12 r3c13 right)
		

		;; r3c13 - empty
		(is-clear r3c13)
		(move-dir r3c13 r2c13 up)
		(move-dir r3c13 r4c13 down)
		(move-dir r3c13 r3c12 left)
		(move-dir r3c13 r3c14 right)
		

		;; r3c14 - wall
		(not (is-clear r3c14))
		(move-dir r3c14 r2c14 up)
		(move-dir r3c14 r4c14 down)
		(move-dir r3c14 r3c13 left)
		(move-dir r3c14 r3c15 right)
		

		;; r3c15 - empty
		(is-clear r3c15)
		(move-dir r3c15 r2c15 up)
		(move-dir r3c15 r4c15 down)
		(move-dir r3c15 r3c14 left)
		(move-dir r3c15 r3c16 right)
		

		;; r3c16 - box
		(box-at box_2 r3c16)
		(move-dir r3c16 r2c16 up)
		(move-dir r3c16 r4c16 down)
		(move-dir r3c16 r3c15 left)
		(move-dir r3c16 r3c17 right)
		

		;; r3c17 - goal_on_slipper_floor
		(is-clear r3c17)
		(is-slippery r3c17)
		(is-goal r3c17)
		(move-dir r3c17 r2c17 up)
		(move-dir r3c17 r4c17 down)
		(move-dir r3c17 r3c16 left)
		(move-dir r3c17 r3c18 right)
		

		;; r3c18 - empty
		(is-clear r3c18)
		(move-dir r3c18 r2c18 up)
		(move-dir r3c18 r4c18 down)
		(move-dir r3c18 r3c17 left)
		(move-dir r3c18 r3c19 right)
		

		;; r3c19 - wall
		(not (is-clear r3c19))
		(move-dir r3c19 r2c19 up)
		(move-dir r3c19 r4c19 down)
		(move-dir r3c19 r3c18 left)
		

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
		

		;; r4c2 - wall
		(not (is-clear r4c2))
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
		

		;; r4c4 - empty
		(is-clear r4c4)
		(move-dir r4c4 r3c4 up)
		(move-dir r4c4 r5c4 down)
		(move-dir r4c4 r4c3 left)
		(move-dir r4c4 r4c5 right)
		

		;; r4c5 - slipper_floor
		(is-clear r4c5)
		(is-slippery r4c5)
		(move-dir r4c5 r3c5 up)
		(move-dir r4c5 r5c5 down)
		(move-dir r4c5 r4c4 left)
		(move-dir r4c5 r4c6 right)
		

		;; r4c6 - box
		(box-at box_3 r4c6)
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
		(move-dir r4c8 r4c9 right)
		

		;; r4c9 - empty
		(is-clear r4c9)
		(move-dir r4c9 r3c9 up)
		(move-dir r4c9 r5c9 down)
		(move-dir r4c9 r4c8 left)
		(move-dir r4c9 r4c10 right)
		

		;; r4c10 - empty
		(is-clear r4c10)
		(move-dir r4c10 r3c10 up)
		(move-dir r4c10 r5c10 down)
		(move-dir r4c10 r4c9 left)
		(move-dir r4c10 r4c11 right)
		

		;; r4c11 - slipper_floor
		(is-clear r4c11)
		(is-slippery r4c11)
		(move-dir r4c11 r3c11 up)
		(move-dir r4c11 r5c11 down)
		(move-dir r4c11 r4c10 left)
		(move-dir r4c11 r4c12 right)
		

		;; r4c12 - box
		(box-at box_4 r4c12)
		(move-dir r4c12 r3c12 up)
		(move-dir r4c12 r5c12 down)
		(move-dir r4c12 r4c11 left)
		(move-dir r4c12 r4c13 right)
		

		;; r4c13 - wall
		(not (is-clear r4c13))
		(move-dir r4c13 r3c13 up)
		(move-dir r4c13 r5c13 down)
		(move-dir r4c13 r4c12 left)
		(move-dir r4c13 r4c14 right)
		

		;; r4c14 - wall
		(not (is-clear r4c14))
		(move-dir r4c14 r3c14 up)
		(move-dir r4c14 r5c14 down)
		(move-dir r4c14 r4c13 left)
		(move-dir r4c14 r4c15 right)
		

		;; r4c15 - empty
		(is-clear r4c15)
		(move-dir r4c15 r3c15 up)
		(move-dir r4c15 r5c15 down)
		(move-dir r4c15 r4c14 left)
		(move-dir r4c15 r4c16 right)
		

		;; r4c16 - slipper_floor
		(is-clear r4c16)
		(is-slippery r4c16)
		(move-dir r4c16 r3c16 up)
		(move-dir r4c16 r5c16 down)
		(move-dir r4c16 r4c15 left)
		(move-dir r4c16 r4c17 right)
		

		;; r4c17 - box
		(box-at box_5 r4c17)
		(move-dir r4c17 r3c17 up)
		(move-dir r4c17 r5c17 down)
		(move-dir r4c17 r4c16 left)
		(move-dir r4c17 r4c18 right)
		

		;; r4c18 - wall
		(not (is-clear r4c18))
		(move-dir r4c18 r3c18 up)
		(move-dir r4c18 r5c18 down)
		(move-dir r4c18 r4c17 left)
		(move-dir r4c18 r4c19 right)
		

		;; r4c19 - wall
		(not (is-clear r4c19))
		(move-dir r4c19 r3c19 up)
		(move-dir r4c19 r5c19 down)
		(move-dir r4c19 r4c18 left)
		

		;; r5c0 - wall
		(not (is-clear r5c0))
		(move-dir r5c0 r4c0 up)
		(move-dir r5c0 r6c0 down)
		(move-dir r5c0 r5c1 right)
		

		;; r5c1 - empty
		(is-clear r5c1)
		(move-dir r5c1 r4c1 up)
		(move-dir r5c1 r6c1 down)
		(move-dir r5c1 r5c0 left)
		(move-dir r5c1 r5c2 right)
		

		;; r5c2 - empty
		(is-clear r5c2)
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
		

		;; r5c6 - empty
		(is-clear r5c6)
		(move-dir r5c6 r4c6 up)
		(move-dir r5c6 r6c6 down)
		(move-dir r5c6 r5c5 left)
		(move-dir r5c6 r5c7 right)
		

		;; r5c7 - empty
		(is-clear r5c7)
		(move-dir r5c7 r4c7 up)
		(move-dir r5c7 r6c7 down)
		(move-dir r5c7 r5c6 left)
		(move-dir r5c7 r5c8 right)
		

		;; r5c8 - empty
		(is-clear r5c8)
		(move-dir r5c8 r4c8 up)
		(move-dir r5c8 r6c8 down)
		(move-dir r5c8 r5c7 left)
		(move-dir r5c8 r5c9 right)
		

		;; r5c9 - empty
		(is-clear r5c9)
		(move-dir r5c9 r4c9 up)
		(move-dir r5c9 r6c9 down)
		(move-dir r5c9 r5c8 left)
		(move-dir r5c9 r5c10 right)
		

		;; r5c10 - empty
		(is-clear r5c10)
		(move-dir r5c10 r4c10 up)
		(move-dir r5c10 r6c10 down)
		(move-dir r5c10 r5c9 left)
		(move-dir r5c10 r5c11 right)
		

		;; r5c11 - empty
		(is-clear r5c11)
		(move-dir r5c11 r4c11 up)
		(move-dir r5c11 r6c11 down)
		(move-dir r5c11 r5c10 left)
		(move-dir r5c11 r5c12 right)
		

		;; r5c12 - empty
		(is-clear r5c12)
		(move-dir r5c12 r4c12 up)
		(move-dir r5c12 r6c12 down)
		(move-dir r5c12 r5c11 left)
		(move-dir r5c12 r5c13 right)
		

		;; r5c13 - wall
		(not (is-clear r5c13))
		(move-dir r5c13 r4c13 up)
		(move-dir r5c13 r6c13 down)
		(move-dir r5c13 r5c12 left)
		(move-dir r5c13 r5c14 right)
		

		;; r5c14 - wall
		(not (is-clear r5c14))
		(move-dir r5c14 r4c14 up)
		(move-dir r5c14 r6c14 down)
		(move-dir r5c14 r5c13 left)
		(move-dir r5c14 r5c15 right)
		

		;; r5c15 - empty
		(is-clear r5c15)
		(move-dir r5c15 r4c15 up)
		(move-dir r5c15 r6c15 down)
		(move-dir r5c15 r5c14 left)
		(move-dir r5c15 r5c16 right)
		

		;; r5c16 - empty
		(is-clear r5c16)
		(move-dir r5c16 r4c16 up)
		(move-dir r5c16 r6c16 down)
		(move-dir r5c16 r5c15 left)
		(move-dir r5c16 r5c17 right)
		

		;; r5c17 - empty
		(is-clear r5c17)
		(move-dir r5c17 r4c17 up)
		(move-dir r5c17 r6c17 down)
		(move-dir r5c17 r5c16 left)
		(move-dir r5c17 r5c18 right)
		

		;; r5c18 - wall
		(not (is-clear r5c18))
		(move-dir r5c18 r4c18 up)
		(move-dir r5c18 r6c18 down)
		(move-dir r5c18 r5c17 left)
		(move-dir r5c18 r5c19 right)
		

		;; r5c19 - wall
		(not (is-clear r5c19))
		(move-dir r5c19 r4c19 up)
		(move-dir r5c19 r6c19 down)
		(move-dir r5c19 r5c18 left)
		

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
		(move-dir r6c8 r6c9 right)
		

		;; r6c9 - wall
		(not (is-clear r6c9))
		(move-dir r6c9 r5c9 up)
		(move-dir r6c9 r6c8 left)
		(move-dir r6c9 r6c10 right)
		

		;; r6c10 - wall
		(not (is-clear r6c10))
		(move-dir r6c10 r5c10 up)
		(move-dir r6c10 r6c9 left)
		(move-dir r6c10 r6c11 right)
		

		;; r6c11 - wall
		(not (is-clear r6c11))
		(move-dir r6c11 r5c11 up)
		(move-dir r6c11 r6c10 left)
		(move-dir r6c11 r6c12 right)
		

		;; r6c12 - wall
		(not (is-clear r6c12))
		(move-dir r6c12 r5c12 up)
		(move-dir r6c12 r6c11 left)
		(move-dir r6c12 r6c13 right)
		

		;; r6c13 - wall
		(not (is-clear r6c13))
		(move-dir r6c13 r5c13 up)
		(move-dir r6c13 r6c12 left)
		(move-dir r6c13 r6c14 right)
		

		;; r6c14 - wall
		(not (is-clear r6c14))
		(move-dir r6c14 r5c14 up)
		(move-dir r6c14 r6c13 left)
		(move-dir r6c14 r6c15 right)
		

		;; r6c15 - wall
		(not (is-clear r6c15))
		(move-dir r6c15 r5c15 up)
		(move-dir r6c15 r6c14 left)
		(move-dir r6c15 r6c16 right)
		

		;; r6c16 - wall
		(not (is-clear r6c16))
		(move-dir r6c16 r5c16 up)
		(move-dir r6c16 r6c15 left)
		(move-dir r6c16 r6c17 right)
		

		;; r6c17 - wall
		(not (is-clear r6c17))
		(move-dir r6c17 r5c17 up)
		(move-dir r6c17 r6c16 left)
		(move-dir r6c17 r6c18 right)
		

		;; r6c18 - wall
		(not (is-clear r6c18))
		(move-dir r6c18 r5c18 up)
		(move-dir r6c18 r6c17 left)
		(move-dir r6c18 r6c19 right)
		

		;; r6c19 - wall
		(not (is-clear r6c19))
		(move-dir r6c19 r5c19 up)
		(move-dir r6c19 r6c18 left)

	)
	(:goal
		(and
			(at-goal box_0)
			(at-goal box_1)
			(at-goal box_2)
			(at-goal box_3)
			(at-goal box_4)
			(at-goal box_5)
		)
	)
)
