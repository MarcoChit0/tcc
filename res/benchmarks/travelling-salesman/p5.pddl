(define (problem p5-travelling-salesman)
	(:domain travelling-salesman)
	(:objects
		a - city
		b - city
		c - city
		d - city
		e - city
		s0 - state
		s1 - state
		bootle-of-water - item
		bottle-of-beer - item
		bottle-of-wine - item
		bootle-of-vodka - item
		p0 - person
		p1 - person
		p2 - person
		p3 - person
		p4 - person
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
		(buying-price-state-map 2 s0)
		(selling-price-state-map 0 s0)
		(at a s0)
		(at b s0)
		(at c s0)
		(buying-price-state-map 6 s1)
		(selling-price-state-map 0 s1)
		(at b s1)
		(at c s1)
		(at d s1)
		(at e s1)
		(has-adjacent-cities a 3)
		(connected a b)
		(connected a c)
		(connected a d)
		(has-adjacent-cities b 2)
		(connected b d)
		(connected b c)
		(has-adjacent-cities c 2)
		(connected c d)
		(connected c b)
		(has-adjacent-cities d 3)
		(connected d b)
		(connected d c)
		(connected d e)
		(has-adjacent-cities e 1)
		(connected e a)
		(money 4)
		(wallet 0)
		(on-city a)
		(backpack-total-space 3)
		(backpack-allocated-space 0)
		(volumn bootle-of-water 1)
		(buying-price bootle-of-water 1)
		(selling-price bootle-of-water 2)
		(volumn bottle-of-beer 1)
		(buying-price bottle-of-beer 1)
		(selling-price bottle-of-beer 3)
		(volumn bottle-of-wine 2)
		(buying-price bottle-of-wine 2)
		(selling-price bottle-of-wine 6)
		(volumn bootle-of-vodka 1)
		(buying-price bootle-of-vodka 3)
		(selling-price bootle-of-vodka 7)
		(is-seller p0)
		(is-selling p0 bottle-of-beer)
		(is-selling p0 bottle-of-wine)
		(is-selling p0 bottle-of-vodka)
		(is-selling p0 bootle-of-water)
		(person-at p0 a)
		(is-buyer p1)
		(is-buying p1 bootle-of-beer)
		(is-buying p1 bootle-of-water)
		(person-at p1 b)
		(is-buyer p2)
		(is-buying p2 bottle-of-wine)
		(is-buying p2 bootle-of-water)
		(person-at p2 c)
		(is-seller p3)
		(is-selling p3 bottle-of-beer)
		(is-selling p3 bottle-of-wine)
		(is-selling p3 bootle-of-water)
		(person-at p3 d)
		(is-seller p4)
		(is-selling p4 bottle-of-vodka)
		(person-at p4 e)

	)
	(:goal
		(and
			(visited-once a)
			(visited-once b)
			(visited-once c)
			(visited-once d)
			(visited-once e)
		)
	)
)
