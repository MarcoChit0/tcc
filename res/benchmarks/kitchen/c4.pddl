(define (problem c4_1-kitchen)
	(:domain kitchen)
	(:objects
		1 - number
		2 - number
		ingredient-flour - ingredient
		ingredient-butter - ingredient
		ingredient-sugar - ingredient
		recipe-cake - recipe
		recipe-pancakes - recipe
		recipe-cookies - recipe
		costumer-John - costumer
		costumer-Alice - costumer

	)
	(:init
		(next 0 1)
		(next 1 2)
		(not (finished 0))
		(on-chef-island ingredient-flour 0 0)
		(on-chef-island ingredient-butter 0 0)
		(on-chef-island ingredient-sugar 0 0)
		(not (finished 1))
		(on-chef-island ingredient-flour 0 1)
		(on-chef-island ingredient-butter 0 1)
		(on-chef-island ingredient-sugar 0 1)
		(on-recipe ingredient-flour 1 recipe-cake)
		(on-recipe ingredient-sugar 1 recipe-cake)
		(not-on-recipe ingredient-butter recipe-cake)
		(on-recipe ingredient-flour 1 recipe-pancakes)
		(on-recipe ingredient-butter 1 recipe-pancakes)
		(not-on-recipe ingredient-sugar recipe-pancakes)
		(on-recipe ingredient-butter 1 recipe-cookies)
		(on-recipe ingredient-sugar 1 recipe-cookies)
		(not-on-recipe ingredient-flour recipe-cookies)
		(on-stock ingredient-flour 2)
		(on-stock ingredient-butter 2)
		(on-stock ingredient-sugar 2)
		(can-accept costumer-John recipe-cake)
		(can-accept costumer-John recipe-pancakes)
		(num-recipes-to-refuse costumer-John 1)
		(can-accept costumer-Alice recipe-cake)
		(num-recipes-to-refuse costumer-Alice 0)

	)
	(:goal
		(and
			(satisfied costumer-John)
			(satisfied costumer-Alice)
		)
	)
)
