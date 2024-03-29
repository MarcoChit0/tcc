(define (problem p2-travelling-salesman)
	(:domain travelling-salesman)
	(:objects
		a - city
		b - city
		c - city
		d - city
		s1 - state
		s2 - state
		s3 - state
		s4 - state
		bottle-of-water - item
		p1 - person
		p2 - person

	)
	(:init
		(inc 0 1)
		(dec 1 0)
		(inc 1 2)
		(dec 2 1)
		(inc 2 3)
		(dec 3 2)
		(inc 3 4)
		(dec 4 3)
		(inc 4 5)
		(dec 5 4)
		(buying-price-state-map 1 s1)
		(selling-price-state-map 0 s1)
		(at a s1)
		(at b s1)
		(buying-price-state-map 1 s2)
		(selling-price-state-map 0 s2)
		(at b s2)
		(at c s2)
		(buying-price-state-map 2 s3)
		(selling-price-state-map 0 s3)
		(at c s3)
		(at d s3)
		(buying-price-state-map 1 s4)
		(selling-price-state-map 0 s4)
		(at d s4)
		(at a s4)
		(has-adjacent-cities a 1)
		(connected a b)
		(has-adjacent-cities b 1)
		(connected b c)
		(has-adjacent-cities c 3)
		(connected c d)
		(connected c b)
		(connected c a)
		(has-adjacent-cities d 1)
		(connected d a)
		(money 1)
		(wallet 0)
		(on-city a)
		(backpack-total-space 1)
		(backpack-allocated-space 0)
		(volumn bottle-of-water 1)
		(buying-price bottle-of-water 1)
		(selling-price bottle-of-water 2)
		(is-seller p1)
		(is-selling p1 bottle-of-water)
		(person-at p1 a)
		(is-buyer p2)
		(is-buying p2 bottle-of-water)
		(person-at p2 b)

	)
	(:goal
		(and
			(visited-once a)
			(visited-once b)
			(visited-once c)
			(visited-once d)
		)
	)
)
