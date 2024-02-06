begin_version
3
end_version
begin_metric
0
end_metric
9
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
3
Atom has-many-spares(0)
Atom has-many-spares(1)
Atom has-many-spares(2)
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
2
Atom tire-at(d)
NegatedAtom tire-at(d)
end_variable
begin_variable
var6
-1
2
Atom tire-at(e)
NegatedAtom tire-at(e)
end_variable
begin_variable
var7
-1
2
Atom tire-at(f)
NegatedAtom tire-at(f)
end_variable
begin_variable
var8
-1
6
Atom vehicle-at(a)
Atom vehicle-at(b)
Atom vehicle-at(c)
Atom vehicle-at(d)
Atom vehicle-at(e)
Atom vehicle-at(f)
end_variable
2
begin_mutex_group
3
1 0
1 1
1 2
end_mutex_group
begin_mutex_group
6
8 0
8 1
8 2
8 3
8 4
8 5
end_mutex_group
begin_state
1
0
1
0
0
1
1
1
0
end_state
begin_goal
1
8 5
end_goal
44
begin_operator
drop-tire a 0 1
1
8 0
2
0 1 1 0
0 2 1 0
0
end_operator
begin_operator
drop-tire a 1 2
1
8 0
2
0 1 2 1
0 2 1 0
0
end_operator
begin_operator
drop-tire b 0 1
1
8 1
2
0 1 1 0
0 3 1 0
0
end_operator
begin_operator
drop-tire b 1 2
1
8 1
2
0 1 2 1
0 3 1 0
0
end_operator
begin_operator
drop-tire c 0 1
1
8 2
2
0 1 1 0
0 4 1 0
0
end_operator
begin_operator
drop-tire c 1 2
1
8 2
2
0 1 2 1
0 4 1 0
0
end_operator
begin_operator
drop-tire d 0 1
1
8 3
2
0 1 1 0
0 5 1 0
0
end_operator
begin_operator
drop-tire d 1 2
1
8 3
2
0 1 2 1
0 5 1 0
0
end_operator
begin_operator
drop-tire e 0 1
1
8 4
2
0 1 1 0
0 6 1 0
0
end_operator
begin_operator
drop-tire e 1 2
1
8 4
2
0 1 2 1
0 6 1 0
0
end_operator
begin_operator
drop-tire f 0 1
1
8 5
2
0 1 1 0
0 7 1 0
0
end_operator
begin_operator
drop-tire f 1 2
1
8 5
2
0 1 2 1
0 7 1 0
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
load-tire a 0 1
1
8 0
2
0 1 0 1
0 2 0 1
0
end_operator
begin_operator
load-tire a 1 2
1
8 0
2
0 1 1 2
0 2 0 1
0
end_operator
begin_operator
load-tire b 0 1
1
8 1
2
0 1 0 1
0 3 0 1
0
end_operator
begin_operator
load-tire b 1 2
1
8 1
2
0 1 1 2
0 3 0 1
0
end_operator
begin_operator
load-tire c 0 1
1
8 2
2
0 1 0 1
0 4 0 1
0
end_operator
begin_operator
load-tire c 1 2
1
8 2
2
0 1 1 2
0 4 0 1
0
end_operator
begin_operator
load-tire d 0 1
1
8 3
2
0 1 0 1
0 5 0 1
0
end_operator
begin_operator
load-tire d 1 2
1
8 3
2
0 1 1 2
0 5 0 1
0
end_operator
begin_operator
load-tire e 0 1
1
8 4
2
0 1 0 1
0 6 0 1
0
end_operator
begin_operator
load-tire e 1 2
1
8 4
2
0 1 1 2
0 6 0 1
0
end_operator
begin_operator
load-tire f 0 1
1
8 5
2
0 1 0 1
0 7 0 1
0
end_operator
begin_operator
load-tire f 1 2
1
8 5
2
0 1 1 2
0 7 0 1
0
end_operator
begin_operator
move-car-normal a b
1
0 1
1
0 8 0 1
0
end_operator
begin_operator
move-car-normal a c
1
0 1
1
0 8 0 2
0
end_operator
begin_operator
move-car-normal b a
1
0 1
1
0 8 1 0
0
end_operator
begin_operator
move-car-normal c a
1
0 1
1
0 8 2 0
0
end_operator
begin_operator
move-car-normal e f
1
0 1
1
0 8 4 5
0
end_operator
begin_operator
move-car-normal f e
1
0 1
1
0 8 5 4
0
end_operator
begin_operator
move-car-spiky b d
0
2
0 0 1 0
0 8 1 3
0
end_operator
begin_operator
move-car-spiky b d
1
0 1
1
0 8 1 3
0
end_operator
begin_operator
move-car-spiky c d
0
2
0 0 1 0
0 8 2 3
0
end_operator
begin_operator
move-car-spiky c d
1
0 1
1
0 8 2 3
0
end_operator
begin_operator
move-car-spiky d b
0
2
0 0 1 0
0 8 3 1
0
end_operator
begin_operator
move-car-spiky d b
1
0 1
1
0 8 3 1
0
end_operator
begin_operator
move-car-spiky d c
0
2
0 0 1 0
0 8 3 2
0
end_operator
begin_operator
move-car-spiky d c
1
0 1
1
0 8 3 2
0
end_operator
begin_operator
move-car-spiky d e
0
2
0 0 1 0
0 8 3 4
0
end_operator
begin_operator
move-car-spiky d e
1
0 1
1
0 8 3 4
0
end_operator
begin_operator
move-car-spiky e d
0
2
0 0 1 0
0 8 4 3
0
end_operator
begin_operator
move-car-spiky e d
1
0 1
1
0 8 4 3
0
end_operator
0
