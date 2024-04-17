(define (problem c4_1-travelling-salesman)
	(:domain travelling-salesman)
	(:objects
		a - city
		b - city
		c - city
		d - city
		e - city
		f - city
		g - city
		h - city
		i - city
		j - city
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
		p6 - person
		p7 - person
		p8 - person
		6 - number
		7 - number
		8 - number
		9 - number
		10 - number

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
		(inc 7 8)
		(dec 8 7)
		(inc 8 9)
		(dec 9 8)
		(inc 9 10)
		(dec 10 9)
		(buying-price-state-map 3 s0)
		(selling-price-state-map 2 s0)
		(at a s0)
		(at b s0)
		(at c s0)
		(at d s0)
		(buying-price-state-map 2 s1)
		(selling-price-state-map 1 s1)
		(at a s1)
		(at j s1)
		(at d s1)
		(buying-price-state-map 1 s2)
		(selling-price-state-map 0 s2)
		(at b s2)
		(at d s2)
		(at e s2)
		(at f s2)
		(buying-price-state-map 2 s3)
		(selling-price-state-map 2 s3)
		(at b s3)
		(at e s3)
		(at f s3)
		(buying-price-state-map 1 s4)
		(selling-price-state-map 1 s4)
		(at c s4)
		(at d s4)
		(at e s4)
		(at f s4)
		(buying-price-state-map 2 s5)
		(selling-price-state-map 0 s5)
		(at d s5)
		(at f s5)
		(buying-price-state-map 3 s6)
		(selling-price-state-map 0 s6)
		(at e s6)
		(at d s6)
		(at a s6)
		(buying-price-state-map 1 s7)
		(selling-price-state-map 0 s7)
		(at f s7)
		(at c s7)
		(at j s7)
		(has-adjacent-cities a 1)
		(connected a b)
		(has-adjacent-cities b 1)
		(connected b c)
		(has-adjacent-cities c 1)
		(connected c d)
		(has-adjacent-cities d 1)
		(connected d e)
		(has-adjacent-cities e 1)
		(connected e f)
		(has-adjacent-cities f 1)
		(connected f g)
		(has-adjacent-cities g 1)
		(connected g h)
		(has-adjacent-cities h 1)
		(connected h i)
		(has-adjacent-cities i 1)
		(connected i j)
		(has-adjacent-cities j 1)
		(connected j a)
		(money 5)
		(wallet 0)
		(on-city a)
		(backpack-total-space 4)
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
		(is-buyer p6)
		(is-buying p6 bottle-of-beer)
		(is-seller p6)
		(is-selling p6 bottle-of-wine)
		(person-at p6 j)
		(is-buyer p7)
		(is-buying p7 bottle-of-beer)
		(is-seller p7)
		(is-selling p7 bottle-of-wine)
		(person-at p7 h)
		(is-buyer p8)
		(is-buying p8 bottle-of-beer)
		(is-seller p8)
		(is-selling p8 bottle-of-wine)
		(person-at p8 i)

	)
	(:goal
		(and
			(visited-once a)
			(visited-once b)
			(visited-once c)
			(visited-once d)
			(visited-once e)
			(visited-once f)
			(visited-once g)
			(visited-once h)
			(visited-once i)
			(visited-once j)
		)
	)
)
