(define (problem p1-kitchen)
	(:domain kitchen)
	(:objects
		1 - number
		2 - number
		ingredient-flour - ingredient
		ingredient-eggs - ingredient
		recipe-cake - recipe
		recipe-pancakes - recipe
		costumer-John - costumer

	)
	(:init
		(next 0 1)
		(next 1 2)
		(not (finished 0))
		(on-chef-island ingredient-flour 0 0)
		(on-chef-island ingredient-eggs 0 0)
		(not (finished 1))
		(on-chef-island ingredient-flour 0 1)
		(on-chef-island ingredient-eggs 0 1)
		(on-recipe ingredient-flour 1 recipe-cake)
		(on-recipe ingredient-eggs 1 recipe-cake)
		(on-recipe ingredient-flour 1 recipe-pancakes)
		(on-recipe ingredient-eggs 1 recipe-pancakes)
		(on-stock ingredient-flour 2)
		(on-stock ingredient-eggs 2)
		(can-accept costumer-John recipe-cake)
		(can-accept costumer-John recipe-pancakes)
		(num-recipes-to-refuse costumer-John 1)

	)
	(:goal
		(and
			(satisfied costumer-John)
		)
	)
)
