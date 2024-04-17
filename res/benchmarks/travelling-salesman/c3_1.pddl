(define (problem c3_1-travelling-salesman)
	(:domain travelling-salesman)
	(:objects
		a0 - city
		a1 - city
		a2 - city
		a3 - city
		a4 - city
		a5 - city
		a6 - city
		s0 - state
		s1 - state
		s2 - state
		s3 - state
		s4 - state
		s5 - state
		s_0 - state
		s_1 - state
		s_2 - state
		s_3 - state
		s_4 - state
		item0 - item
		item1 - item
		item2 - item
		item3 - item
		item4 - item
		item5 - item
		p0 - person
		p1 - person
		p2 - person
		p3 - person
		p4 - person
		p5 - person
		p6 - person
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
		(buying-price-state-map 7 s0)
		(selling-price-state-map 0 s0)
		(at a0 s0)
		(at a6 s0)
		(buying-price-state-map 1 s1)
		(selling-price-state-map 0 s1)
		(at a1 s1)
		(at a6 s1)
		(buying-price-state-map 1 s2)
		(selling-price-state-map 0 s2)
		(at a2 s2)
		(at a6 s2)
		(buying-price-state-map 1 s3)
		(selling-price-state-map 0 s3)
		(at a3 s3)
		(at a6 s3)
		(buying-price-state-map 1 s4)
		(selling-price-state-map 0 s4)
		(at a4 s4)
		(at a6 s4)
		(buying-price-state-map 1 s5)
		(selling-price-state-map 0 s5)
		(at a5 s5)
		(at a6 s5)
		(buying-price-state-map 1 s_0)
		(selling-price-state-map 0 s_0)
		(at a0 s_0)
		(at a1 s_0)
		(buying-price-state-map 1 s_1)
		(selling-price-state-map 0 s_1)
		(at a1 s_1)
		(at a2 s_1)
		(buying-price-state-map 1 s_2)
		(selling-price-state-map 0 s_2)
		(at a2 s_2)
		(at a3 s_2)
		(buying-price-state-map 1 s_3)
		(selling-price-state-map 0 s_3)
		(at a3 s_3)
		(at a4 s_3)
		(buying-price-state-map 1 s_4)
		(selling-price-state-map 0 s_4)
		(at a4 s_4)
		(at a5 s_4)
		(has-adjacent-cities a0 1)
		(connected a0 a1)
		(has-adjacent-cities a1 1)
		(connected a1 a2)
		(has-adjacent-cities a2 1)
		(connected a2 a3)
		(has-adjacent-cities a3 1)
		(connected a3 a4)
		(has-adjacent-cities a4 1)
		(connected a4 a5)
		(has-adjacent-cities a5 1)
		(connected a5 a6)
		(has-adjacent-cities a6 6)
		(connected a6 a0)
		(connected a6 a1)
		(connected a6 a2)
		(connected a6 a3)
		(connected a6 a4)
		(connected a6 a5)
		(money 1)
		(wallet 0)
		(on-city a0)
		(backpack-total-space 6)
		(backpack-allocated-space 0)
		(volumn item0 1)
		(buying-price item0 1)
		(selling-price item0 2)
		(volumn item1 2)
		(buying-price item1 2)
		(selling-price item1 3)
		(volumn item2 3)
		(buying-price item2 3)
		(selling-price item2 4)
		(volumn item3 4)
		(buying-price item3 4)
		(selling-price item3 5)
		(volumn item4 5)
		(buying-price item4 5)
		(selling-price item4 6)
		(volumn item5 6)
		(buying-price item5 6)
		(selling-price item5 7)
		(is-seller p0)
		(is-selling p0 item0)
		(person-at p0 a0)
		(is-buyer p1)
		(is-buying p1 item0)
		(is-seller p1)
		(is-selling p1 item1)
		(person-at p1 a1)
		(is-buyer p2)
		(is-buying p2 item1)
		(is-seller p2)
		(is-selling p2 item2)
		(person-at p2 a2)
		(is-buyer p3)
		(is-buying p3 item2)
		(is-seller p3)
		(is-selling p3 item3)
		(person-at p3 a3)
		(is-buyer p4)
		(is-buying p4 item3)
		(is-seller p4)
		(is-selling p4 item4)
		(person-at p4 a4)
		(is-buyer p5)
		(is-buying p5 item4)
		(is-seller p5)
		(is-selling p5 item5)
		(person-at p5 a5)
		(is-buyer p6)
		(is-buying p6 item5)
		(person-at p6 a6)

	)
	(:goal
		(and
			(visited-once a0)
			(visited-once a1)
			(visited-once a2)
			(visited-once a3)
			(visited-once a4)
			(visited-once a5)
			(visited-once a6)
		)
	)
)
