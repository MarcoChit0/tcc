(define (problem c1_2-sokoban-non-deterministic)
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
		r7c0 - location
		r7c1 - location
		r7c2 - location
		r7c3 - location
		r7c4 - location
		r7c5 - location
		r7c6 - location
		r7c7 - location
		r7c8 - location
		r7c9 - location
		r7c10 - location
		r8c0 - location
		r8c1 - location
		r8c2 - location
		r8c3 - location
		r8c4 - location
		r8c5 - location
		r8c6 - location
		r8c7 - location
		r8c8 - location
		r8c9 - location
		r8c10 - location
		r9c0 - location
		r9c1 - location
		r9c2 - location
		r9c3 - location
		r9c4 - location
		r9c5 - location
		r9c6 - location
		r9c7 - location
		r9c8 - location
		r9c9 - location
		r9c10 - location
		r10c0 - location
		r10c1 - location
		r10c2 - location
		r10c3 - location
		r10c4 - location
		r10c5 - location
		r10c6 - location
		r10c7 - location
		r10c8 - location
		r10c9 - location
		r10c10 - location
		up - direction
		down - direction
		left - direction
		right - direction
		box_0 - box
		box_1 - box
		box_2 - box
		box_3 - box

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
		

		;; r1c6 - empty
		(is-clear r1c6)
		(move-dir r1c6 r0c6 up)
		(move-dir r1c6 r2c6 down)
		(move-dir r1c6 r1c5 left)
		(move-dir r1c6 r1c7 right)
		

		;; r1c7 - empty
		(is-clear r1c7)
		(move-dir r1c7 r0c7 up)
		(move-dir r1c7 r2c7 down)
		(move-dir r1c7 r1c6 left)
		(move-dir r1c7 r1c8 right)
		

		;; r1c8 - empty
		(is-clear r1c8)
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
		

		;; r1c10 - wall
		(not (is-clear r1c10))
		(move-dir r1c10 r0c10 up)
		(move-dir r1c10 r2c10 down)
		(move-dir r1c10 r1c9 left)
		

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
		

		;; r2c2 - player
		(player-at r2c2)
		(alive)
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
		

		;; r2c4 - empty
		(is-clear r2c4)
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
		

		;; r2c7 - empty
		(is-clear r2c7)
		(move-dir r2c7 r1c7 up)
		(move-dir r2c7 r3c7 down)
		(move-dir r2c7 r2c6 left)
		(move-dir r2c7 r2c8 right)
		

		;; r2c8 - empty
		(is-clear r2c8)
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
		

		;; r2c10 - wall
		(not (is-clear r2c10))
		(move-dir r2c10 r1c10 up)
		(move-dir r2c10 r3c10 down)
		(move-dir r2c10 r2c9 left)
		

		;; r3c0 - wall
		(not (is-clear r3c0))
		(move-dir r3c0 r2c0 up)
		(move-dir r3c0 r4c0 down)
		(move-dir r3c0 r3c1 right)
		

		;; r3c1 - slipper_floor
		(is-clear r3c1)
		(is-slippery r3c1)
		(move-dir r3c1 r2c1 up)
		(move-dir r3c1 r4c1 down)
		(move-dir r3c1 r3c0 left)
		(move-dir r3c1 r3c2 right)
		

		;; r3c2 - box_on_slipper_floor
		(box-at box_0 r3c2)
		(is-slippery r3c2)
		(move-dir r3c2 r2c2 up)
		(move-dir r3c2 r4c2 down)
		(move-dir r3c2 r3c1 left)
		(move-dir r3c2 r3c3 right)
		

		;; r3c3 - slipper_floor
		(is-clear r3c3)
		(is-slippery r3c3)
		(move-dir r3c3 r2c3 up)
		(move-dir r3c3 r4c3 down)
		(move-dir r3c3 r3c2 left)
		(move-dir r3c3 r3c4 right)
		

		;; r3c4 - slipper_floor
		(is-clear r3c4)
		(is-slippery r3c4)
		(move-dir r3c4 r2c4 up)
		(move-dir r3c4 r4c4 down)
		(move-dir r3c4 r3c3 left)
		(move-dir r3c4 r3c5 right)
		

		;; r3c5 - empty
		(is-clear r3c5)
		(move-dir r3c5 r2c5 up)
		(move-dir r3c5 r4c5 down)
		(move-dir r3c5 r3c4 left)
		(move-dir r3c5 r3c6 right)
		

		;; r3c6 - slipper_floor
		(is-clear r3c6)
		(is-slippery r3c6)
		(move-dir r3c6 r2c6 up)
		(move-dir r3c6 r4c6 down)
		(move-dir r3c6 r3c5 left)
		(move-dir r3c6 r3c7 right)
		

		;; r3c7 - slipper_floor
		(is-clear r3c7)
		(is-slippery r3c7)
		(move-dir r3c7 r2c7 up)
		(move-dir r3c7 r4c7 down)
		(move-dir r3c7 r3c6 left)
		(move-dir r3c7 r3c8 right)
		

		;; r3c8 - slipper_floor
		(is-clear r3c8)
		(is-slippery r3c8)
		(move-dir r3c8 r2c8 up)
		(move-dir r3c8 r4c8 down)
		(move-dir r3c8 r3c7 left)
		(move-dir r3c8 r3c9 right)
		

		;; r3c9 - slipper_floor
		(is-clear r3c9)
		(is-slippery r3c9)
		(move-dir r3c9 r2c9 up)
		(move-dir r3c9 r4c9 down)
		(move-dir r3c9 r3c8 left)
		(move-dir r3c9 r3c10 right)
		

		;; r3c10 - wall
		(not (is-clear r3c10))
		(move-dir r3c10 r2c10 up)
		(move-dir r3c10 r4c10 down)
		(move-dir r3c10 r3c9 left)
		

		;; r4c0 - wall
		(not (is-clear r4c0))
		(move-dir r4c0 r3c0 up)
		(move-dir r4c0 r5c0 down)
		(move-dir r4c0 r4c1 right)
		

		;; r4c1 - slipper_floor
		(is-clear r4c1)
		(is-slippery r4c1)
		(move-dir r4c1 r3c1 up)
		(move-dir r4c1 r5c1 down)
		(move-dir r4c1 r4c0 left)
		(move-dir r4c1 r4c2 right)
		

		;; r4c2 - goal_on_slipper_floor
		(is-clear r4c2)
		(is-slippery r4c2)
		(is-goal r4c2)
		(move-dir r4c2 r3c2 up)
		(move-dir r4c2 r5c2 down)
		(move-dir r4c2 r4c1 left)
		(move-dir r4c2 r4c3 right)
		

		;; r4c3 - slipper_floor
		(is-clear r4c3)
		(is-slippery r4c3)
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
		

		;; r4c6 - slipper_floor
		(is-clear r4c6)
		(is-slippery r4c6)
		(move-dir r4c6 r3c6 up)
		(move-dir r4c6 r5c6 down)
		(move-dir r4c6 r4c5 left)
		(move-dir r4c6 r4c7 right)
		

		;; r4c7 - slipper_floor
		(is-clear r4c7)
		(is-slippery r4c7)
		(move-dir r4c7 r3c7 up)
		(move-dir r4c7 r5c7 down)
		(move-dir r4c7 r4c6 left)
		(move-dir r4c7 r4c8 right)
		

		;; r4c8 - slipper_floor
		(is-clear r4c8)
		(is-slippery r4c8)
		(move-dir r4c8 r3c8 up)
		(move-dir r4c8 r5c8 down)
		(move-dir r4c8 r4c7 left)
		(move-dir r4c8 r4c9 right)
		

		;; r4c9 - slipper_floor
		(is-clear r4c9)
		(is-slippery r4c9)
		(move-dir r4c9 r3c9 up)
		(move-dir r4c9 r5c9 down)
		(move-dir r4c9 r4c8 left)
		(move-dir r4c9 r4c10 right)
		

		;; r4c10 - wall
		(not (is-clear r4c10))
		(move-dir r4c10 r3c10 up)
		(move-dir r4c10 r5c10 down)
		(move-dir r4c10 r4c9 left)
		

		;; r5c0 - wall
		(not (is-clear r5c0))
		(move-dir r5c0 r4c0 up)
		(move-dir r5c0 r6c0 down)
		(move-dir r5c0 r5c1 right)
		

		;; r5c1 - slipper_floor
		(is-clear r5c1)
		(is-slippery r5c1)
		(move-dir r5c1 r4c1 up)
		(move-dir r5c1 r6c1 down)
		(move-dir r5c1 r5c0 left)
		(move-dir r5c1 r5c2 right)
		

		;; r5c2 - slipper_floor
		(is-clear r5c2)
		(is-slippery r5c2)
		(move-dir r5c2 r4c2 up)
		(move-dir r5c2 r6c2 down)
		(move-dir r5c2 r5c1 left)
		(move-dir r5c2 r5c3 right)
		

		;; r5c3 - box_on_slipper_floor
		(box-at box_1 r5c3)
		(is-slippery r5c3)
		(move-dir r5c3 r4c3 up)
		(move-dir r5c3 r6c3 down)
		(move-dir r5c3 r5c2 left)
		(move-dir r5c3 r5c4 right)
		

		;; r5c4 - slipper_floor
		(is-clear r5c4)
		(is-slippery r5c4)
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
		

		;; r5c6 - slipper_floor
		(is-clear r5c6)
		(is-slippery r5c6)
		(move-dir r5c6 r4c6 up)
		(move-dir r5c6 r6c6 down)
		(move-dir r5c6 r5c5 left)
		(move-dir r5c6 r5c7 right)
		

		;; r5c7 - box_on_slipper_floor
		(box-at box_2 r5c7)
		(is-slippery r5c7)
		(move-dir r5c7 r4c7 up)
		(move-dir r5c7 r6c7 down)
		(move-dir r5c7 r5c6 left)
		(move-dir r5c7 r5c8 right)
		

		;; r5c8 - goal_on_slipper_floor
		(is-clear r5c8)
		(is-slippery r5c8)
		(is-goal r5c8)
		(move-dir r5c8 r4c8 up)
		(move-dir r5c8 r6c8 down)
		(move-dir r5c8 r5c7 left)
		(move-dir r5c8 r5c9 right)
		

		;; r5c9 - slipper_floor
		(is-clear r5c9)
		(is-slippery r5c9)
		(move-dir r5c9 r4c9 up)
		(move-dir r5c9 r6c9 down)
		(move-dir r5c9 r5c8 left)
		(move-dir r5c9 r5c10 right)
		

		;; r5c10 - wall
		(not (is-clear r5c10))
		(move-dir r5c10 r4c10 up)
		(move-dir r5c10 r6c10 down)
		(move-dir r5c10 r5c9 left)
		

		;; r6c0 - wall
		(not (is-clear r6c0))
		(move-dir r6c0 r5c0 up)
		(move-dir r6c0 r7c0 down)
		(move-dir r6c0 r6c1 right)
		

		;; r6c1 - slipper_floor
		(is-clear r6c1)
		(is-slippery r6c1)
		(move-dir r6c1 r5c1 up)
		(move-dir r6c1 r7c1 down)
		(move-dir r6c1 r6c0 left)
		(move-dir r6c1 r6c2 right)
		

		;; r6c2 - goal_on_slipper_floor
		(is-clear r6c2)
		(is-slippery r6c2)
		(is-goal r6c2)
		(move-dir r6c2 r5c2 up)
		(move-dir r6c2 r7c2 down)
		(move-dir r6c2 r6c1 left)
		(move-dir r6c2 r6c3 right)
		

		;; r6c3 - slipper_floor
		(is-clear r6c3)
		(is-slippery r6c3)
		(move-dir r6c3 r5c3 up)
		(move-dir r6c3 r7c3 down)
		(move-dir r6c3 r6c2 left)
		(move-dir r6c3 r6c4 right)
		

		;; r6c4 - slipper_floor
		(is-clear r6c4)
		(is-slippery r6c4)
		(move-dir r6c4 r5c4 up)
		(move-dir r6c4 r7c4 down)
		(move-dir r6c4 r6c3 left)
		(move-dir r6c4 r6c5 right)
		

		;; r6c5 - empty
		(is-clear r6c5)
		(move-dir r6c5 r5c5 up)
		(move-dir r6c5 r7c5 down)
		(move-dir r6c5 r6c4 left)
		(move-dir r6c5 r6c6 right)
		

		;; r6c6 - goal_on_slipper_floor
		(is-clear r6c6)
		(is-slippery r6c6)
		(is-goal r6c6)
		(move-dir r6c6 r5c6 up)
		(move-dir r6c6 r7c6 down)
		(move-dir r6c6 r6c5 left)
		(move-dir r6c6 r6c7 right)
		

		;; r6c7 - slipper_floor
		(is-clear r6c7)
		(is-slippery r6c7)
		(move-dir r6c7 r5c7 up)
		(move-dir r6c7 r7c7 down)
		(move-dir r6c7 r6c6 left)
		(move-dir r6c7 r6c8 right)
		

		;; r6c8 - slipper_floor
		(is-clear r6c8)
		(is-slippery r6c8)
		(move-dir r6c8 r5c8 up)
		(move-dir r6c8 r7c8 down)
		(move-dir r6c8 r6c7 left)
		(move-dir r6c8 r6c9 right)
		

		;; r6c9 - slipper_floor
		(is-clear r6c9)
		(is-slippery r6c9)
		(move-dir r6c9 r5c9 up)
		(move-dir r6c9 r7c9 down)
		(move-dir r6c9 r6c8 left)
		(move-dir r6c9 r6c10 right)
		

		;; r6c10 - wall
		(not (is-clear r6c10))
		(move-dir r6c10 r5c10 up)
		(move-dir r6c10 r7c10 down)
		(move-dir r6c10 r6c9 left)
		

		;; r7c0 - wall
		(not (is-clear r7c0))
		(move-dir r7c0 r6c0 up)
		(move-dir r7c0 r8c0 down)
		(move-dir r7c0 r7c1 right)
		

		;; r7c1 - slipper_floor
		(is-clear r7c1)
		(is-slippery r7c1)
		(move-dir r7c1 r6c1 up)
		(move-dir r7c1 r8c1 down)
		(move-dir r7c1 r7c0 left)
		(move-dir r7c1 r7c2 right)
		

		;; r7c2 - slipper_floor
		(is-clear r7c2)
		(is-slippery r7c2)
		(move-dir r7c2 r6c2 up)
		(move-dir r7c2 r8c2 down)
		(move-dir r7c2 r7c1 left)
		(move-dir r7c2 r7c3 right)
		

		;; r7c3 - slipper_floor
		(is-clear r7c3)
		(is-slippery r7c3)
		(move-dir r7c3 r6c3 up)
		(move-dir r7c3 r8c3 down)
		(move-dir r7c3 r7c2 left)
		(move-dir r7c3 r7c4 right)
		

		;; r7c4 - slipper_floor
		(is-clear r7c4)
		(is-slippery r7c4)
		(move-dir r7c4 r6c4 up)
		(move-dir r7c4 r8c4 down)
		(move-dir r7c4 r7c3 left)
		(move-dir r7c4 r7c5 right)
		

		;; r7c5 - empty
		(is-clear r7c5)
		(move-dir r7c5 r6c5 up)
		(move-dir r7c5 r8c5 down)
		(move-dir r7c5 r7c4 left)
		(move-dir r7c5 r7c6 right)
		

		;; r7c6 - slipper_floor
		(is-clear r7c6)
		(is-slippery r7c6)
		(move-dir r7c6 r6c6 up)
		(move-dir r7c6 r8c6 down)
		(move-dir r7c6 r7c5 left)
		(move-dir r7c6 r7c7 right)
		

		;; r7c7 - slipper_floor
		(is-clear r7c7)
		(is-slippery r7c7)
		(move-dir r7c7 r6c7 up)
		(move-dir r7c7 r8c7 down)
		(move-dir r7c7 r7c6 left)
		(move-dir r7c7 r7c8 right)
		

		;; r7c8 - slipper_floor
		(is-clear r7c8)
		(is-slippery r7c8)
		(move-dir r7c8 r6c8 up)
		(move-dir r7c8 r8c8 down)
		(move-dir r7c8 r7c7 left)
		(move-dir r7c8 r7c9 right)
		

		;; r7c9 - slipper_floor
		(is-clear r7c9)
		(is-slippery r7c9)
		(move-dir r7c9 r6c9 up)
		(move-dir r7c9 r8c9 down)
		(move-dir r7c9 r7c8 left)
		(move-dir r7c9 r7c10 right)
		

		;; r7c10 - wall
		(not (is-clear r7c10))
		(move-dir r7c10 r6c10 up)
		(move-dir r7c10 r8c10 down)
		(move-dir r7c10 r7c9 left)
		

		;; r8c0 - wall
		(not (is-clear r8c0))
		(move-dir r8c0 r7c0 up)
		(move-dir r8c0 r9c0 down)
		(move-dir r8c0 r8c1 right)
		

		;; r8c1 - empty
		(is-clear r8c1)
		(move-dir r8c1 r7c1 up)
		(move-dir r8c1 r9c1 down)
		(move-dir r8c1 r8c0 left)
		(move-dir r8c1 r8c2 right)
		

		;; r8c2 - empty
		(is-clear r8c2)
		(move-dir r8c2 r7c2 up)
		(move-dir r8c2 r9c2 down)
		(move-dir r8c2 r8c1 left)
		(move-dir r8c2 r8c3 right)
		

		;; r8c3 - empty
		(is-clear r8c3)
		(move-dir r8c3 r7c3 up)
		(move-dir r8c3 r9c3 down)
		(move-dir r8c3 r8c2 left)
		(move-dir r8c3 r8c4 right)
		

		;; r8c4 - empty
		(is-clear r8c4)
		(move-dir r8c4 r7c4 up)
		(move-dir r8c4 r9c4 down)
		(move-dir r8c4 r8c3 left)
		(move-dir r8c4 r8c5 right)
		

		;; r8c5 - empty
		(is-clear r8c5)
		(move-dir r8c5 r7c5 up)
		(move-dir r8c5 r9c5 down)
		(move-dir r8c5 r8c4 left)
		(move-dir r8c5 r8c6 right)
		

		;; r8c6 - empty
		(is-clear r8c6)
		(move-dir r8c6 r7c6 up)
		(move-dir r8c6 r9c6 down)
		(move-dir r8c6 r8c5 left)
		(move-dir r8c6 r8c7 right)
		

		;; r8c7 - empty
		(is-clear r8c7)
		(move-dir r8c7 r7c7 up)
		(move-dir r8c7 r9c7 down)
		(move-dir r8c7 r8c6 left)
		(move-dir r8c7 r8c8 right)
		

		;; r8c8 - box
		(box-at box_3 r8c8)
		(move-dir r8c8 r7c8 up)
		(move-dir r8c8 r9c8 down)
		(move-dir r8c8 r8c7 left)
		(move-dir r8c8 r8c9 right)
		

		;; r8c9 - empty
		(is-clear r8c9)
		(move-dir r8c9 r7c9 up)
		(move-dir r8c9 r9c9 down)
		(move-dir r8c9 r8c8 left)
		(move-dir r8c9 r8c10 right)
		

		;; r8c10 - wall
		(not (is-clear r8c10))
		(move-dir r8c10 r7c10 up)
		(move-dir r8c10 r9c10 down)
		(move-dir r8c10 r8c9 left)
		

		;; r9c0 - wall
		(not (is-clear r9c0))
		(move-dir r9c0 r8c0 up)
		(move-dir r9c0 r10c0 down)
		(move-dir r9c0 r9c1 right)
		

		;; r9c1 - boots
		(boots-at r9c1)
		(move-dir r9c1 r8c1 up)
		(move-dir r9c1 r10c1 down)
		(move-dir r9c1 r9c0 left)
		(move-dir r9c1 r9c2 right)
		

		;; r9c2 - empty
		(is-clear r9c2)
		(move-dir r9c2 r8c2 up)
		(move-dir r9c2 r10c2 down)
		(move-dir r9c2 r9c1 left)
		(move-dir r9c2 r9c3 right)
		

		;; r9c3 - empty
		(is-clear r9c3)
		(move-dir r9c3 r8c3 up)
		(move-dir r9c3 r10c3 down)
		(move-dir r9c3 r9c2 left)
		(move-dir r9c3 r9c4 right)
		

		;; r9c4 - empty
		(is-clear r9c4)
		(move-dir r9c4 r8c4 up)
		(move-dir r9c4 r10c4 down)
		(move-dir r9c4 r9c3 left)
		(move-dir r9c4 r9c5 right)
		

		;; r9c5 - empty
		(is-clear r9c5)
		(move-dir r9c5 r8c5 up)
		(move-dir r9c5 r10c5 down)
		(move-dir r9c5 r9c4 left)
		(move-dir r9c5 r9c6 right)
		

		;; r9c6 - empty
		(is-clear r9c6)
		(move-dir r9c6 r8c6 up)
		(move-dir r9c6 r10c6 down)
		(move-dir r9c6 r9c5 left)
		(move-dir r9c6 r9c7 right)
		

		;; r9c7 - empty
		(is-clear r9c7)
		(move-dir r9c7 r8c7 up)
		(move-dir r9c7 r10c7 down)
		(move-dir r9c7 r9c6 left)
		(move-dir r9c7 r9c8 right)
		

		;; r9c8 - empty
		(is-clear r9c8)
		(move-dir r9c8 r8c8 up)
		(move-dir r9c8 r10c8 down)
		(move-dir r9c8 r9c7 left)
		(move-dir r9c8 r9c9 right)
		

		;; r9c9 - empty
		(is-clear r9c9)
		(move-dir r9c9 r8c9 up)
		(move-dir r9c9 r10c9 down)
		(move-dir r9c9 r9c8 left)
		(move-dir r9c9 r9c10 right)
		

		;; r9c10 - wall
		(not (is-clear r9c10))
		(move-dir r9c10 r8c10 up)
		(move-dir r9c10 r10c10 down)
		(move-dir r9c10 r9c9 left)
		

		;; r10c0 - wall
		(not (is-clear r10c0))
		(move-dir r10c0 r9c0 up)
		(move-dir r10c0 r10c1 right)
		

		;; r10c1 - wall
		(not (is-clear r10c1))
		(move-dir r10c1 r9c1 up)
		(move-dir r10c1 r10c0 left)
		(move-dir r10c1 r10c2 right)
		

		;; r10c2 - wall
		(not (is-clear r10c2))
		(move-dir r10c2 r9c2 up)
		(move-dir r10c2 r10c1 left)
		(move-dir r10c2 r10c3 right)
		

		;; r10c3 - wall
		(not (is-clear r10c3))
		(move-dir r10c3 r9c3 up)
		(move-dir r10c3 r10c2 left)
		(move-dir r10c3 r10c4 right)
		

		;; r10c4 - wall
		(not (is-clear r10c4))
		(move-dir r10c4 r9c4 up)
		(move-dir r10c4 r10c3 left)
		(move-dir r10c4 r10c5 right)
		

		;; r10c5 - wall
		(not (is-clear r10c5))
		(move-dir r10c5 r9c5 up)
		(move-dir r10c5 r10c4 left)
		(move-dir r10c5 r10c6 right)
		

		;; r10c6 - wall
		(not (is-clear r10c6))
		(move-dir r10c6 r9c6 up)
		(move-dir r10c6 r10c5 left)
		(move-dir r10c6 r10c7 right)
		

		;; r10c7 - wall
		(not (is-clear r10c7))
		(move-dir r10c7 r9c7 up)
		(move-dir r10c7 r10c6 left)
		(move-dir r10c7 r10c8 right)
		

		;; r10c8 - wall
		(not (is-clear r10c8))
		(move-dir r10c8 r9c8 up)
		(move-dir r10c8 r10c7 left)
		(move-dir r10c8 r10c9 right)
		

		;; r10c9 - wall
		(not (is-clear r10c9))
		(move-dir r10c9 r9c9 up)
		(move-dir r10c9 r10c8 left)
		(move-dir r10c9 r10c10 right)
		

		;; r10c10 - wall
		(not (is-clear r10c10))
		(move-dir r10c10 r9c10 up)
		(move-dir r10c10 r10c9 left)

	)
	(:goal
		(and
			(at-goal box_0)
			(at-goal box_1)
			(at-goal box_2)
			(at-goal box_3)
		)
	)
)
