(define (problem p3-rescue)
	(:domain rescue)
	(:objects
		0 - number
		1 - number
		2 - number
		3 - number
		4 - number
		5 - number
		l1 - location
		l2 - location
		l3 - location
		v1 - victim
		f1 - fire-unit
		m1 - medical-unit

	)
	(:init
		(clock 0)
		(not (clock 1))
		(not (clock 2))
		(not (clock 3))
		(not (clock 4))
		(not (clock 5))
		(adjusted-clock)
		(is-equal 0 0)
		(is-greater-or-equal  0 0)
		(inc 0 1)
		(is-equal 1 1)
		(is-greater-or-equal  1 0)
		(is-greater-or-equal  1 1)
		(inc 1 2)
		(is-equal 2 2)
		(is-greater-or-equal  2 0)
		(is-greater-or-equal  2 1)
		(is-greater-or-equal  2 2)
		(inc 2 3)
		(is-equal 3 3)
		(is-greater-or-equal  3 0)
		(is-greater-or-equal  3 1)
		(is-greater-or-equal  3 2)
		(is-greater-or-equal  3 3)
		(inc 3 4)
		(is-equal 4 4)
		(is-greater-or-equal  4 0)
		(is-greater-or-equal  4 1)
		(is-greater-or-equal  4 2)
		(is-greater-or-equal  4 3)
		(is-greater-or-equal  4 4)
		(inc 4 5)
		(fire-unit-at f1 l1)
		(medical-unit-at m1 l1)
		(fire-at l1)
		(water-at l1)
		(adjacent l1 l2)
		(adjacent l1 l1)
		(spreading-time 0 l1)
		(victim-at v1 l2)
		(adjacent l2 l1)
		(adjacent l2 l3)
		(adjacent l2 l2)
		(spreading-time 4 l2)
		(hospital-at l3)
		(adjacent l3 l2)
		(adjacent l3 l3)
		(spreading-time 5 l3)
		(dying v1)

	)
	(:goal
		(and
			(healthy v1)
		)
	)
)
