(define (problem c2_1-kitchen)
	(:domain kitchen)
	(:objects
		1 - number
		2 - number
		3 - number
		4 - number
		5 - number
		ingredient-flour - ingredient
		recipe-cake - recipe
		recipe-pancakes - recipe
		costumer-John - costumer
		costumer-Alice - costumer
		costumer-Charlie - costumer
		costumer-Bob - costumer
		costumer-David - costumer

	)
	(:init
		(next 0 1)
		(next 1 2)
		(next 2 3)
		(next 3 4)
		(next 4 5)
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
		(on-recipe ingredient-flour 1 recipe-cake)
		(on-recipe ingredient-flour 1 recipe-pancakes)
		(on-stock ingredient-flour 5)
		(can-accept costumer-John recipe-cake)
		(can-accept costumer-John recipe-pancakes)
		(num-recipes-to-refuse costumer-John 1)
		(can-accept costumer-Alice recipe-cake)
		(num-recipes-to-refuse costumer-Alice 0)
		(can-accept costumer-Charlie recipe-pancakes)
		(can-accept costumer-Charlie recipe-cake)
		(num-recipes-to-refuse costumer-Charlie 1)
		(can-accept costumer-Bob recipe-pancakes)
		(num-recipes-to-refuse costumer-Bob 0)
		(can-accept costumer-David recipe-cake)
		(num-recipes-to-refuse costumer-David 0)

	)
	(:goal
		(and
			(satisfied costumer-John)
			(satisfied costumer-Alice)
			(satisfied costumer-Charlie)
			(satisfied costumer-Bob)
			(satisfied costumer-David)
		)
	)
)
