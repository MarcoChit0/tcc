(define (problem c1_2_1-kitchen)
	(:domain kitchen)
	(:objects
		1 - number
		2 - number
		3 - number
		4 - number
		ingredient-flour - ingredient
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
		(not (finished 1))
		(on-chef-island ingredient-flour 0 1)
		(not (finished 2))
		(on-chef-island ingredient-flour 0 2)
		(not (finished 3))
		(on-chef-island ingredient-flour 0 3)
		(on-recipe ingredient-flour 1 recipe-cake)
		(on-recipe ingredient-flour 1 recipe-pancakes)
		(on-recipe ingredient-flour 1 recipe-cookies)
		(on-stock ingredient-flour 4)
		(can-accept costumer-John recipe-cake)
		(can-accept costumer-John recipe-pancakes)
		(num-recipes-to-refuse costumer-John 1)
		(can-accept costumer-Alice recipe-cake)
		(can-accept costumer-Alice recipe-cookies)
		(num-recipes-to-refuse costumer-Alice 1)
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
