(define (problem p5-kitchen)
	(:domain kitchen)
	(:objects
		0 - number
		1 - number
		2 - number
		3 - number
		ingredient-flour - ingredient
		recipe-cake - recipe
		recipe-pancakes - recipe
		recipe-cookies - recipe
		costumer-John - costumer

	)
	(:init
		(inc 0 1)
		(dec 1 0)
		(inc 1 2)
		(dec 2 1)
		(inc 2 3)
		(dec 3 2)
		(not (finished 0))
		(on-chef-island ingredient-flour 0 0)
		(not (finished 1))
		(on-chef-island ingredient-flour 0 1)
		(not (finished 2))
		(on-chef-island ingredient-flour 0 2)
		(on-recipe ingredient-flour 1 recipe-cake)
		(on-recipe ingredient-flour 1 recipe-pancakes)
		(on-recipe ingredient-flour 1 recipe-cookies)
		(on-stock ingredient-flour 3)
		(can-accept costumer-John recipe-cake)
		(can-accept costumer-John recipe-pancakes)
		(can-accept costumer-John recipe-cookies)
		(num-refused-recipes costumer-John 0)
		(num-recipes-to-refuse costumer-John 2)

	)
	(:goal
		(and
			(satisfied costumer-John)
		)
	)
)
