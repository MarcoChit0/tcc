(define (problem c1_1-kitchen)
	(:domain kitchen)
	(:objects
		1 - number
		2 - number
		3 - number
		4 - number
		5 - number
		6 - number
		ingredient-flour - ingredient
		recipe-pancakes - recipe
		recipe-cookies - recipe
		recipe-bread - recipe
		recipe-pizza - recipe
		recipe-pasta - recipe
		recipe-pie - recipe
		recipe-muffin - recipe
		recipe-waffle - recipe
		costumer-Doe - costumer
		costumer-Smith - costumer

	)
	(:init
		(next 0 1)
		(next 1 2)
		(next 2 3)
		(next 3 4)
		(next 4 5)
		(next 5 6)
		(not (finished 0))
		(on-chef-island ingredient-flour 0 0)
		(not (finished 1))
		(on-chef-island ingredient-flour 0 1)
		(not (finished 2))
		(on-chef-island ingredient-flour 0 2)
		(not (finished 3))
		(on-chef-island ingredient-flour 0 3)
		(on-recipe ingredient-flour 1 recipe-pancakes)
		(on-recipe ingredient-flour 1 recipe-cookies)
		(on-recipe ingredient-flour 2 recipe-bread)
		(on-recipe ingredient-flour 2 recipe-pizza)
		(on-recipe ingredient-flour 2 recipe-pasta)
		(on-recipe ingredient-flour 1 recipe-pie)
		(on-recipe ingredient-flour 1 recipe-muffin)
		(on-recipe ingredient-flour 2 recipe-waffle)
		(on-stock ingredient-flour 6)
		(can-accept costumer-Doe recipe-pizza)
		(can-accept costumer-Doe recipe-muffin)
		(num-recipes-to-refuse costumer-Doe 1)
		(can-accept costumer-Smith recipe-pasta)
		(can-accept costumer-Smith recipe-cookies)
		(num-recipes-to-refuse costumer-Smith 1)

	)
	(:goal
		(and
			(satisfied costumer-Doe)
			(satisfied costumer-Smith)
		)
	)
)
