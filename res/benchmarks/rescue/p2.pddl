(define (problem p2-rescue)
	(:domain rescue)
	(:objects
		0 - number
	    1 - number
		l1 - location
		v1 - victim
	)
	(:init
		(hospital-at l1)
		(victim-at v1 l1)
		(adjusted-clock)
		
		(clock 0)
		(inc 0 1)
		(not (fire-at l1))
		(is-greater-or-equal 1 0)
		(is-greater-or-equal 1 1)
		(is-equal 1 1)
		(adjacent l1 l1)
		(spreading-time 1 l1)
		(victim-status v1 hurt)

	)
	(:goal
		(and
			(victim-status v1 healthy)
		)
	)
)