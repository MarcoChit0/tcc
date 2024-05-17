(define (problem c1_2-kitchen)
	(:domain kitchen)
	(:objects
		1 - number
		2 - number
		3 - number
		4 - number
		5 - number
		6 - number
		7 - number
		8 - number
		9 - number
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
		costumer-Johnson - costumer
		costumer-Brown - costumer

	)
	(:init
		(next 0 1)
		(next 1 2)
		(next 2 3)
		(next 3 4)
		(next 4 5)
		(next 5 6)
		(next 6 7)
		(next 7 8)
		(next 8 9)
		(not (finished 0))
		(on-chef-island ingredient-flour 0 0)
		(not (finished 1))
		(on-chef-island ingredient-flour 0 1)
		(not (finished 2))
		(on-chef-island ingredient-flour 0 2)
		(not (finished 3))
		(on-chef-island ingredient-flour 0 3)
		(not (finished 4))
		(on-chef-island ingredient-flour 0 4)
		(not (finished 5))
		(on-chef-island ingredient-flour 0 5)
		(on-recipe ingredient-flour 1 recipe-pancakes)
		(on-recipe ingredient-flour 1 recipe-cookies)
		(on-recipe ingredient-flour 2 recipe-bread)
		(on-recipe ingredient-flour 2 recipe-pizza)
		(on-recipe ingredient-flour 2 recipe-pasta)
		(on-recipe ingredient-flour 1 recipe-pie)
		(on-recipe ingredient-flour 1 recipe-muffin)
		(on-recipe ingredient-flour 2 recipe-waffle)
		(on-stock ingredient-flour 9)
		(can-accept costumer-Doe recipe-pizza)
		(can-accept costumer-Doe recipe-muffin)
		(num-recipes-to-refuse costumer-Doe 1)
		(can-accept costumer-Smith recipe-pasta)
		(can-accept costumer-Smith recipe-cookies)
		(num-recipes-to-refuse costumer-Smith 1)
		(can-accept costumer-Johnson recipe-pizza)
		(can-accept costumer-Johnson recipe-pasta)
		(num-recipes-to-refuse costumer-Johnson 1)
		(can-accept costumer-Brown recipe-pie)
		(can-accept costumer-Brown recipe-waffle)
		(num-recipes-to-refuse costumer-Brown 1)

	)
	(:goal
		(and
			(satisfied costumer-Doe)
			(satisfied costumer-Smith)
			(satisfied costumer-Johnson)
			(satisfied costumer-Brown)
		)
	)
)
