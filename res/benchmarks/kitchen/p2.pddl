(define (problem p2-kitchen)
	(:domain kitchen)
	(:objects
		0 - number
		1 - number
		2 - number
		ingredient-flour - ingredient
		recipe-cake - recipe
		recipe-pancakes - recipe
		costumer-John - costumer

	)
	(:init
		(inc 0 1)
		(dec 1 0)
		(inc 1 2)
		(dec 2 1)
		(on-chef-island ingredient-flour 0)
		(on-recipe ingredient-flour 1 recipe-cake)
		(on-recipe ingredient-flour 1 recipe-pancakes)
		(on-stock ingredient-flour 2)
		(can-accept costumer-John recipe-cake)
		(can-accept costumer-John recipe-pancakes)
		(num-refused-recipes costumer-John 0)
		(num-recipes-to-refuse costumer-John 1)

	)
	(:goal
		(and
			(satisfied John)
		)
	)
)
