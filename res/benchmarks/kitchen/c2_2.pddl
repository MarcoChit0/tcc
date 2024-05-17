(define (problem c2_2-kitchen)
	(:domain kitchen)
	(:objects
		1 - number
		2 - number
		3 - number
		4 - number
		5 - number
		6 - number
		7 - number
		ingredient-flour - ingredient
		ingredient-eggs - ingredient
		ingredient-butter - ingredient
		recipe-cake - recipe
		recipe-pancakes - recipe
		costumer-John - costumer
		costumer-Alice - costumer
		costumer-Charlie - costumer
		costumer-Bob - costumer
		costumer-David - costumer
		costumer-Margaret - costumer
		costumer-Eve - costumer

	)
	(:init
		(next 0 1)
		(next 1 2)
		(next 2 3)
		(next 3 4)
		(next 4 5)
		(next 5 6)
		(next 6 7)
		(not (finished 0))
		(on-chef-island ingredient-flour 0 0)
		(on-chef-island ingredient-eggs 0 0)
		(on-chef-island ingredient-butter 0 0)
		(not (finished 1))
		(on-chef-island ingredient-flour 0 1)
		(on-chef-island ingredient-eggs 0 1)
		(on-chef-island ingredient-butter 0 1)
		(not (finished 2))
		(on-chef-island ingredient-flour 0 2)
		(on-chef-island ingredient-eggs 0 2)
		(on-chef-island ingredient-butter 0 2)
		(not (finished 3))
		(on-chef-island ingredient-flour 0 3)
		(on-chef-island ingredient-eggs 0 3)
		(on-chef-island ingredient-butter 0 3)
		(not (finished 4))
		(on-chef-island ingredient-flour 0 4)
		(on-chef-island ingredient-eggs 0 4)
		(on-chef-island ingredient-butter 0 4)
		(not (finished 5))
		(on-chef-island ingredient-flour 0 5)
		(on-chef-island ingredient-eggs 0 5)
		(on-chef-island ingredient-butter 0 5)
		(not (finished 6))
		(on-chef-island ingredient-flour 0 6)
		(on-chef-island ingredient-eggs 0 6)
		(on-chef-island ingredient-butter 0 6)
		(on-recipe ingredient-flour 1 recipe-cake)
		(on-recipe ingredient-eggs 1 recipe-cake)
		(not-on-recipe ingredient-butter recipe-cake)
		(on-recipe ingredient-flour 1 recipe-pancakes)
		(on-recipe ingredient-butter 1 recipe-pancakes)
		(not-on-recipe ingredient-eggs recipe-pancakes)
		(on-stock ingredient-flour 7)
		(on-stock ingredient-eggs 5)
		(on-stock ingredient-butter 5)
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
		(can-accept costumer-Margaret recipe-cake)
		(can-accept costumer-Margaret recipe-pancakes)
		(num-recipes-to-refuse costumer-Margaret 1)
		(can-accept costumer-Eve recipe-pancakes)
		(num-recipes-to-refuse costumer-Eve 0)

	)
	(:goal
		(and
			(satisfied costumer-John)
			(satisfied costumer-Alice)
			(satisfied costumer-Charlie)
			(satisfied costumer-Bob)
			(satisfied costumer-David)
			(satisfied costumer-Margaret)
			(satisfied costumer-Eve)
		)
	)
)
