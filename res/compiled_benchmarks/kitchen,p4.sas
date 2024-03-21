begin_version
3
end_version
begin_metric
0
end_metric
15
begin_variable
var0
-1
2
Atom can-accept(costumer-john, recipe-cake)
NegatedAtom can-accept(costumer-john, recipe-cake)
end_variable
begin_variable
var1
-1
2
Atom can-accept(costumer-john, recipe-pancakes)
NegatedAtom can-accept(costumer-john, recipe-pancakes)
end_variable
begin_variable
var2
-1
2
Atom finished(0)
NegatedAtom finished(0)
end_variable
begin_variable
var3
-1
2
Atom finished(1)
NegatedAtom finished(1)
end_variable
begin_variable
var4
-1
2
Atom finished(2)
NegatedAtom finished(2)
end_variable
begin_variable
var5
-1
2
Atom num-refused-recipes(costumer-john, 0)
Atom num-refused-recipes(costumer-john, 1)
end_variable
begin_variable
var6
-1
3
Atom on-chef-island(ingredient-eggs, 0, 0)
Atom on-chef-island(ingredient-eggs, 1, 0)
Atom on-chef-island(ingredient-eggs, 2, 0)
end_variable
begin_variable
var7
-1
3
Atom on-chef-island(ingredient-eggs, 0, 1)
Atom on-chef-island(ingredient-eggs, 1, 1)
Atom on-chef-island(ingredient-eggs, 2, 1)
end_variable
begin_variable
var8
-1
3
Atom on-chef-island(ingredient-flour, 0, 0)
Atom on-chef-island(ingredient-flour, 1, 0)
Atom on-chef-island(ingredient-flour, 2, 0)
end_variable
begin_variable
var9
-1
3
Atom on-chef-island(ingredient-flour, 0, 1)
Atom on-chef-island(ingredient-flour, 1, 1)
Atom on-chef-island(ingredient-flour, 2, 1)
end_variable
begin_variable
var10
-1
3
Atom on-stock(ingredient-eggs, 0)
Atom on-stock(ingredient-eggs, 1)
Atom on-stock(ingredient-eggs, 2)
end_variable
begin_variable
var11
-1
3
Atom on-stock(ingredient-flour, 0)
Atom on-stock(ingredient-flour, 1)
Atom on-stock(ingredient-flour, 2)
end_variable
begin_variable
var12
-1
2
Atom prepared(recipe-cake)
NegatedAtom prepared(recipe-cake)
end_variable
begin_variable
var13
-1
2
Atom prepared(recipe-pancakes)
NegatedAtom prepared(recipe-pancakes)
end_variable
begin_variable
var14
-1
2
Atom satisfied(costumer-john)
NegatedAtom satisfied(costumer-john)
end_variable
7
begin_mutex_group
2
5 0
5 1
end_mutex_group
begin_mutex_group
3
6 0
6 1
6 2
end_mutex_group
begin_mutex_group
3
7 0
7 1
7 2
end_mutex_group
begin_mutex_group
3
8 0
8 1
8 2
end_mutex_group
begin_mutex_group
3
9 0
9 1
9 2
end_mutex_group
begin_mutex_group
3
10 0
10 1
10 2
end_mutex_group
begin_mutex_group
3
11 0
11 1
11 2
end_mutex_group
begin_state
0
0
1
1
1
0
0
0
0
0
2
2
1
1
1
end_state
begin_goal
1
14 0
end_goal
44
begin_operator
from-chef-island-to-stock ingredient-eggs 0 1 1 0 0
1
2 1
2
0 6 1 0
0 10 0 1
0
end_operator
begin_operator
from-chef-island-to-stock ingredient-eggs 0 1 1 0 1
1
3 1
2
0 7 1 0
0 10 0 1
0
end_operator
begin_operator
from-chef-island-to-stock ingredient-eggs 0 1 2 1 0
1
2 1
2
0 6 2 1
0 10 0 1
0
end_operator
begin_operator
from-chef-island-to-stock ingredient-eggs 0 1 2 1 1
1
3 1
2
0 7 2 1
0 10 0 1
0
end_operator
begin_operator
from-chef-island-to-stock ingredient-eggs 1 2 1 0 0
1
2 1
2
0 6 1 0
0 10 1 2
0
end_operator
begin_operator
from-chef-island-to-stock ingredient-eggs 1 2 1 0 1
1
3 1
2
0 7 1 0
0 10 1 2
0
end_operator
begin_operator
from-chef-island-to-stock ingredient-eggs 1 2 2 1 0
1
2 1
2
0 6 2 1
0 10 1 2
0
end_operator
begin_operator
from-chef-island-to-stock ingredient-eggs 1 2 2 1 1
1
3 1
2
0 7 2 1
0 10 1 2
0
end_operator
begin_operator
from-chef-island-to-stock ingredient-flour 0 1 1 0 0
1
2 1
2
0 8 1 0
0 11 0 1
0
end_operator
begin_operator
from-chef-island-to-stock ingredient-flour 0 1 1 0 1
1
3 1
2
0 9 1 0
0 11 0 1
0
end_operator
begin_operator
from-chef-island-to-stock ingredient-flour 0 1 2 1 0
1
2 1
2
0 8 2 1
0 11 0 1
0
end_operator
begin_operator
from-chef-island-to-stock ingredient-flour 0 1 2 1 1
1
3 1
2
0 9 2 1
0 11 0 1
0
end_operator
begin_operator
from-chef-island-to-stock ingredient-flour 1 2 1 0 0
1
2 1
2
0 8 1 0
0 11 1 2
0
end_operator
begin_operator
from-chef-island-to-stock ingredient-flour 1 2 1 0 1
1
3 1
2
0 9 1 0
0 11 1 2
0
end_operator
begin_operator
from-chef-island-to-stock ingredient-flour 1 2 2 1 0
1
2 1
2
0 8 2 1
0 11 1 2
0
end_operator
begin_operator
from-chef-island-to-stock ingredient-flour 1 2 2 1 1
1
3 1
2
0 9 2 1
0 11 1 2
0
end_operator
begin_operator
from-stock-to-chef-island ingredient-eggs 1 0 0 1 0
1
2 1
2
0 6 0 1
0 10 1 0
0
end_operator
begin_operator
from-stock-to-chef-island ingredient-eggs 1 0 0 1 1
1
3 1
2
0 7 0 1
0 10 1 0
0
end_operator
begin_operator
from-stock-to-chef-island ingredient-eggs 1 0 1 2 0
1
2 1
2
0 6 1 2
0 10 1 0
0
end_operator
begin_operator
from-stock-to-chef-island ingredient-eggs 1 0 1 2 1
1
3 1
2
0 7 1 2
0 10 1 0
0
end_operator
begin_operator
from-stock-to-chef-island ingredient-eggs 2 1 0 1 0
1
2 1
2
0 6 0 1
0 10 2 1
0
end_operator
begin_operator
from-stock-to-chef-island ingredient-eggs 2 1 0 1 1
1
3 1
2
0 7 0 1
0 10 2 1
0
end_operator
begin_operator
from-stock-to-chef-island ingredient-eggs 2 1 1 2 0
1
2 1
2
0 6 1 2
0 10 2 1
0
end_operator
begin_operator
from-stock-to-chef-island ingredient-eggs 2 1 1 2 1
1
3 1
2
0 7 1 2
0 10 2 1
0
end_operator
begin_operator
from-stock-to-chef-island ingredient-flour 1 0 0 1 0
1
2 1
2
0 8 0 1
0 11 1 0
0
end_operator
begin_operator
from-stock-to-chef-island ingredient-flour 1 0 0 1 1
1
3 1
2
0 9 0 1
0 11 1 0
0
end_operator
begin_operator
from-stock-to-chef-island ingredient-flour 1 0 1 2 0
1
2 1
2
0 8 1 2
0 11 1 0
0
end_operator
begin_operator
from-stock-to-chef-island ingredient-flour 1 0 1 2 1
1
3 1
2
0 9 1 2
0 11 1 0
0
end_operator
begin_operator
from-stock-to-chef-island ingredient-flour 2 1 0 1 0
1
2 1
2
0 8 0 1
0 11 2 1
0
end_operator
begin_operator
from-stock-to-chef-island ingredient-flour 2 1 0 1 1
1
3 1
2
0 9 0 1
0 11 2 1
0
end_operator
begin_operator
from-stock-to-chef-island ingredient-flour 2 1 1 2 0
1
2 1
2
0 8 1 2
0 11 2 1
0
end_operator
begin_operator
from-stock-to-chef-island ingredient-flour 2 1 1 2 1
1
3 1
2
0 9 1 2
0 11 2 1
0
end_operator
begin_operator
offer-not-refusable costumer-john recipe-cake 1 1
1
5 1
3
0 0 0 1
0 12 0 1
0 14 1 0
0
end_operator
begin_operator
offer-not-refusable costumer-john recipe-pancakes 1 1
1
5 1
3
0 1 0 1
0 13 0 1
0 14 1 0
0
end_operator
begin_operator
offer-refusable costumer-john recipe-cake 0 1 1
1
5 0
3
0 0 0 1
0 12 0 1
0 14 1 0
0
end_operator
begin_operator
offer-refusable costumer-john recipe-cake 0 1 1
2
12 0
14 1
2
0 0 0 1
0 5 0 1
0
end_operator
begin_operator
offer-refusable costumer-john recipe-pancakes 0 1 1
1
5 0
3
0 1 0 1
0 13 0 1
0 14 1 0
0
end_operator
begin_operator
offer-refusable costumer-john recipe-pancakes 0 1 1
2
13 0
14 1
2
0 1 0 1
0 5 0 1
0
end_operator
begin_operator
select-recipe512 recipe-cake 0
0
2
0 2 1 0
0 12 -1 0
0
end_operator
begin_operator
select-recipe512 recipe-cake 1
0
2
0 3 1 0
0 12 -1 0
0
end_operator
begin_operator
select-recipe512 recipe-cake 2
0
2
0 4 1 0
0 12 -1 0
0
end_operator
begin_operator
select-recipe512 recipe-pancakes 0
0
2
0 2 1 0
0 13 -1 0
0
end_operator
begin_operator
select-recipe512 recipe-pancakes 1
0
2
0 3 1 0
0 13 -1 0
0
end_operator
begin_operator
select-recipe512 recipe-pancakes 2
0
2
0 4 1 0
0 13 -1 0
0
end_operator
0
