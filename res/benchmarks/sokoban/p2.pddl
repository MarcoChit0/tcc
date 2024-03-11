(define (problem p2-sokoban-non-deterministic)
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
		r5c0 - location
		r5c1 - location
		r5c2 - location
		r5c3 - location
		r5c4 - location
		r5c5 - location
		r5c6 - location
		r6c0 - location
		r6c1 - location
		r6c2 - location
		r6c3 - location
		r6c4 - location
		r6c5 - location
		r6c6 - location
		r7c0 - location
		r7c1 - location
		r7c2 - location
		r7c3 - location
		r7c4 - location
		r7c5 - location
		r7c6 - location
		r8c0 - location
		r8c1 - location
		r8c2 - location
		r8c3 - location
		r8c4 - location
		r8c5 - location
		r8c6 - location
		r9c0 - location
		r9c1 - location
		r9c2 - location
		r9c3 - location
		r9c4 - location
		r9c5 - location
		r9c6 - location
		up - direction
		down - direction
		left - direction
		right - direction

	)
	(:init
		(is-clear r1c1)
		(move-dir r1c1 r2c1 down)
		(move-dir r1c1 r1c2 right)
		(is-clear r1c2)
		(move-dir r1c2 r2c2 down)
		(move-dir r1c2 r1c1 left)
		(move-dir r1c2 r1c3 right)
		(is-clear r1c3)
		(move-dir r1c3 r2c3 down)
		(move-dir r1c3 r1c2 left)
		(move-dir r1c3 r1c4 right)
		(is-clear r1c4)
		(move-dir r1c4 r2c4 down)
		(move-dir r1c4 r1c3 left)
		(move-dir r1c4 r1c5 right)
		(is-clear r1c5)
		(move-dir r1c5 r2c5 down)
		(move-dir r1c5 r1c4 left)
		(is-clear r2c1)
		(move-dir r2c1 r1c1 up)
		(move-dir r2c1 r3c1 down)
		(move-dir r2c1 r2c2 right)
		(is-clear r2c2)
		(move-dir r2c2 r1c2 up)
		(move-dir r2c2 r2c1 left)
		(move-dir r2c2 r2c3 right)
		(is-clear r2c3)
		(move-dir r2c3 r1c3 up)
		(move-dir r2c3 r3c3 down)
		(move-dir r2c3 r2c2 left)
		(move-dir r2c3 r2c4 right)
		(is-clear r2c4)
		(move-dir r2c4 r1c4 up)
		(move-dir r2c4 r2c3 left)
		(move-dir r2c4 r2c5 right)
		(is-clear r2c5)
		(move-dir r2c5 r1c5 up)
		(move-dir r2c5 r3c5 down)
		(move-dir r2c5 r2c4 left)
		(is-clear r3c1)
		(move-dir r3c1 r2c1 up)
		(move-dir r3c1 r4c1 down)
		(stone-at r3c3)
		(move-dir r3c3 r2c3 up)
		(move-dir r3c3 r4c3 down)
		(is-clear r3c5)
		(move-dir r3c5 r2c5 up)
		(move-dir r3c5 r4c5 down)
		(is-goal r4c1)
		(is-clear r4c1)
		(move-dir r4c1 r3c1 up)
		(move-dir r4c1 r5c1 down)
		(player-at r4c3)
		(move-dir r4c3 r3c3 up)
		(move-dir r4c3 r5c3 down)
		(is-goal r4c5)
		(is-clear r4c5)
		(move-dir r4c5 r3c5 up)
		(move-dir r4c5 r5c5 down)
		(is-clear r5c1)
		(move-dir r5c1 r4c1 up)
		(move-dir r5c1 r6c1 down)
		(stone-at r5c3)
		(move-dir r5c3 r4c3 up)
		(move-dir r5c3 r6c3 down)
		(is-clear r5c5)
		(move-dir r5c5 r4c5 up)
		(move-dir r5c5 r6c5 down)
		(is-clear r6c1)
		(move-dir r6c1 r5c1 up)
		(move-dir r6c1 r7c1 down)
		(move-dir r6c1 r6c2 right)
		(is-clear r6c2)
		(move-dir r6c2 r7c2 down)
		(move-dir r6c2 r6c1 left)
		(move-dir r6c2 r6c3 right)
		(is-clear r6c3)
		(move-dir r6c3 r5c3 up)
		(move-dir r6c3 r7c3 down)
		(move-dir r6c3 r6c2 left)
		(move-dir r6c3 r6c4 right)
		(is-clear r6c4)
		(move-dir r6c4 r7c4 down)
		(move-dir r6c4 r6c3 left)
		(move-dir r6c4 r6c5 right)
		(is-clear r6c5)
		(move-dir r6c5 r5c5 up)
		(move-dir r6c5 r7c5 down)
		(move-dir r6c5 r6c4 left)
		(is-clear r7c1)
		(move-dir r7c1 r6c1 up)
		(move-dir r7c1 r8c1 down)
		(move-dir r7c1 r7c2 right)
		(is-clear r7c2)
		(move-dir r7c2 r6c2 up)
		(move-dir r7c2 r8c2 down)
		(move-dir r7c2 r7c1 left)
		(move-dir r7c2 r7c3 right)
		(is-clear r7c3)
		(move-dir r7c3 r6c3 up)
		(move-dir r7c3 r8c3 down)
		(move-dir r7c3 r7c2 left)
		(move-dir r7c3 r7c4 right)
		(is-clear r7c4)
		(move-dir r7c4 r6c4 up)
		(move-dir r7c4 r8c4 down)
		(move-dir r7c4 r7c3 left)
		(move-dir r7c4 r7c5 right)
		(is-clear r7c5)
		(move-dir r7c5 r6c5 up)
		(move-dir r7c5 r8c5 down)
		(move-dir r7c5 r7c4 left)
		(is-clear r8c1)
		(move-dir r8c1 r7c1 up)
		(move-dir r8c1 r8c2 right)
		(is-clear r8c2)
		(move-dir r8c2 r7c2 up)
		(move-dir r8c2 r8c1 left)
		(move-dir r8c2 r8c3 right)
		(is-clear r8c3)
		(move-dir r8c3 r7c3 up)
		(move-dir r8c3 r8c2 left)
		(move-dir r8c3 r8c4 right)
		(is-clear r8c4)
		(move-dir r8c4 r7c4 up)
		(move-dir r8c4 r8c3 left)
		(move-dir r8c4 r8c5 right)
		(is-clear r8c5)
		(move-dir r8c5 r7c5 up)
		(move-dir r8c5 r8c4 left)

	)
	(:goal
		(and
			(at-goal r4c1)
			(at-goal r4c5)
		)
	)
)
