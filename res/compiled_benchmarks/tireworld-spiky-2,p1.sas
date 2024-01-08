begin_version
3
end_version
begin_metric
0
end_metric
19
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
8
Atom has-many-spares(0)
Atom has-many-spares(1)
Atom has-many-spares(2)
Atom has-many-spares(3)
Atom has-many-spares(4)
Atom has-many-spares(5)
Atom has-many-spares(6)
Atom has-many-spares(7)
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
Atom tire-at(a2)
NegatedAtom tire-at(a2)
end_variable
begin_variable
var4
-1
2
Atom tire-at(b1)
NegatedAtom tire-at(b1)
end_variable
begin_variable
var5
-1
2
Atom tire-at(b2)
NegatedAtom tire-at(b2)
end_variable
begin_variable
var6
-1
2
Atom tire-at(b3)
NegatedAtom tire-at(b3)
end_variable
begin_variable
var7
-1
2
Atom tire-at(b4)
NegatedAtom tire-at(b4)
end_variable
begin_variable
var8
-1
2
Atom tire-at(b5)
NegatedAtom tire-at(b5)
end_variable
begin_variable
var9
-1
2
Atom tire-at(c1)
NegatedAtom tire-at(c1)
end_variable
begin_variable
var10
-1
2
Atom tire-at(c2)
NegatedAtom tire-at(c2)
end_variable
begin_variable
var11
-1
2
Atom tire-at(c3)
NegatedAtom tire-at(c3)
end_variable
begin_variable
var12
-1
2
Atom tire-at(c4)
NegatedAtom tire-at(c4)
end_variable
begin_variable
var13
-1
2
Atom tire-at(c5)
NegatedAtom tire-at(c5)
end_variable
begin_variable
var14
-1
2
Atom tire-at(d1)
NegatedAtom tire-at(d1)
end_variable
begin_variable
var15
-1
2
Atom tire-at(d2)
NegatedAtom tire-at(d2)
end_variable
begin_variable
var16
-1
2
Atom tire-at(d3)
NegatedAtom tire-at(d3)
end_variable
begin_variable
var17
-1
2
Atom tire-at(d4)
NegatedAtom tire-at(d4)
end_variable
begin_variable
var18
-1
16
Atom vehicle-at(a1)
Atom vehicle-at(a2)
Atom vehicle-at(b1)
Atom vehicle-at(b2)
Atom vehicle-at(b3)
Atom vehicle-at(b4)
Atom vehicle-at(b5)
Atom vehicle-at(c1)
Atom vehicle-at(c2)
Atom vehicle-at(c3)
Atom vehicle-at(c4)
Atom vehicle-at(c5)
Atom vehicle-at(d1)
Atom vehicle-at(d2)
Atom vehicle-at(d3)
Atom vehicle-at(d4)
end_variable
2
begin_mutex_group
8
1 0
1 1
1 2
1 3
1 4
1 5
1 6
1 7
end_mutex_group
begin_mutex_group
16
18 0
18 1
18 2
18 3
18 4
18 5
18 6
18 7
18 8
18 9
18 10
18 11
18 12
18 13
18 14
18 15
end_mutex_group
begin_state
1
0
1
0
1
0
0
0
1
1
0
0
0
1
1
1
1
1
0
end_state
begin_goal
1
18 15
end_goal
279
begin_operator
drop-tire a1 0 1
1
18 0
2
0 1 1 0
0 2 1 0
0
end_operator
begin_operator
drop-tire a1 1 2
1
18 0
2
0 1 2 1
0 2 1 0
0
end_operator
begin_operator
drop-tire a1 2 3
1
18 0
2
0 1 3 2
0 2 1 0
0
end_operator
begin_operator
drop-tire a1 3 4
1
18 0
2
0 1 4 3
0 2 1 0
0
end_operator
begin_operator
drop-tire a1 4 5
1
18 0
2
0 1 5 4
0 2 1 0
0
end_operator
begin_operator
drop-tire a1 5 6
1
18 0
2
0 1 6 5
0 2 1 0
0
end_operator
begin_operator
drop-tire a1 6 7
1
18 0
2
0 1 7 6
0 2 1 0
0
end_operator
begin_operator
drop-tire a2 0 1
1
18 1
2
0 1 1 0
0 3 1 0
0
end_operator
begin_operator
drop-tire a2 1 2
1
18 1
2
0 1 2 1
0 3 1 0
0
end_operator
begin_operator
drop-tire a2 2 3
1
18 1
2
0 1 3 2
0 3 1 0
0
end_operator
begin_operator
drop-tire a2 3 4
1
18 1
2
0 1 4 3
0 3 1 0
0
end_operator
begin_operator
drop-tire a2 4 5
1
18 1
2
0 1 5 4
0 3 1 0
0
end_operator
begin_operator
drop-tire a2 5 6
1
18 1
2
0 1 6 5
0 3 1 0
0
end_operator
begin_operator
drop-tire a2 6 7
1
18 1
2
0 1 7 6
0 3 1 0
0
end_operator
begin_operator
drop-tire b1 0 1
1
18 2
2
0 1 1 0
0 4 1 0
0
end_operator
begin_operator
drop-tire b1 1 2
1
18 2
2
0 1 2 1
0 4 1 0
0
end_operator
begin_operator
drop-tire b1 2 3
1
18 2
2
0 1 3 2
0 4 1 0
0
end_operator
begin_operator
drop-tire b1 3 4
1
18 2
2
0 1 4 3
0 4 1 0
0
end_operator
begin_operator
drop-tire b1 4 5
1
18 2
2
0 1 5 4
0 4 1 0
0
end_operator
begin_operator
drop-tire b1 5 6
1
18 2
2
0 1 6 5
0 4 1 0
0
end_operator
begin_operator
drop-tire b1 6 7
1
18 2
2
0 1 7 6
0 4 1 0
0
end_operator
begin_operator
drop-tire b2 0 1
1
18 3
2
0 1 1 0
0 5 1 0
0
end_operator
begin_operator
drop-tire b2 1 2
1
18 3
2
0 1 2 1
0 5 1 0
0
end_operator
begin_operator
drop-tire b2 2 3
1
18 3
2
0 1 3 2
0 5 1 0
0
end_operator
begin_operator
drop-tire b2 3 4
1
18 3
2
0 1 4 3
0 5 1 0
0
end_operator
begin_operator
drop-tire b2 4 5
1
18 3
2
0 1 5 4
0 5 1 0
0
end_operator
begin_operator
drop-tire b2 5 6
1
18 3
2
0 1 6 5
0 5 1 0
0
end_operator
begin_operator
drop-tire b2 6 7
1
18 3
2
0 1 7 6
0 5 1 0
0
end_operator
begin_operator
drop-tire b3 0 1
1
18 4
2
0 1 1 0
0 6 1 0
0
end_operator
begin_operator
drop-tire b3 1 2
1
18 4
2
0 1 2 1
0 6 1 0
0
end_operator
begin_operator
drop-tire b3 2 3
1
18 4
2
0 1 3 2
0 6 1 0
0
end_operator
begin_operator
drop-tire b3 3 4
1
18 4
2
0 1 4 3
0 6 1 0
0
end_operator
begin_operator
drop-tire b3 4 5
1
18 4
2
0 1 5 4
0 6 1 0
0
end_operator
begin_operator
drop-tire b3 5 6
1
18 4
2
0 1 6 5
0 6 1 0
0
end_operator
begin_operator
drop-tire b3 6 7
1
18 4
2
0 1 7 6
0 6 1 0
0
end_operator
begin_operator
drop-tire b4 0 1
1
18 5
2
0 1 1 0
0 7 1 0
0
end_operator
begin_operator
drop-tire b4 1 2
1
18 5
2
0 1 2 1
0 7 1 0
0
end_operator
begin_operator
drop-tire b4 2 3
1
18 5
2
0 1 3 2
0 7 1 0
0
end_operator
begin_operator
drop-tire b4 3 4
1
18 5
2
0 1 4 3
0 7 1 0
0
end_operator
begin_operator
drop-tire b4 4 5
1
18 5
2
0 1 5 4
0 7 1 0
0
end_operator
begin_operator
drop-tire b4 5 6
1
18 5
2
0 1 6 5
0 7 1 0
0
end_operator
begin_operator
drop-tire b4 6 7
1
18 5
2
0 1 7 6
0 7 1 0
0
end_operator
begin_operator
drop-tire b5 0 1
1
18 6
2
0 1 1 0
0 8 1 0
0
end_operator
begin_operator
drop-tire b5 1 2
1
18 6
2
0 1 2 1
0 8 1 0
0
end_operator
begin_operator
drop-tire b5 2 3
1
18 6
2
0 1 3 2
0 8 1 0
0
end_operator
begin_operator
drop-tire b5 3 4
1
18 6
2
0 1 4 3
0 8 1 0
0
end_operator
begin_operator
drop-tire b5 4 5
1
18 6
2
0 1 5 4
0 8 1 0
0
end_operator
begin_operator
drop-tire b5 5 6
1
18 6
2
0 1 6 5
0 8 1 0
0
end_operator
begin_operator
drop-tire b5 6 7
1
18 6
2
0 1 7 6
0 8 1 0
0
end_operator
begin_operator
drop-tire c1 0 1
1
18 7
2
0 1 1 0
0 9 1 0
0
end_operator
begin_operator
drop-tire c1 1 2
1
18 7
2
0 1 2 1
0 9 1 0
0
end_operator
begin_operator
drop-tire c1 2 3
1
18 7
2
0 1 3 2
0 9 1 0
0
end_operator
begin_operator
drop-tire c1 3 4
1
18 7
2
0 1 4 3
0 9 1 0
0
end_operator
begin_operator
drop-tire c1 4 5
1
18 7
2
0 1 5 4
0 9 1 0
0
end_operator
begin_operator
drop-tire c1 5 6
1
18 7
2
0 1 6 5
0 9 1 0
0
end_operator
begin_operator
drop-tire c1 6 7
1
18 7
2
0 1 7 6
0 9 1 0
0
end_operator
begin_operator
drop-tire c2 0 1
1
18 8
2
0 1 1 0
0 10 1 0
0
end_operator
begin_operator
drop-tire c2 1 2
1
18 8
2
0 1 2 1
0 10 1 0
0
end_operator
begin_operator
drop-tire c2 2 3
1
18 8
2
0 1 3 2
0 10 1 0
0
end_operator
begin_operator
drop-tire c2 3 4
1
18 8
2
0 1 4 3
0 10 1 0
0
end_operator
begin_operator
drop-tire c2 4 5
1
18 8
2
0 1 5 4
0 10 1 0
0
end_operator
begin_operator
drop-tire c2 5 6
1
18 8
2
0 1 6 5
0 10 1 0
0
end_operator
begin_operator
drop-tire c2 6 7
1
18 8
2
0 1 7 6
0 10 1 0
0
end_operator
begin_operator
drop-tire c3 0 1
1
18 9
2
0 1 1 0
0 11 1 0
0
end_operator
begin_operator
drop-tire c3 1 2
1
18 9
2
0 1 2 1
0 11 1 0
0
end_operator
begin_operator
drop-tire c3 2 3
1
18 9
2
0 1 3 2
0 11 1 0
0
end_operator
begin_operator
drop-tire c3 3 4
1
18 9
2
0 1 4 3
0 11 1 0
0
end_operator
begin_operator
drop-tire c3 4 5
1
18 9
2
0 1 5 4
0 11 1 0
0
end_operator
begin_operator
drop-tire c3 5 6
1
18 9
2
0 1 6 5
0 11 1 0
0
end_operator
begin_operator
drop-tire c3 6 7
1
18 9
2
0 1 7 6
0 11 1 0
0
end_operator
begin_operator
drop-tire c4 0 1
1
18 10
2
0 1 1 0
0 12 1 0
0
end_operator
begin_operator
drop-tire c4 1 2
1
18 10
2
0 1 2 1
0 12 1 0
0
end_operator
begin_operator
drop-tire c4 2 3
1
18 10
2
0 1 3 2
0 12 1 0
0
end_operator
begin_operator
drop-tire c4 3 4
1
18 10
2
0 1 4 3
0 12 1 0
0
end_operator
begin_operator
drop-tire c4 4 5
1
18 10
2
0 1 5 4
0 12 1 0
0
end_operator
begin_operator
drop-tire c4 5 6
1
18 10
2
0 1 6 5
0 12 1 0
0
end_operator
begin_operator
drop-tire c4 6 7
1
18 10
2
0 1 7 6
0 12 1 0
0
end_operator
begin_operator
drop-tire c5 0 1
1
18 11
2
0 1 1 0
0 13 1 0
0
end_operator
begin_operator
drop-tire c5 1 2
1
18 11
2
0 1 2 1
0 13 1 0
0
end_operator
begin_operator
drop-tire c5 2 3
1
18 11
2
0 1 3 2
0 13 1 0
0
end_operator
begin_operator
drop-tire c5 3 4
1
18 11
2
0 1 4 3
0 13 1 0
0
end_operator
begin_operator
drop-tire c5 4 5
1
18 11
2
0 1 5 4
0 13 1 0
0
end_operator
begin_operator
drop-tire c5 5 6
1
18 11
2
0 1 6 5
0 13 1 0
0
end_operator
begin_operator
drop-tire c5 6 7
1
18 11
2
0 1 7 6
0 13 1 0
0
end_operator
begin_operator
drop-tire d1 0 1
1
18 12
2
0 1 1 0
0 14 1 0
0
end_operator
begin_operator
drop-tire d1 1 2
1
18 12
2
0 1 2 1
0 14 1 0
0
end_operator
begin_operator
drop-tire d1 2 3
1
18 12
2
0 1 3 2
0 14 1 0
0
end_operator
begin_operator
drop-tire d1 3 4
1
18 12
2
0 1 4 3
0 14 1 0
0
end_operator
begin_operator
drop-tire d1 4 5
1
18 12
2
0 1 5 4
0 14 1 0
0
end_operator
begin_operator
drop-tire d1 5 6
1
18 12
2
0 1 6 5
0 14 1 0
0
end_operator
begin_operator
drop-tire d1 6 7
1
18 12
2
0 1 7 6
0 14 1 0
0
end_operator
begin_operator
drop-tire d2 0 1
1
18 13
2
0 1 1 0
0 15 1 0
0
end_operator
begin_operator
drop-tire d2 1 2
1
18 13
2
0 1 2 1
0 15 1 0
0
end_operator
begin_operator
drop-tire d2 2 3
1
18 13
2
0 1 3 2
0 15 1 0
0
end_operator
begin_operator
drop-tire d2 3 4
1
18 13
2
0 1 4 3
0 15 1 0
0
end_operator
begin_operator
drop-tire d2 4 5
1
18 13
2
0 1 5 4
0 15 1 0
0
end_operator
begin_operator
drop-tire d2 5 6
1
18 13
2
0 1 6 5
0 15 1 0
0
end_operator
begin_operator
drop-tire d2 6 7
1
18 13
2
0 1 7 6
0 15 1 0
0
end_operator
begin_operator
drop-tire d3 0 1
1
18 14
2
0 1 1 0
0 16 1 0
0
end_operator
begin_operator
drop-tire d3 1 2
1
18 14
2
0 1 2 1
0 16 1 0
0
end_operator
begin_operator
drop-tire d3 2 3
1
18 14
2
0 1 3 2
0 16 1 0
0
end_operator
begin_operator
drop-tire d3 3 4
1
18 14
2
0 1 4 3
0 16 1 0
0
end_operator
begin_operator
drop-tire d3 4 5
1
18 14
2
0 1 5 4
0 16 1 0
0
end_operator
begin_operator
drop-tire d3 5 6
1
18 14
2
0 1 6 5
0 16 1 0
0
end_operator
begin_operator
drop-tire d3 6 7
1
18 14
2
0 1 7 6
0 16 1 0
0
end_operator
begin_operator
drop-tire d4 0 1
1
18 15
2
0 1 1 0
0 17 1 0
0
end_operator
begin_operator
drop-tire d4 1 2
1
18 15
2
0 1 2 1
0 17 1 0
0
end_operator
begin_operator
drop-tire d4 2 3
1
18 15
2
0 1 3 2
0 17 1 0
0
end_operator
begin_operator
drop-tire d4 3 4
1
18 15
2
0 1 4 3
0 17 1 0
0
end_operator
begin_operator
drop-tire d4 4 5
1
18 15
2
0 1 5 4
0 17 1 0
0
end_operator
begin_operator
drop-tire d4 5 6
1
18 15
2
0 1 6 5
0 17 1 0
0
end_operator
begin_operator
drop-tire d4 6 7
1
18 15
2
0 1 7 6
0 17 1 0
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
fix 3 4
0
2
0 0 0 1
0 1 4 3
0
end_operator
begin_operator
fix 4 5
0
2
0 0 0 1
0 1 5 4
0
end_operator
begin_operator
fix 5 6
0
2
0 0 0 1
0 1 6 5
0
end_operator
begin_operator
fix 6 7
0
2
0 0 0 1
0 1 7 6
0
end_operator
begin_operator
load-tire a1 0 1
1
18 0
2
0 1 0 1
0 2 0 1
0
end_operator
begin_operator
load-tire a1 1 2
1
18 0
2
0 1 1 2
0 2 0 1
0
end_operator
begin_operator
load-tire a1 2 3
1
18 0
2
0 1 2 3
0 2 0 1
0
end_operator
begin_operator
load-tire a1 3 4
1
18 0
2
0 1 3 4
0 2 0 1
0
end_operator
begin_operator
load-tire a1 4 5
1
18 0
2
0 1 4 5
0 2 0 1
0
end_operator
begin_operator
load-tire a1 5 6
1
18 0
2
0 1 5 6
0 2 0 1
0
end_operator
begin_operator
load-tire a1 6 7
1
18 0
2
0 1 6 7
0 2 0 1
0
end_operator
begin_operator
load-tire a2 0 1
1
18 1
2
0 1 0 1
0 3 0 1
0
end_operator
begin_operator
load-tire a2 1 2
1
18 1
2
0 1 1 2
0 3 0 1
0
end_operator
begin_operator
load-tire a2 2 3
1
18 1
2
0 1 2 3
0 3 0 1
0
end_operator
begin_operator
load-tire a2 3 4
1
18 1
2
0 1 3 4
0 3 0 1
0
end_operator
begin_operator
load-tire a2 4 5
1
18 1
2
0 1 4 5
0 3 0 1
0
end_operator
begin_operator
load-tire a2 5 6
1
18 1
2
0 1 5 6
0 3 0 1
0
end_operator
begin_operator
load-tire a2 6 7
1
18 1
2
0 1 6 7
0 3 0 1
0
end_operator
begin_operator
load-tire b1 0 1
1
18 2
2
0 1 0 1
0 4 0 1
0
end_operator
begin_operator
load-tire b1 1 2
1
18 2
2
0 1 1 2
0 4 0 1
0
end_operator
begin_operator
load-tire b1 2 3
1
18 2
2
0 1 2 3
0 4 0 1
0
end_operator
begin_operator
load-tire b1 3 4
1
18 2
2
0 1 3 4
0 4 0 1
0
end_operator
begin_operator
load-tire b1 4 5
1
18 2
2
0 1 4 5
0 4 0 1
0
end_operator
begin_operator
load-tire b1 5 6
1
18 2
2
0 1 5 6
0 4 0 1
0
end_operator
begin_operator
load-tire b1 6 7
1
18 2
2
0 1 6 7
0 4 0 1
0
end_operator
begin_operator
load-tire b2 0 1
1
18 3
2
0 1 0 1
0 5 0 1
0
end_operator
begin_operator
load-tire b2 1 2
1
18 3
2
0 1 1 2
0 5 0 1
0
end_operator
begin_operator
load-tire b2 2 3
1
18 3
2
0 1 2 3
0 5 0 1
0
end_operator
begin_operator
load-tire b2 3 4
1
18 3
2
0 1 3 4
0 5 0 1
0
end_operator
begin_operator
load-tire b2 4 5
1
18 3
2
0 1 4 5
0 5 0 1
0
end_operator
begin_operator
load-tire b2 5 6
1
18 3
2
0 1 5 6
0 5 0 1
0
end_operator
begin_operator
load-tire b2 6 7
1
18 3
2
0 1 6 7
0 5 0 1
0
end_operator
begin_operator
load-tire b3 0 1
1
18 4
2
0 1 0 1
0 6 0 1
0
end_operator
begin_operator
load-tire b3 1 2
1
18 4
2
0 1 1 2
0 6 0 1
0
end_operator
begin_operator
load-tire b3 2 3
1
18 4
2
0 1 2 3
0 6 0 1
0
end_operator
begin_operator
load-tire b3 3 4
1
18 4
2
0 1 3 4
0 6 0 1
0
end_operator
begin_operator
load-tire b3 4 5
1
18 4
2
0 1 4 5
0 6 0 1
0
end_operator
begin_operator
load-tire b3 5 6
1
18 4
2
0 1 5 6
0 6 0 1
0
end_operator
begin_operator
load-tire b3 6 7
1
18 4
2
0 1 6 7
0 6 0 1
0
end_operator
begin_operator
load-tire b4 0 1
1
18 5
2
0 1 0 1
0 7 0 1
0
end_operator
begin_operator
load-tire b4 1 2
1
18 5
2
0 1 1 2
0 7 0 1
0
end_operator
begin_operator
load-tire b4 2 3
1
18 5
2
0 1 2 3
0 7 0 1
0
end_operator
begin_operator
load-tire b4 3 4
1
18 5
2
0 1 3 4
0 7 0 1
0
end_operator
begin_operator
load-tire b4 4 5
1
18 5
2
0 1 4 5
0 7 0 1
0
end_operator
begin_operator
load-tire b4 5 6
1
18 5
2
0 1 5 6
0 7 0 1
0
end_operator
begin_operator
load-tire b4 6 7
1
18 5
2
0 1 6 7
0 7 0 1
0
end_operator
begin_operator
load-tire b5 0 1
1
18 6
2
0 1 0 1
0 8 0 1
0
end_operator
begin_operator
load-tire b5 1 2
1
18 6
2
0 1 1 2
0 8 0 1
0
end_operator
begin_operator
load-tire b5 2 3
1
18 6
2
0 1 2 3
0 8 0 1
0
end_operator
begin_operator
load-tire b5 3 4
1
18 6
2
0 1 3 4
0 8 0 1
0
end_operator
begin_operator
load-tire b5 4 5
1
18 6
2
0 1 4 5
0 8 0 1
0
end_operator
begin_operator
load-tire b5 5 6
1
18 6
2
0 1 5 6
0 8 0 1
0
end_operator
begin_operator
load-tire b5 6 7
1
18 6
2
0 1 6 7
0 8 0 1
0
end_operator
begin_operator
load-tire c1 0 1
1
18 7
2
0 1 0 1
0 9 0 1
0
end_operator
begin_operator
load-tire c1 1 2
1
18 7
2
0 1 1 2
0 9 0 1
0
end_operator
begin_operator
load-tire c1 2 3
1
18 7
2
0 1 2 3
0 9 0 1
0
end_operator
begin_operator
load-tire c1 3 4
1
18 7
2
0 1 3 4
0 9 0 1
0
end_operator
begin_operator
load-tire c1 4 5
1
18 7
2
0 1 4 5
0 9 0 1
0
end_operator
begin_operator
load-tire c1 5 6
1
18 7
2
0 1 5 6
0 9 0 1
0
end_operator
begin_operator
load-tire c1 6 7
1
18 7
2
0 1 6 7
0 9 0 1
0
end_operator
begin_operator
load-tire c2 0 1
1
18 8
2
0 1 0 1
0 10 0 1
0
end_operator
begin_operator
load-tire c2 1 2
1
18 8
2
0 1 1 2
0 10 0 1
0
end_operator
begin_operator
load-tire c2 2 3
1
18 8
2
0 1 2 3
0 10 0 1
0
end_operator
begin_operator
load-tire c2 3 4
1
18 8
2
0 1 3 4
0 10 0 1
0
end_operator
begin_operator
load-tire c2 4 5
1
18 8
2
0 1 4 5
0 10 0 1
0
end_operator
begin_operator
load-tire c2 5 6
1
18 8
2
0 1 5 6
0 10 0 1
0
end_operator
begin_operator
load-tire c2 6 7
1
18 8
2
0 1 6 7
0 10 0 1
0
end_operator
begin_operator
load-tire c3 0 1
1
18 9
2
0 1 0 1
0 11 0 1
0
end_operator
begin_operator
load-tire c3 1 2
1
18 9
2
0 1 1 2
0 11 0 1
0
end_operator
begin_operator
load-tire c3 2 3
1
18 9
2
0 1 2 3
0 11 0 1
0
end_operator
begin_operator
load-tire c3 3 4
1
18 9
2
0 1 3 4
0 11 0 1
0
end_operator
begin_operator
load-tire c3 4 5
1
18 9
2
0 1 4 5
0 11 0 1
0
end_operator
begin_operator
load-tire c3 5 6
1
18 9
2
0 1 5 6
0 11 0 1
0
end_operator
begin_operator
load-tire c3 6 7
1
18 9
2
0 1 6 7
0 11 0 1
0
end_operator
begin_operator
load-tire c4 0 1
1
18 10
2
0 1 0 1
0 12 0 1
0
end_operator
begin_operator
load-tire c4 1 2
1
18 10
2
0 1 1 2
0 12 0 1
0
end_operator
begin_operator
load-tire c4 2 3
1
18 10
2
0 1 2 3
0 12 0 1
0
end_operator
begin_operator
load-tire c4 3 4
1
18 10
2
0 1 3 4
0 12 0 1
0
end_operator
begin_operator
load-tire c4 4 5
1
18 10
2
0 1 4 5
0 12 0 1
0
end_operator
begin_operator
load-tire c4 5 6
1
18 10
2
0 1 5 6
0 12 0 1
0
end_operator
begin_operator
load-tire c4 6 7
1
18 10
2
0 1 6 7
0 12 0 1
0
end_operator
begin_operator
load-tire c5 0 1
1
18 11
2
0 1 0 1
0 13 0 1
0
end_operator
begin_operator
load-tire c5 1 2
1
18 11
2
0 1 1 2
0 13 0 1
0
end_operator
begin_operator
load-tire c5 2 3
1
18 11
2
0 1 2 3
0 13 0 1
0
end_operator
begin_operator
load-tire c5 3 4
1
18 11
2
0 1 3 4
0 13 0 1
0
end_operator
begin_operator
load-tire c5 4 5
1
18 11
2
0 1 4 5
0 13 0 1
0
end_operator
begin_operator
load-tire c5 5 6
1
18 11
2
0 1 5 6
0 13 0 1
0
end_operator
begin_operator
load-tire c5 6 7
1
18 11
2
0 1 6 7
0 13 0 1
0
end_operator
begin_operator
load-tire d1 0 1
1
18 12
2
0 1 0 1
0 14 0 1
0
end_operator
begin_operator
load-tire d1 1 2
1
18 12
2
0 1 1 2
0 14 0 1
0
end_operator
begin_operator
load-tire d1 2 3
1
18 12
2
0 1 2 3
0 14 0 1
0
end_operator
begin_operator
load-tire d1 3 4
1
18 12
2
0 1 3 4
0 14 0 1
0
end_operator
begin_operator
load-tire d1 4 5
1
18 12
2
0 1 4 5
0 14 0 1
0
end_operator
begin_operator
load-tire d1 5 6
1
18 12
2
0 1 5 6
0 14 0 1
0
end_operator
begin_operator
load-tire d1 6 7
1
18 12
2
0 1 6 7
0 14 0 1
0
end_operator
begin_operator
load-tire d2 0 1
1
18 13
2
0 1 0 1
0 15 0 1
0
end_operator
begin_operator
load-tire d2 1 2
1
18 13
2
0 1 1 2
0 15 0 1
0
end_operator
begin_operator
load-tire d2 2 3
1
18 13
2
0 1 2 3
0 15 0 1
0
end_operator
begin_operator
load-tire d2 3 4
1
18 13
2
0 1 3 4
0 15 0 1
0
end_operator
begin_operator
load-tire d2 4 5
1
18 13
2
0 1 4 5
0 15 0 1
0
end_operator
begin_operator
load-tire d2 5 6
1
18 13
2
0 1 5 6
0 15 0 1
0
end_operator
begin_operator
load-tire d2 6 7
1
18 13
2
0 1 6 7
0 15 0 1
0
end_operator
begin_operator
load-tire d3 0 1
1
18 14
2
0 1 0 1
0 16 0 1
0
end_operator
begin_operator
load-tire d3 1 2
1
18 14
2
0 1 1 2
0 16 0 1
0
end_operator
begin_operator
load-tire d3 2 3
1
18 14
2
0 1 2 3
0 16 0 1
0
end_operator
begin_operator
load-tire d3 3 4
1
18 14
2
0 1 3 4
0 16 0 1
0
end_operator
begin_operator
load-tire d3 4 5
1
18 14
2
0 1 4 5
0 16 0 1
0
end_operator
begin_operator
load-tire d3 5 6
1
18 14
2
0 1 5 6
0 16 0 1
0
end_operator
begin_operator
load-tire d3 6 7
1
18 14
2
0 1 6 7
0 16 0 1
0
end_operator
begin_operator
load-tire d4 0 1
1
18 15
2
0 1 0 1
0 17 0 1
0
end_operator
begin_operator
load-tire d4 1 2
1
18 15
2
0 1 1 2
0 17 0 1
0
end_operator
begin_operator
load-tire d4 2 3
1
18 15
2
0 1 2 3
0 17 0 1
0
end_operator
begin_operator
load-tire d4 3 4
1
18 15
2
0 1 3 4
0 17 0 1
0
end_operator
begin_operator
load-tire d4 4 5
1
18 15
2
0 1 4 5
0 17 0 1
0
end_operator
begin_operator
load-tire d4 5 6
1
18 15
2
0 1 5 6
0 17 0 1
0
end_operator
begin_operator
load-tire d4 6 7
1
18 15
2
0 1 6 7
0 17 0 1
0
end_operator
begin_operator
move-car-normal a1 a2
1
0 1
1
0 18 0 1
0
end_operator
begin_operator
move-car-normal a2 a1
1
0 1
1
0 18 1 0
0
end_operator
begin_operator
move-car-normal b1 b2
1
0 1
1
0 18 2 3
0
end_operator
begin_operator
move-car-normal b2 b1
1
0 1
1
0 18 3 2
0
end_operator
begin_operator
move-car-normal b2 b3
1
0 1
1
0 18 3 4
0
end_operator
begin_operator
move-car-normal b3 b2
1
0 1
1
0 18 4 3
0
end_operator
begin_operator
move-car-normal b3 b4
1
0 1
1
0 18 4 5
0
end_operator
begin_operator
move-car-normal b4 b3
1
0 1
1
0 18 5 4
0
end_operator
begin_operator
move-car-normal c1 c2
1
0 1
1
0 18 7 8
0
end_operator
begin_operator
move-car-normal c2 c1
1
0 1
1
0 18 8 7
0
end_operator
begin_operator
move-car-normal c2 c3
1
0 1
1
0 18 8 9
0
end_operator
begin_operator
move-car-normal c3 c2
1
0 1
1
0 18 9 8
0
end_operator
begin_operator
move-car-normal c3 c4
1
0 1
1
0 18 9 10
0
end_operator
begin_operator
move-car-normal c4 c3
1
0 1
1
0 18 10 9
0
end_operator
begin_operator
move-car-normal d3 d4
1
0 1
1
0 18 14 15
0
end_operator
begin_operator
move-car-normal d4 d3
1
0 1
1
0 18 15 14
0
end_operator
begin_operator
move-car-spiky a2 b1
0
2
0 0 1 0
0 18 1 2
0
end_operator
begin_operator
move-car-spiky a2 b1
1
0 1
1
0 18 1 2
0
end_operator
begin_operator
move-car-spiky a2 c1
0
2
0 0 1 0
0 18 1 7
0
end_operator
begin_operator
move-car-spiky a2 c1
1
0 1
1
0 18 1 7
0
end_operator
begin_operator
move-car-spiky b1 a2
0
2
0 0 1 0
0 18 2 1
0
end_operator
begin_operator
move-car-spiky b1 a2
1
0 1
1
0 18 2 1
0
end_operator
begin_operator
move-car-spiky b4 b5
0
2
0 0 1 0
0 18 5 6
0
end_operator
begin_operator
move-car-spiky b4 b5
1
0 1
1
0 18 5 6
0
end_operator
begin_operator
move-car-spiky b5 b4
0
2
0 0 1 0
0 18 6 5
0
end_operator
begin_operator
move-car-spiky b5 b4
1
0 1
1
0 18 6 5
0
end_operator
begin_operator
move-car-spiky b5 d1
0
2
0 0 1 0
0 18 6 12
0
end_operator
begin_operator
move-car-spiky b5 d1
1
0 1
1
0 18 6 12
0
end_operator
begin_operator
move-car-spiky c1 a2
0
2
0 0 1 0
0 18 7 1
0
end_operator
begin_operator
move-car-spiky c1 a2
1
0 1
1
0 18 7 1
0
end_operator
begin_operator
move-car-spiky c4 c5
0
2
0 0 1 0
0 18 10 11
0
end_operator
begin_operator
move-car-spiky c4 c5
1
0 1
1
0 18 10 11
0
end_operator
begin_operator
move-car-spiky c5 c4
0
2
0 0 1 0
0 18 11 10
0
end_operator
begin_operator
move-car-spiky c5 c4
1
0 1
1
0 18 11 10
0
end_operator
begin_operator
move-car-spiky c5 d1
0
2
0 0 1 0
0 18 11 12
0
end_operator
begin_operator
move-car-spiky c5 d1
1
0 1
1
0 18 11 12
0
end_operator
begin_operator
move-car-spiky d1 b5
0
2
0 0 1 0
0 18 12 6
0
end_operator
begin_operator
move-car-spiky d1 b5
1
0 1
1
0 18 12 6
0
end_operator
begin_operator
move-car-spiky d1 c5
0
2
0 0 1 0
0 18 12 11
0
end_operator
begin_operator
move-car-spiky d1 c5
1
0 1
1
0 18 12 11
0
end_operator
begin_operator
move-car-spiky d1 d2
0
2
0 0 1 0
0 18 12 13
0
end_operator
begin_operator
move-car-spiky d1 d2
1
0 1
1
0 18 12 13
0
end_operator
begin_operator
move-car-spiky d2 d1
0
2
0 0 1 0
0 18 13 12
0
end_operator
begin_operator
move-car-spiky d2 d1
1
0 1
1
0 18 13 12
0
end_operator
begin_operator
move-car-spiky d2 d3
0
2
0 0 1 0
0 18 13 14
0
end_operator
begin_operator
move-car-spiky d2 d3
1
0 1
1
0 18 13 14
0
end_operator
begin_operator
move-car-spiky d3 d2
0
2
0 0 1 0
0 18 14 13
0
end_operator
begin_operator
move-car-spiky d3 d2
1
0 1
1
0 18 14 13
0
end_operator
0
