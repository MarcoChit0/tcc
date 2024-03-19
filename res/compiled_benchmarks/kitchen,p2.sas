begin_version
3
end_version
begin_metric
0
end_metric
12
begin_variable
var0
-1
3
Atom can-accept(costumer-john, recipe-cake)
Atom consumed(recipe-cake)
<none of those>
end_variable
begin_variable
var1
-1
3
Atom can-accept(costumer-john, recipe-pancakes)
Atom consumed(recipe-pancakes)
<none of those>
end_variable
begin_variable
var2
-1
2
Atom num-refused-recipes(costumer-john, 0)
Atom num-refused-recipes(costumer-john, 1)
end_variable
begin_variable
var3
-1
3
Atom on-chef-island(ingredient-flour, 0)
Atom on-chef-island(ingredient-flour, 1)
Atom on-chef-island(ingredient-flour, 2)
end_variable
begin_variable
var4
-1
3
Atom on-stock(ingredient-flour, 0)
Atom on-stock(ingredient-flour, 1)
Atom on-stock(ingredient-flour, 2)
end_variable
begin_variable
var5
-1
2
Atom prepared(recipe-cake)
NegatedAtom prepared(recipe-cake)
end_variable
begin_variable
var6
-1
2
Atom prepared(recipe-pancakes)
NegatedAtom prepared(recipe-pancakes)
end_variable
begin_variable
var7
-1
2
Atom properly-added(ingredient-flour, recipe-cake)
NegatedAtom properly-added(ingredient-flour, recipe-cake)
end_variable
begin_variable
var8
-1
2
Atom properly-added(ingredient-flour, recipe-pancakes)
NegatedAtom properly-added(ingredient-flour, recipe-pancakes)
end_variable
begin_variable
var9
-1
2
Atom satisfied(costumer-john)
NegatedAtom satisfied(costumer-john)
end_variable
begin_variable
var10
-1
2
Atom thrashed(recipe-cake)
NegatedAtom thrashed(recipe-cake)
end_variable
begin_variable
var11
-1
2
Atom thrashed(recipe-pancakes)
NegatedAtom thrashed(recipe-pancakes)
end_variable
5
begin_mutex_group
2
0 0
0 1
end_mutex_group
begin_mutex_group
2
1 0
1 1
end_mutex_group
begin_mutex_group
2
2 0
2 1
end_mutex_group
begin_mutex_group
3
3 0
3 1
3 2
end_mutex_group
begin_mutex_group
3
4 0
4 1
4 2
end_mutex_group
begin_state
0
0
0
0
2
1
1
1
1
1
1
1
end_state
begin_goal
1
9 0
end_goal
28
begin_operator
from-chef-island-to-stock ingredient-flour 0 1 1 0
4
5 1
6 1
7 1
8 1
2
0 3 1 0
0 4 0 1
0
end_operator
begin_operator
from-chef-island-to-stock ingredient-flour 0 1 2 1
4
5 1
6 1
7 1
8 1
2
0 3 2 1
0 4 0 1
0
end_operator
begin_operator
from-chef-island-to-stock ingredient-flour 1 2 1 0
4
5 1
6 1
7 1
8 1
2
0 3 1 0
0 4 1 2
0
end_operator
begin_operator
from-chef-island-to-stock ingredient-flour 1 2 2 1
4
5 1
6 1
7 1
8 1
2
0 3 2 1
0 4 1 2
0
end_operator
begin_operator
from-stock-to-chef-island ingredient-flour 1 0 0 1
4
5 1
6 1
7 1
8 1
2
0 3 0 1
0 4 1 0
0
end_operator
begin_operator
from-stock-to-chef-island ingredient-flour 1 0 1 2
4
5 1
6 1
7 1
8 1
2
0 3 1 2
0 4 1 0
0
end_operator
begin_operator
from-stock-to-chef-island ingredient-flour 2 1 0 1
4
5 1
6 1
7 1
8 1
2
0 3 0 1
0 4 2 1
0
end_operator
begin_operator
from-stock-to-chef-island ingredient-flour 2 1 1 2
4
5 1
6 1
7 1
8 1
2
0 3 1 2
0 4 2 1
0
end_operator
begin_operator
offer-not-refusable costumer-john recipe-cake 1
3
2 1
5 0
10 1
2
0 0 0 1
0 9 1 0
0
end_operator
begin_operator
offer-not-refusable costumer-john recipe-pancakes 1
3
2 1
6 0
11 1
2
0 1 0 1
0 9 1 0
0
end_operator
begin_operator
offer-refusable costumer-john recipe-cake 0 1
3
2 0
5 0
10 1
2
0 0 0 1
0 9 1 0
0
end_operator
begin_operator
offer-refusable costumer-john recipe-cake 0 1
3
5 0
9 1
10 1
2
0 0 0 2
0 2 0 1
0
end_operator
begin_operator
offer-refusable costumer-john recipe-pancakes 0 1
3
2 0
6 0
11 1
2
0 1 0 1
0 9 1 0
0
end_operator
begin_operator
offer-refusable costumer-john recipe-pancakes 0 1
3
6 0
9 1
11 1
2
0 1 0 2
0 2 0 1
0
end_operator
begin_operator
remove-prepared-mark recipe-cake
1
7 1
3
1 0 1 0 -1 2
0 5 -1 1
0 10 -1 1
0
end_operator
begin_operator
remove-prepared-mark recipe-pancakes
1
8 1
3
1 1 1 1 -1 2
0 6 -1 1
0 11 -1 1
0
end_operator
begin_operator
remove-properly-added-mark1 ingredient-flour recipe-cake
1
10 0
1
0 7 0 1
0
end_operator
begin_operator
remove-properly-added-mark1 ingredient-flour recipe-pancakes
1
11 0
1
0 8 0 1
0
end_operator
begin_operator
remove-properly-added-mark2 ingredient-flour recipe-cake
1
0 1
1
0 7 0 1
0
end_operator
begin_operator
remove-properly-added-mark2 ingredient-flour recipe-pancakes
1
1 1
1
0 8 0 1
0
end_operator
begin_operator
select-ingredient-that-is-on-recipe ingredient-flour 1 recipe-cake
0
2
0 3 1 0
0 7 -1 0
0
end_operator
begin_operator
select-ingredient-that-is-on-recipe ingredient-flour 1 recipe-pancakes
0
2
0 3 1 0
0 8 -1 0
0
end_operator
begin_operator
select-recipe recipe-cake
2
6 1
7 0
1
0 5 1 0
0
end_operator
begin_operator
select-recipe recipe-pancakes
2
5 1
8 0
1
0 6 1 0
0
end_operator
begin_operator
throw-into-trash_v1 recipe-cake
2
0 0
5 0
1
0 10 1 0
0
end_operator
begin_operator
throw-into-trash_v1 recipe-pancakes
2
1 0
6 0
1
0 11 1 0
0
end_operator
begin_operator
throw-into-trash_v2 recipe-cake
2
0 2
5 0
1
0 10 1 0
0
end_operator
begin_operator
throw-into-trash_v2 recipe-pancakes
2
1 2
6 0
1
0 11 1 0
0
end_operator
0
