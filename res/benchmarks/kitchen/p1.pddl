(define (problem p1-kitchen)
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
		10 - number
		ingredient-flour - ingredient
		ingredient-sugar - ingredient
		ingredient-eggs - ingredient
		ingredient-butter - ingredient
		ingredient-milk - ingredient
		recipe-cake - recipe
		recipe-pancakes - recipe
		recipe-cookies - recipe
		costumer-John - costumer
		costumer-Alice - costumer
		costumer-Bob - costumer

	)
	(:init
		(inc 0 1)
		(dec 1 0)
		(inc 1 2)
		(dec 2 1)
		(inc 2 3)
		(dec 3 2)
		(inc 3 4)
		(dec 4 3)
		(inc 4 5)
		(dec 5 4)
		(inc 5 6)
		(dec 6 5)
		(inc 6 7)
		(dec 7 6)
		(inc 7 8)
		(dec 8 7)
		(inc 8 9)
		(dec 9 8)
		(inc 9 10)
		(dec 10 9)
		(not (finished 0))
		(on-chef-island ingredient-flour 0 0)
		(on-chef-island ingredient-sugar 0 0)
		(on-chef-island ingredient-eggs 0 0)
		(on-chef-island ingredient-butter 0 0)
		(on-chef-island ingredient-milk 0 0)
		(not (finished 1))
		(on-chef-island ingredient-flour 0 1)
		(on-chef-island ingredient-sugar 0 1)
		(on-chef-island ingredient-eggs 0 1)
		(on-chef-island ingredient-butter 0 1)
		(on-chef-island ingredient-milk 0 1)
		(not (finished 2))
		(on-chef-island ingredient-flour 0 2)
		(on-chef-island ingredient-sugar 0 2)
		(on-chef-island ingredient-eggs 0 2)
		(on-chef-island ingredient-butter 0 2)
		(on-chef-island ingredient-milk 0 2)
		(on-recipe ingredient-flour 2 recipe-cake)
		(on-recipe ingredient-sugar 1 recipe-cake)
		(on-recipe ingredient-eggs 3 recipe-cake)
		(on-recipe ingredient-butter 1 recipe-cake)
		(not-on-recipe ingredient-milk recipe-cake)
		(on-recipe ingredient-flour 1 recipe-pancakes)
		(on-recipe ingredient-sugar 1 recipe-pancakes)
		(on-recipe ingredient-eggs 1 recipe-pancakes)
		(on-recipe ingredient-milk 1 recipe-pancakes)
		(not-on-recipe ingredient-butter recipe-pancakes)
		(on-recipe ingredient-flour 2 recipe-cookies)
		(on-recipe ingredient-sugar 2 recipe-cookies)
		(on-recipe ingredient-eggs 2 recipe-cookies)
		(on-recipe ingredient-butter 2 recipe-cookies)
		(not-on-recipe ingredient-milk recipe-cookies)
		(on-stock ingredient-flour 10)
		(on-stock ingredient-sugar 10)
		(on-stock ingredient-eggs 10)
		(on-stock ingredient-butter 10)
		(on-stock ingredient-milk 10)
		(can-accept costumer-John recipe-cake)
		(can-accept costumer-John recipe-pancakes)
		(num-refused-recipes costumer-John 0)
		(num-recipes-to-refuse costumer-John 1)
		(can-accept costumer-Alice recipe-cookies)
		(num-refused-recipes costumer-Alice 0)
		(num-recipes-to-refuse costumer-Alice 0)
		(can-accept costumer-Bob recipe-cake)
		(can-accept costumer-Bob recipe-cookies)
		(num-refused-recipes costumer-Bob 0)
		(num-recipes-to-refuse costumer-Bob 1)

	)
	(:goal
		(and
			(satisfied costumer-John)
			(satisfied costumer-Alice)
			(satisfied costumer-Bob)
		)
	)
)
