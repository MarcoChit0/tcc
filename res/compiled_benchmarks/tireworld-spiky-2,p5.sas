begin_version
3
end_version
begin_metric
0
end_metric
11
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
4
Atom has-many-spares(0)
Atom has-many-spares(1)
Atom has-many-spares(2)
Atom has-many-spares(3)
end_variable
begin_variable
var2
-1
2
Atom tire-at(a1)
NegatedAtom tire-at(a1)
end_variable
begin_variable
var3
-1
2
Atom tire-at(b1)
NegatedAtom tire-at(b1)
end_variable
begin_variable
var4
-1
2
Atom tire-at(b2)
NegatedAtom tire-at(b2)
end_variable
begin_variable
var5
-1
2
Atom tire-at(c1)
NegatedAtom tire-at(c1)
end_variable
begin_variable
var6
-1
2
Atom tire-at(c2)
NegatedAtom tire-at(c2)
end_variable
begin_variable
var7
-1
2
Atom tire-at(d1)
NegatedAtom tire-at(d1)
end_variable
begin_variable
var8
-1
2
Atom tire-at(d2)
NegatedAtom tire-at(d2)
end_variable
begin_variable
var9
-1
2
Atom tire-at(d3)
NegatedAtom tire-at(d3)
end_variable
begin_variable
var10
-1
8
Atom vehicle-at(a1)
Atom vehicle-at(b1)
Atom vehicle-at(b2)
Atom vehicle-at(c1)
Atom vehicle-at(c2)
Atom vehicle-at(d1)
Atom vehicle-at(d2)
Atom vehicle-at(d3)
end_variable
2
begin_mutex_group
4
1 0
1 1
1 2
1 3
end_mutex_group
begin_mutex_group
8
10 0
10 1
10 2
10 3
10 4
10 5
10 6
10 7
end_mutex_group
begin_state
1
0
0
0
0
0
0
1
1
1
0
end_state
begin_goal
1
10 7
end_goal
83
begin_operator
drop-tire a1 0 1
1
10 0
2
0 1 1 0
0 2 1 0
0
end_operator
begin_operator
drop-tire a1 1 2
1
10 0
2
0 1 2 1
0 2 1 0
0
end_operator
begin_operator
drop-tire a1 2 3
1
10 0
2
0 1 3 2
0 2 1 0
0
end_operator
begin_operator
drop-tire b1 0 1
1
10 1
2
0 1 1 0
0 3 1 0
0
end_operator
begin_operator
drop-tire b1 1 2
1
10 1
2
0 1 2 1
0 3 1 0
0
end_operator
begin_operator
drop-tire b1 2 3
1
10 1
2
0 1 3 2
0 3 1 0
0
end_operator
begin_operator
drop-tire b2 0 1
1
10 2
2
0 1 1 0
0 4 1 0
0
end_operator
begin_operator
drop-tire b2 1 2
1
10 2
2
0 1 2 1
0 4 1 0
0
end_operator
begin_operator
drop-tire b2 2 3
1
10 2
2
0 1 3 2
0 4 1 0
0
end_operator
begin_operator
drop-tire c1 0 1
1
10 3
2
0 1 1 0
0 5 1 0
0
end_operator
begin_operator
drop-tire c1 1 2
1
10 3
2
0 1 2 1
0 5 1 0
0
end_operator
begin_operator
drop-tire c1 2 3
1
10 3
2
0 1 3 2
0 5 1 0
0
end_operator
begin_operator
drop-tire c2 0 1
1
10 4
2
0 1 1 0
0 6 1 0
0
end_operator
begin_operator
drop-tire c2 1 2
1
10 4
2
0 1 2 1
0 6 1 0
0
end_operator
begin_operator
drop-tire c2 2 3
1
10 4
2
0 1 3 2
0 6 1 0
0
end_operator
begin_operator
drop-tire d1 0 1
1
10 5
2
0 1 1 0
0 7 1 0
0
end_operator
begin_operator
drop-tire d1 1 2
1
10 5
2
0 1 2 1
0 7 1 0
0
end_operator
begin_operator
drop-tire d1 2 3
1
10 5
2
0 1 3 2
0 7 1 0
0
end_operator
begin_operator
drop-tire d2 0 1
1
10 6
2
0 1 1 0
0 8 1 0
0
end_operator
begin_operator
drop-tire d2 1 2
1
10 6
2
0 1 2 1
0 8 1 0
0
end_operator
begin_operator
drop-tire d2 2 3
1
10 6
2
0 1 3 2
0 8 1 0
0
end_operator
begin_operator
drop-tire d3 0 1
1
10 7
2
0 1 1 0
0 9 1 0
0
end_operator
begin_operator
drop-tire d3 1 2
1
10 7
2
0 1 2 1
0 9 1 0
0
end_operator
begin_operator
drop-tire d3 2 3
1
10 7
2
0 1 3 2
0 9 1 0
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
fix 1 2
0
2
0 0 0 1
0 1 2 1
0
end_operator
begin_operator
fix 2 3
0
2
0 0 0 1
0 1 3 2
0
end_operator
begin_operator
load-tire a1 0 1
1
10 0
2
0 1 0 1
0 2 0 1
0
end_operator
begin_operator
load-tire a1 1 2
1
10 0
2
0 1 1 2
0 2 0 1
0
end_operator
begin_operator
load-tire a1 2 3
1
10 0
2
0 1 2 3
0 2 0 1
0
end_operator
begin_operator
load-tire b1 0 1
1
10 1
2
0 1 0 1
0 3 0 1
0
end_operator
begin_operator
load-tire b1 1 2
1
10 1
2
0 1 1 2
0 3 0 1
0
end_operator
begin_operator
load-tire b1 2 3
1
10 1
2
0 1 2 3
0 3 0 1
0
end_operator
begin_operator
load-tire b2 0 1
1
10 2
2
0 1 0 1
0 4 0 1
0
end_operator
begin_operator
load-tire b2 1 2
1
10 2
2
0 1 1 2
0 4 0 1
0
end_operator
begin_operator
load-tire b2 2 3
1
10 2
2
0 1 2 3
0 4 0 1
0
end_operator
begin_operator
load-tire c1 0 1
1
10 3
2
0 1 0 1
0 5 0 1
0
end_operator
begin_operator
load-tire c1 1 2
1
10 3
2
0 1 1 2
0 5 0 1
0
end_operator
begin_operator
load-tire c1 2 3
1
10 3
2
0 1 2 3
0 5 0 1
0
end_operator
begin_operator
load-tire c2 0 1
1
10 4
2
0 1 0 1
0 6 0 1
0
end_operator
begin_operator
load-tire c2 1 2
1
10 4
2
0 1 1 2
0 6 0 1
0
end_operator
begin_operator
load-tire c2 2 3
1
10 4
2
0 1 2 3
0 6 0 1
0
end_operator
begin_operator
load-tire d1 0 1
1
10 5
2
0 1 0 1
0 7 0 1
0
end_operator
begin_operator
load-tire d1 1 2
1
10 5
2
0 1 1 2
0 7 0 1
0
end_operator
begin_operator
load-tire d1 2 3
1
10 5
2
0 1 2 3
0 7 0 1
0
end_operator
begin_operator
load-tire d2 0 1
1
10 6
2
0 1 0 1
0 8 0 1
0
end_operator
begin_operator
load-tire d2 1 2
1
10 6
2
0 1 1 2
0 8 0 1
0
end_operator
begin_operator
load-tire d2 2 3
1
10 6
2
0 1 2 3
0 8 0 1
0
end_operator
begin_operator
load-tire d3 0 1
1
10 7
2
0 1 0 1
0 9 0 1
0
end_operator
begin_operator
load-tire d3 1 2
1
10 7
2
0 1 1 2
0 9 0 1
0
end_operator
begin_operator
load-tire d3 2 3
1
10 7
2
0 1 2 3
0 9 0 1
0
end_operator
begin_operator
move-car-normal b1 b2
1
0 1
1
0 10 1 2
0
end_operator
begin_operator
move-car-normal b2 b1
1
0 1
1
0 10 2 1
0
end_operator
begin_operator
move-car-normal c1 c2
1
0 1
1
0 10 3 4
0
end_operator
begin_operator
move-car-normal c2 c1
1
0 1
1
0 10 4 3
0
end_operator
begin_operator
move-car-spiky a1 b1
0
2
0 0 1 0
0 10 0 1
0
end_operator
begin_operator
move-car-spiky a1 b1
1
0 1
1
0 10 0 1
0
end_operator
begin_operator
move-car-spiky a1 c1
0
2
0 0 1 0
0 10 0 3
0
end_operator
begin_operator
move-car-spiky a1 c1
1
0 1
1
0 10 0 3
0
end_operator
begin_operator
move-car-spiky b1 a1
0
2
0 0 1 0
0 10 1 0
0
end_operator
begin_operator
move-car-spiky b1 a1
1
0 1
1
0 10 1 0
0
end_operator
begin_operator
move-car-spiky b1 c1
0
2
0 0 1 0
0 10 1 3
0
end_operator
begin_operator
move-car-spiky b1 c1
1
0 1
1
0 10 1 3
0
end_operator
begin_operator
move-car-spiky b2 d1
0
2
0 0 1 0
0 10 2 5
0
end_operator
begin_operator
move-car-spiky b2 d1
1
0 1
1
0 10 2 5
0
end_operator
begin_operator
move-car-spiky c1 a1
0
2
0 0 1 0
0 10 3 0
0
end_operator
begin_operator
move-car-spiky c1 a1
1
0 1
1
0 10 3 0
0
end_operator
begin_operator
move-car-spiky c1 b1
0
2
0 0 1 0
0 10 3 1
0
end_operator
begin_operator
move-car-spiky c1 b1
1
0 1
1
0 10 3 1
0
end_operator
begin_operator
move-car-spiky c2 d1
0
2
0 0 1 0
0 10 4 5
0
end_operator
begin_operator
move-car-spiky c2 d1
1
0 1
1
0 10 4 5
0
end_operator
begin_operator
move-car-spiky d1 b2
0
2
0 0 1 0
0 10 5 2
0
end_operator
begin_operator
move-car-spiky d1 b2
1
0 1
1
0 10 5 2
0
end_operator
begin_operator
move-car-spiky d1 c2
0
2
0 0 1 0
0 10 5 4
0
end_operator
begin_operator
move-car-spiky d1 c2
1
0 1
1
0 10 5 4
0
end_operator
begin_operator
move-car-spiky d1 d2
0
2
0 0 1 0
0 10 5 6
0
end_operator
begin_operator
move-car-spiky d1 d2
1
0 1
1
0 10 5 6
0
end_operator
begin_operator
move-car-spiky d2 d1
0
2
0 0 1 0
0 10 6 5
0
end_operator
begin_operator
move-car-spiky d2 d1
1
0 1
1
0 10 6 5
0
end_operator
begin_operator
move-car-spiky d2 d3
0
2
0 0 1 0
0 10 6 7
0
end_operator
begin_operator
move-car-spiky d2 d3
1
0 1
1
0 10 6 7
0
end_operator
begin_operator
move-car-spiky d3 d2
0
2
0 0 1 0
0 10 7 6
0
end_operator
begin_operator
move-car-spiky d3 d2
1
0 1
1
0 10 7 6
0
end_operator
0
