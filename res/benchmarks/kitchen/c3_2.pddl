(define (problem c3_2-kitchen)
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
		ingredient-butter - ingredient
		ingredient-milk - ingredient
		ingredient-eggs - ingredient
		ingredient-suggar - ingredient
		ingredient-dry yeast - ingredient
		recipe-cake - recipe
		recipe-pancakes - recipe
		recipe-cookie - recipe
		recipe-omelette - recipe
		costumer-John - costumer
		costumer-Jane - costumer
		costumer-Jack - costumer
		costumer-Alice - costumer
		costumer-Bob - costumer
		costumer-Cleber - costumer

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
		(next 9 10)
		(not (finished 0))
		(on-chef-island ingredient-flour 0 0)
		(on-chef-island ingredient-butter 0 0)
		(on-chef-island ingredient-milk 0 0)
		(on-chef-island ingredient-eggs 0 0)
		(on-chef-island ingredient-suggar 0 0)
		(on-chef-island ingredient-dry yeast 0 0)
		(not (finished 1))
		(on-chef-island ingredient-flour 0 1)
		(on-chef-island ingredient-butter 0 1)
		(on-chef-island ingredient-milk 0 1)
		(on-chef-island ingredient-eggs 0 1)
		(on-chef-island ingredient-suggar 0 1)
		(on-chef-island ingredient-dry yeast 0 1)
		(not (finished 2))
		(on-chef-island ingredient-flour 0 2)
		(on-chef-island ingredient-butter 0 2)
		(on-chef-island ingredient-milk 0 2)
		(on-chef-island ingredient-eggs 0 2)
		(on-chef-island ingredient-suggar 0 2)
		(on-chef-island ingredient-dry yeast 0 2)
		(not (finished 3))
		(on-chef-island ingredient-flour 0 3)
		(on-chef-island ingredient-butter 0 3)
		(on-chef-island ingredient-milk 0 3)
		(on-chef-island ingredient-eggs 0 3)
		(on-chef-island ingredient-suggar 0 3)
		(on-chef-island ingredient-dry yeast 0 3)
		(not (finished 4))
		(on-chef-island ingredient-flour 0 4)
		(on-chef-island ingredient-butter 0 4)
		(on-chef-island ingredient-milk 0 4)
		(on-chef-island ingredient-eggs 0 4)
		(on-chef-island ingredient-suggar 0 4)
		(on-chef-island ingredient-dry yeast 0 4)
		(not (finished 5))
		(on-chef-island ingredient-flour 0 5)
		(on-chef-island ingredient-butter 0 5)
		(on-chef-island ingredient-milk 0 5)
		(on-chef-island ingredient-eggs 0 5)
		(on-chef-island ingredient-suggar 0 5)
		(on-chef-island ingredient-dry yeast 0 5)
		(not (finished 6))
		(on-chef-island ingredient-flour 0 6)
		(on-chef-island ingredient-butter 0 6)
		(on-chef-island ingredient-milk 0 6)
		(on-chef-island ingredient-eggs 0 6)
		(on-chef-island ingredient-suggar 0 6)
		(on-chef-island ingredient-dry yeast 0 6)
		(not (finished 7))
		(on-chef-island ingredient-flour 0 7)
		(on-chef-island ingredient-butter 0 7)
		(on-chef-island ingredient-milk 0 7)
		(on-chef-island ingredient-eggs 0 7)
		(on-chef-island ingredient-suggar 0 7)
		(on-chef-island ingredient-dry yeast 0 7)
		(on-recipe ingredient-flour 2 recipe-cake)
		(on-recipe ingredient-butter 1 recipe-cake)
		(on-recipe ingredient-suggar 1 recipe-cake)
		(on-recipe ingredient-dry yeast 1 recipe-cake)
		(not-on-recipe ingredient-milk recipe-cake)
		(not-on-recipe ingredient-eggs recipe-cake)
		(not-on-recipe ingredient-sugar recipe-cake)
		(on-recipe ingredient-flour 1 recipe-pancakes)
		(on-recipe ingredient-milk 1 recipe-pancakes)
		(on-recipe ingredient-butter 1 recipe-pancakes)
		(not-on-recipe ingredient-eggs recipe-pancakes)
		(not-on-recipe ingredient-sugar recipe-pancakes)
		(not-on-recipe ingredient-dry yeast recipe-pancakes)
		(not-on-recipe ingredient-suggar recipe-pancakes)
		(on-recipe ingredient-flour 1 recipe-cookie)
		(on-recipe ingredient-milk 1 recipe-cookie)
		(on-recipe ingredient-eggs 1 recipe-cookie)
		(on-recipe ingredient-sugar 1 recipe-cookie)
		(on-recipe ingredient-butter 1 recipe-cookie)
		(on-recipe ingredient-dry yeast 1 recipe-cookie)
		(not-on-recipe ingredient-suggar recipe-cookie)
		(on-recipe ingredient-eggs 3 recipe-omelette)
		(on-recipe ingredient-butter 1 recipe-omelette)
		(not-on-recipe ingredient-dry yeast recipe-omelette)
		(not-on-recipe ingredient-flour recipe-omelette)
		(not-on-recipe ingredient-suggar recipe-omelette)
		(not-on-recipe ingredient-milk recipe-omelette)
		(not-on-recipe ingredient-sugar recipe-omelette)
		(on-stock ingredient-flour 10)
		(on-stock ingredient-butter 8)
		(on-stock ingredient-milk 6)
		(on-stock ingredient-eggs 10)
		(on-stock ingredient-suggar 6)
		(on-stock ingredient-dry yeast 6)
		(can-accept costumer-John recipe-cake)
		(can-accept costumer-John recipe-pancakes)
		(num-recipes-to-refuse costumer-John 1)
		(can-accept costumer-Jane recipe-cookie)
		(can-accept costumer-Jane recipe-omelette)
		(num-recipes-to-refuse costumer-Jane 1)
		(can-accept costumer-Jack recipe-cake)
		(can-accept costumer-Jack recipe-cookie)
		(num-recipes-to-refuse costumer-Jack 1)
		(can-accept costumer-Alice recipe-cake)
		(can-accept costumer-Alice recipe-pancakes)
		(num-recipes-to-refuse costumer-Alice 1)
		(can-accept costumer-Bob recipe-cookie)
		(can-accept costumer-Bob recipe-omelette)
		(num-recipes-to-refuse costumer-Bob 1)
		(can-accept costumer-Cleber recipe-cake)
		(can-accept costumer-Cleber recipe-cookie)
		(num-recipes-to-refuse costumer-Cleber 1)

	)
	(:goal
		(and
			(satisfied costumer-John)
			(satisfied costumer-Jane)
			(satisfied costumer-Jack)
			(satisfied costumer-Alice)
			(satisfied costumer-Bob)
			(satisfied costumer-Cleber)
		)
	)
)
