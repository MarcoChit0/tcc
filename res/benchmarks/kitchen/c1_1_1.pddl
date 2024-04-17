(define (problem c1_1_1-kitchen)
	(:domain kitchen)
	(:objects
		1 - number
		2 - number
		3 - number
		4 - number
		ingredient-flour - ingredient
		ingredient-eggs - ingredient
		ingredient-butter - ingredient
		ingredient-sugar - ingredient
		recipe-cake - recipe
		recipe-pancakes - recipe
		recipe-cookies - recipe
		costumer-John - costumer
		costumer-Alice - costumer
		costumer-Charlie - costumer

	)
	(:init
		(next 0 1)
		(next 1 2)
		(next 2 3)
		(next 3 4)
		(not (finished 0))
		(on-chef-island ingredient-flour 0 0)
		(on-chef-island ingredient-eggs 0 0)
		(on-chef-island ingredient-butter 0 0)
		(on-chef-island ingredient-sugar 0 0)
		(not (finished 1))
		(on-chef-island ingredient-flour 0 1)
		(on-chef-island ingredient-eggs 0 1)
		(on-chef-island ingredient-butter 0 1)
		(on-chef-island ingredient-sugar 0 1)
		(not (finished 2))
		(on-chef-island ingredient-flour 0 2)
		(on-chef-island ingredient-eggs 0 2)
		(on-chef-island ingredient-butter 0 2)
		(on-chef-island ingredient-sugar 0 2)
		(not (finished 3))
		(on-chef-island ingredient-flour 0 3)
		(on-chef-island ingredient-eggs 0 3)
		(on-chef-island ingredient-butter 0 3)
		(on-chef-island ingredient-sugar 0 3)
		(on-recipe ingredient-flour 1 recipe-cake)
		(on-recipe ingredient-eggs 1 recipe-cake)
		(not-on-recipe ingredient-butter recipe-cake)
		(not-on-recipe ingredient-sugar recipe-cake)
		(on-recipe ingredient-flour 1 recipe-pancakes)
		(on-recipe ingredient-butter 1 recipe-pancakes)
		(not-on-recipe ingredient-eggs recipe-pancakes)
		(not-on-recipe ingredient-sugar recipe-pancakes)
		(on-recipe ingredient-flour 1 recipe-cookies)
		(on-recipe ingredient-sugar 1 recipe-cookies)
		(not-on-recipe ingredient-butter recipe-cookies)
		(not-on-recipe ingredient-eggs recipe-cookies)
		(on-stock ingredient-flour 4)
		(on-stock ingredient-eggs 1)
		(on-stock ingredient-butter 2)
		(on-stock ingredient-sugar 2)
		(can-accept costumer-John recipe-cake)
		(can-accept costumer-John recipe-pancakes)
		(num-recipes-to-refuse costumer-John 1)
		(can-accept costumer-Alice recipe-cookies)
		(num-recipes-to-refuse costumer-Alice 0)
		(can-accept costumer-Charlie recipe-pancakes)
		(can-accept costumer-Charlie recipe-cookies)
		(num-recipes-to-refuse costumer-Charlie 1)

	)
	(:goal
		(and
			(satisfied costumer-John)
			(satisfied costumer-Alice)
			(satisfied costumer-Charlie)
		)
	)
)
