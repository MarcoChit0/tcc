(define (problem t4-kitchen)
	(:domain kitchen)
	(:objects
		1 - number
		2 - number
		3 - number
		4 - number
		ingredient-flour - ingredient
		recipe-cake - recipe
		recipe-pancakes - recipe
		costumer-John - costumer
		costumer-Jane - costumer
		costumer-Doe - costumer
		costumer-Brown - costumer

	)
	(:init
		(next 0 1)
		(next 1 2)
		(next 2 3)
		(next 3 4)
		(not (finished 0))
		(on-chef-island ingredient-flour 0 0)
		(not (finished 1))
		(on-chef-island ingredient-flour 0 1)
		(not (finished 2))
		(on-chef-island ingredient-flour 0 2)
		(not (finished 3))
		(on-chef-island ingredient-flour 0 3)
		(on-recipe ingredient-flour 1 recipe-cake)
		(on-recipe ingredient-flour 1 recipe-pancakes)
		(on-stock ingredient-flour 4)
		(can-accept costumer-John recipe-cake)
		(num-recipes-to-refuse costumer-John 0)
		(can-accept costumer-Jane recipe-cake)
		(can-accept costumer-Jane recipe-pancakes)
		(num-recipes-to-refuse costumer-Jane 1)
		(can-accept costumer-Doe recipe-pancakes)
		(num-recipes-to-refuse costumer-Doe 0)
		(can-accept costumer-Brown recipe-cake)
		(can-accept costumer-Brown recipe-pancakes)
		(num-recipes-to-refuse costumer-Brown 1)

	)
	(:goal
		(and
			(satisfied costumer-John)
			(satisfied costumer-Jane)
			(satisfied costumer-Doe)
			(satisfied costumer-Brown)
		)
	)
)
