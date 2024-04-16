(define (problem p3-travelling-salesman)
	(:domain travelling-salesman)
	(:objects
		a - city
		b - city
		c - city
		d - city
		s0 - state
		s1 - state
		s2 - state
		s3 - state
		s4 - state
		s5 - state
		s6 - state
		s7 - state
		s8 - state
		s9 - state
		s10 - state
		bottle-of-water - item
		bottle-of-cola - item
		bottle-of-beer - item
		bottle-of-wine - item
		p0 - person
		p1 - person
		p2 - person
		p3 - person
		6 - number

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
		(inc 5 6)
		(dec 6 5)
		(buying-price-state-map 2 s0)
		(selling-price-state-map 0 s0)
		(at a s0)
		(at b s0)
		(buying-price-state-map 2 s1)
		(selling-price-state-map 0 s1)
		(at a s1)
		(at c s1)
		(buying-price-state-map 2 s2)
		(selling-price-state-map 0 s2)
		(at a s2)
		(at d s2)
		(buying-price-state-map 2 s3)
		(selling-price-state-map 0 s3)
		(at b s3)
		(at c s3)
		(buying-price-state-map 2 s4)
		(selling-price-state-map 0 s4)
		(at b s4)
		(at d s4)
		(buying-price-state-map 2 s5)
		(selling-price-state-map 0 s5)
		(at c s5)
		(at d s5)
		(buying-price-state-map 3 s6)
		(selling-price-state-map 0 s6)
		(at a s6)
		(at b s6)
		(at c s6)
		(buying-price-state-map 3 s7)
		(selling-price-state-map 0 s7)
		(at a s7)
		(at b s7)
		(at d s7)
		(buying-price-state-map 3 s8)
		(selling-price-state-map 0 s8)
		(at a s8)
		(at c s8)
		(at d s8)
		(buying-price-state-map 3 s9)
		(selling-price-state-map 0 s9)
		(at b s9)
		(at c s9)
		(at d s9)
		(buying-price-state-map 5 s10)
		(selling-price-state-map 2 s10)
		(at a s10)
		(at b s10)
		(at c s10)
		(at d s10)
		(has-adjacent-cities a 3)
		(connected a b)
		(connected a c)
		(connected a d)
		(has-adjacent-cities b 3)
		(connected b a)
		(connected b c)
		(connected b d)
		(has-adjacent-cities c 3)
		(connected c d)
		(connected c b)
		(connected c a)
		(has-adjacent-cities d 3)
		(connected d a)
		(connected d b)
		(connected d c)
		(money 5)
		(wallet 0)
		(on-city a)
		(backpack-total-space 3)
		(backpack-allocated-space 0)
		(volumn bottle-of-water 1)
		(buying-price bottle-of-water 1)
		(selling-price bottle-of-water 2)
		(volumn bottle-of-cola 2)
		(buying-price bottle-of-cola 2)
		(selling-price bottle-of-cola 3)
		(volumn bottle-of-beer 3)
		(buying-price bottle-of-beer 1)
		(selling-price bottle-of-beer 3)
		(volumn bottle-of-wine 3)
		(buying-price bottle-of-wine 2)
		(selling-price bottle-of-wine 5)
		(is-seller p0)
		(is-selling p0 bottle-of-water)
		(is-selling p0 bottle-of-cola)
		(is-selling p0 bottle-of-beer)
		(is-selling p0 bottle-of-wine)
		(person-at p0 a)
		(is-buyer p1)
		(is-buying p1 bottle-of-water)
		(is-buying p1 bootle-of-beer)
		(person-at p1 b)
		(is-buyer p2)
		(is-buying p2 bottle-of-cola)
		(is-buying p2 bootle-of-beer)
		(person-at p2 c)
		(is-buyer p3)
		(is-buying p3 bottle-of-wine)
		(person-at p3 d)

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
