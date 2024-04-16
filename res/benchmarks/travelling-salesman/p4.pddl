(define (problem p4-travelling-salesman)
	(:domain travelling-salesman)
	(:objects
		a - city
		b - city
		c - city
		d - city
		e - city
		f - city
		s0 - state
		s1 - state
		s2 - state
		s3 - state
		s4 - state
		s5 - state
		s6 - state
		s7 - state
		bottle-of-beer - item
		bottle-of-water - item
		bottle-of-wine - item
		bottle-of-whiskey - item
		bottle-of-vodka - item
		p0 - person
		p1 - person
		p2 - person
		p3 - person
		p4 - person
		p5 - person
		6 - number
		7 - number

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
		(inc 6 7)
		(dec 7 6)
		(buying-price-state-map 1 s0)
		(selling-price-state-map 0 s0)
		(at a s0)
		(at b s0)
		(buying-price-state-map 1 s1)
		(selling-price-state-map 0 s1)
		(at a s1)
		(at c s1)
		(buying-price-state-map 1 s2)
		(selling-price-state-map 0 s2)
		(at b s2)
		(at d s2)
		(buying-price-state-map 1 s3)
		(selling-price-state-map 0 s3)
		(at b s3)
		(at e s3)
		(buying-price-state-map 1 s4)
		(selling-price-state-map 0 s4)
		(at c s4)
		(at d s4)
		(buying-price-state-map 1 s5)
		(selling-price-state-map 0 s5)
		(at d s5)
		(at f s5)
		(buying-price-state-map 1 s6)
		(selling-price-state-map 0 s6)
		(at e s6)
		(at d s6)
		(buying-price-state-map 1 s7)
		(selling-price-state-map 0 s7)
		(at f s7)
		(at c s7)
		(has-adjacent-cities a 2)
		(connected a b)
		(connected a c)
		(has-adjacent-cities b 2)
		(connected b d)
		(connected b e)
		(has-adjacent-cities c 2)
		(connected c d)
		(connected c a)
		(has-adjacent-cities d 1)
		(connected d f)
		(has-adjacent-cities e 1)
		(connected e d)
		(has-adjacent-cities f 1)
		(connected f c)
		(money 4)
		(wallet 0)
		(on-city a)
		(backpack-total-space 3)
		(backpack-allocated-space 0)
		(volumn bottle-of-beer 2)
		(buying-price bottle-of-beer 1)
		(selling-price bottle-of-beer 3)
		(volumn bottle-of-water 1)
		(buying-price bottle-of-water 1)
		(selling-price bottle-of-water 2)
		(volumn bottle-of-wine 2)
		(buying-price bottle-of-wine 2)
		(selling-price bottle-of-wine 4)
		(volumn bottle-of-whiskey 3)
		(buying-price bottle-of-whiskey 3)
		(selling-price bottle-of-whiskey 5)
		(volumn bottle-of-vodka 3)
		(buying-price bottle-of-vodka 3)
		(selling-price bottle-of-vodka 7)
		(is-seller p0)
		(is-selling p0 bottle-of-beer)
		(is-selling p0 bottle-of-wine)
		(is-selling p0 bottle-of-vodka)
		(is-selling p0 bootle-of-water)
		(person-at p0 a)
		(is-buyer p1)
		(is-buying p1 bottle-of-beer)
		(is-buying p1 bootle-of-water)
		(is-seller p1)
		(is-selling p1 bottle-of-wine)
		(is-selling p1 bottle-of-water)
		(person-at p1 b)
		(is-seller p2)
		(is-selling p2 bottle-of-wine)
		(person-at p2 e)
		(is-seller p3)
		(is-selling p3 bottle-of-water)
		(person-at p3 d)
		(is-buyer p4)
		(is-buying p4 bottle-of-vodka)
		(is-seller p4)
		(is-selling p4 bottle-of-wine)
		(person-at p4 f)
		(is-buyer p5)
		(is-buying p5 bottle-of-wine)
		(is-seller p5)
		(is-selling p5 bottle-of-beer)
		(person-at p5 c)

	)
	(:goal
		(and
			(visited-once a)
			(visited-once b)
			(visited-once c)
			(visited-once d)
			(visited-once e)
			(visited-once f)
		)
	)
)
