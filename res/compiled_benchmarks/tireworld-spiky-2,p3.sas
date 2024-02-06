begin_version
3
end_version
begin_metric
0
end_metric
6
begin_variable
var0
-1
2
Atom flat-tire()
NegatedAtom flat-tire()
end_variable
begin_variable
var1
-1
2
Atom has-many-spares(0)
Atom has-many-spares(1)
end_variable
begin_variable
var2
-1
2
Atom tire-at(a)
NegatedAtom tire-at(a)
end_variable
begin_variable
var3
-1
2
Atom tire-at(b)
NegatedAtom tire-at(b)
end_variable
begin_variable
var4
-1
2
Atom tire-at(c)
NegatedAtom tire-at(c)
end_variable
begin_variable
var5
-1
3
Atom vehicle-at(a)
Atom vehicle-at(b)
Atom vehicle-at(c)
end_variable
2
begin_mutex_group
2
1 0
1 1
end_mutex_group
begin_mutex_group
3
5 0
5 1
5 2
end_mutex_group
begin_state
1
0
0
1
1
0
end_state
begin_goal
1
5 2
end_goal
12
begin_operator
drop-tire a 0 1
1
5 0
2
0 1 1 0
0 2 1 0
0
end_operator
begin_operator
drop-tire b 0 1
1
5 1
2
0 1 1 0
0 3 1 0
0
end_operator
begin_operator
drop-tire c 0 1
1
5 2
2
0 1 1 0
0 4 1 0
0
end_operator
begin_operator
fix 0 1
0
2
0 0 0 1
0 1 1 0
0
end_operator
begin_operator
load-tire a 0 1
1
5 0
2
0 1 0 1
0 2 0 1
0
end_operator
begin_operator
load-tire b 0 1
1
5 1
2
0 1 0 1
0 3 0 1
0
end_operator
begin_operator
load-tire c 0 1
1
5 2
2
0 1 0 1
0 4 0 1
0
end_operator
begin_operator
move-car-normal b c
1
0 1
1
0 5 1 2
0
end_operator
begin_operator
move-car-spiky a b
0
2
0 0 1 0
0 5 0 1
0
end_operator
begin_operator
move-car-spiky a b
1
0 1
1
0 5 0 1
0
end_operator
begin_operator
move-car-spiky b a
0
2
0 0 1 0
0 5 1 0
0
end_operator
begin_operator
move-car-spiky b a
1
0 1
1
0 5 1 0
0
end_operator
0
