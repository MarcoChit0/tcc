(define (problem c3_1-kitchen)
	(:domain kitchen)
	(:objects
		1 - number
		2 - number
		3 - number
		ingredient-flour - ingredient
		ingredient-eggs - ingredient
		ingredient-butter - ingredient
		ingredient-milk - ingredient
		recipe-cake - recipe
		recipe-pancakes - recipe
		costumer-John - costumer

	)
	(:init
		(next 0 1)
		(next 1 2)
		(next 2 3)
		(not (finished 0))
		(on-chef-island ingredient-flour 0 0)
		(on-chef-island ingredient-eggs 0 0)
		(on-chef-island ingredient-butter 0 0)
		(on-chef-island ingredient-milk 0 0)
		(not (finished 1))
		(on-chef-island ingredient-flour 0 1)
		(on-chef-island ingredient-eggs 0 1)
		(on-chef-island ingredient-butter 0 1)
		(on-chef-island ingredient-milk 0 1)
		(on-recipe ingredient-flour 1 recipe-cake)
		(on-recipe ingredient-eggs 1 recipe-cake)
		(on-recipe ingredient-butter 1 recipe-cake)
		(not-on-recipe ingredient-milk recipe-cake)
		(on-recipe ingredient-flour 1 recipe-pancakes)
		(on-recipe ingredient-eggs 1 recipe-pancakes)
		(on-recipe ingredient-milk 1 recipe-pancakes)
		(not-on-recipe ingredient-butter recipe-pancakes)
		(on-stock ingredient-flour 3)
		(on-stock ingredient-eggs 3)
		(on-stock ingredient-butter 3)
		(on-stock ingredient-milk 3)
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
