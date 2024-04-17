(define (problem c1_1-travelling-salesman)
	(:domain travelling-salesman)
	(:objects
		a - city
		b - city
		c - city
		d - city
		e - city
		f - city
		s1 - state
		s2 - state
		s3 - state
		s4 - state
		s5 - state
		bottle-of-water - item
		bottle-of-coke - item
		bottle-of-beer - item
		p1 - person
		p2 - person
		p3 - person
		p4 - person
		p5 - person
		p6 - person

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
		(at c s1)
		(buying-price-state-map 3 s2)
		(selling-price-state-map 0 s2)
		(at b s2)
		(at c s2)
		(at d s2)
		(at e s2)
		(buying-price-state-map 4 s3)
		(selling-price-state-map 0 s3)
		(at c s3)
		(at d s3)
		(buying-price-state-map 4 s4)
		(selling-price-state-map 0 s4)
		(at c s4)
		(at d s4)
		(at e s4)
		(at f s4)
		(buying-price-state-map 3 s5)
		(selling-price-state-map 0 s5)
		(at b s5)
		(at e s5)
		(has-adjacent-cities a 2)
		(connected a b)
		(connected a c)
		(has-adjacent-cities b 3)
		(connected b a)
		(connected b e)
		(connected b d)
		(has-adjacent-cities c 3)
		(connected c d)
		(connected c e)
		(connected c a)
		(has-adjacent-cities d 3)
		(connected d b)
		(connected d c)
		(connected d f)
		(has-adjacent-cities e 3)
		(connected e b)
		(connected e c)
		(connected e f)
		(has-adjacent-cities f 2)
		(connected f d)
		(connected f e)
		(money 5)
		(wallet 0)
		(on-city a)
		(backpack-total-space 2)
		(backpack-allocated-space 0)
		(volumn bottle-of-water 1)
		(buying-price bottle-of-water 1)
		(selling-price bottle-of-water 2)
		(volumn bottle-of-coke 1)
		(buying-price bottle-of-coke 3)
		(selling-price bottle-of-coke 5)
		(volumn bottle-of-beer 2)
		(buying-price bottle-of-beer 2)
		(selling-price bottle-of-beer 4)
		(is-seller p1)
		(is-selling p1 bottle-of-water)
		(is-selling p1 bottle-of-coke)
		(is-selling p1 bottle-of-beer)
		(person-at p1 a)
		(is-buyer p2)
		(is-buying p2 bottle-of-coke)
		(person-at p2 b)
		(is-buyer p3)
		(is-buying p3 bottle-of-water)
		(is-seller p3)
		(is-selling p3 bottle-of-beer)
		(person-at p3 e)
		(is-buyer p4)
		(is-buying p4 bottle-of-beer)
		(person-at p4 d)
		(is-buyer p5)
		(is-buying p5 bottle-of-coke)
		(is-seller p5)
		(is-selling p5 bottle-of-water)
		(person-at p5 f)
		(is-seller p6)
		(is-selling p6 bottle-of-water)
		(person-at p6 c)

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
