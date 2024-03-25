(define (problem p1-travalling-salesman)
	(:domain travalling-salesman)
	(:objects
		c11 - city
		c12 - city
		c13 - city
		c14 - city
		c21 - city
		c22 - city
		s1 - state
		s2 - state
		bottle-of-water - item
		bottle-of-coke - item
		bottle-of-beer - item
		p1 - person
		p2 - person
		p3 - person
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
		(inc 10 11)
		(buying-price-state-map 2 s1)
		(selling-price-state-map 1 s1)
		(at c11 s1)
		(at c12 s1)
		(at c13 s1)
		(at c14 s1)
		(buying-price-state-map 3 s2)
		(selling-price-state-map 1 s2)
		(at c21 s2)
		(at c22 s2)
		(same-city c11 c11)
		(has-adjacent-cities c11 2)
		(connected c11 c12)
		(connected c11 c21)
		(same-city c12 c12)
		(has-adjacent-cities c12 2)
		(connected c12 c11)
		(connected c12 c13)
		(same-city c13 c13)
		(has-adjacent-cities c13 2)
		(connected c13 c12)
		(connected c13 c14)
		(same-city c14 c14)
		(has-adjacent-cities c14 1)
		(connected c14 c13)
		(same-city c21 c21)
		(has-adjacent-cities c21 2)
		(connected c21 c11)
		(connected c21 c22)
		(same-city c22 c22)
		(has-adjacent-cities c22 1)
		(connected c22 c21)
		(money 7)
		(wallet 0)
		(on-city c11)
		(backpack-total-space 5)
		(backpack-allocated-space 0)
		(is-seller p1)
		(is-buyer p1)
		(stock bottle-of-water 10 p1)
		(stock bottle-of-coke 2 p1)
		(stock bottle-of-beer 1 p1)
		(selling-price bottle-of-water 2 p1)
		(buying-price bottle-of-water 1 p1)
		(selling-price bottle-of-coke 3 p1)
		(buying-price bottle-of-coke 2 p1)
		(selling-price bottle-of-beer 4 p1)
		(buying-price bottle-of-beer 3 p1)
		(person-at p1 c11)
		(is-buyer p2)
		(buying-price bottle-of-water 1 p2)
		(buying-price bottle-of-coke 2 p2)
		(buying-price bottle-of-beer 1 p2)
		(person-at p2 c21)
		(is-seller p3)
		(stock bottle-of-water 2 p3)
		(stock bottle-of-coke 1 p3)
		(stock bottle-of-beer 5 p3)
		(selling-price bottle-of-water 2 p3)
		(selling-price bottle-of-coke 2 p3)
		(selling-price bottle-of-beer 5 p3)
		(person-at p3 c13)

	)
	(:goal
		(and
			(number-of-visits c11 1)
			(number-of-visits c12 1)
			(number-of-visits c13 1)
			(number-of-visits c14 1)
			(number-of-visits c21 1)
			(number-of-visits c22 1)
		)
	)
)
