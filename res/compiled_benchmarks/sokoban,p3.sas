begin_version
3
end_version
begin_metric
0
end_metric
8
begin_variable
var0
-1
2
Atom alive()
NegatedAtom alive()
end_variable
begin_variable
var1
-1
2
Atom is-clear(r3c1)
<none of those>
end_variable
begin_variable
var2
-1
2
Atom is-clear(r3c2)
<none of those>
end_variable
begin_variable
var3
-1
2
Atom is-clear(r3c3)
<none of those>
end_variable
begin_variable
var4
-1
2
Atom is-clear(r3c4)
<none of those>
end_variable
begin_variable
var5
-1
2
Atom is-clear(r3c5)
<none of those>
end_variable
begin_variable
var6
-1
5
Atom box-at(r3c1)
Atom box-at(r3c2)
Atom box-at(r3c3)
Atom box-at(r3c4)
Atom box-at(r3c5)
end_variable
begin_variable
var7
-1
4
Atom player-at(r3c1)
Atom player-at(r3c2)
Atom player-at(r3c3)
Atom player-at(r3c4)
end_variable
7
begin_mutex_group
3
6 0
1 0
7 0
end_mutex_group
begin_mutex_group
3
6 1
2 0
7 1
end_mutex_group
begin_mutex_group
3
6 2
3 0
7 2
end_mutex_group
begin_mutex_group
3
6 3
4 0
7 3
end_mutex_group
begin_mutex_group
2
6 4
5 0
end_mutex_group
begin_mutex_group
5
6 0
6 1
6 2
6 3
6 4
end_mutex_group
begin_mutex_group
4
7 0
7 1
7 2
7 3
end_mutex_group
begin_state
0
1
1
0
0
0
1
0
end_state
begin_goal
1
6 2
end_goal
15
begin_operator
move r3c2 r3c3 right
0
4
0 0 0 1
0 2 -1 0
0 3 0 1
0 7 1 2
0
end_operator
begin_operator
move r3c2 r3c3 right
1
0 0
3
0 2 -1 0
0 3 0 1
0 7 1 2
0
end_operator
begin_operator
move r3c4 r3c3 left
0
4
0 0 0 1
0 3 0 1
0 4 -1 0
0 7 3 2
0
end_operator
begin_operator
move r3c4 r3c3 left
1
0 0
3
0 3 0 1
0 4 -1 0
0 7 3 2
0
end_operator
begin_operator
push-box-slippery r3c1 r3c2 r3c3 r3c4 right
2
0 0
3 0
4
0 1 -1 0
0 4 0 1
0 6 1 3
0 7 0 1
0
end_operator
begin_operator
push-box-slippery r3c1 r3c2 r3c3 r3c4 right
2
0 0
4 0
4
0 1 -1 0
0 3 0 1
0 6 1 2
0 7 0 1
0
end_operator
begin_operator
push-box-slippery1 r3c2 r3c3 r3c4 r3c5 right
1
0 0
4
0 2 -1 0
0 4 0 1
0 6 2 3
0 7 1 2
0
end_operator
begin_operator
push-box-slippery1 r3c3 r3c2 r3c1 r3c0 left
1
0 0
4
0 1 0 1
0 3 -1 0
0 6 1 0
0 7 2 1
0
end_operator
begin_operator
push-box-slippery1 r3c3 r3c4 r3c5 r3c6 right
1
0 0
4
0 3 -1 0
0 5 0 1
0 6 3 4
0 7 2 3
0
end_operator
begin_operator
push-box-slippery1 r3c4 r3c3 r3c2 r3c1 left
1
0 0
4
0 2 0 1
0 4 -1 0
0 6 2 1
0 7 3 2
0
end_operator
begin_operator
push-box-slippery2 r3c3 r3c2 r3c1 r3c0 left
1
0 0
4
0 1 0 1
0 3 -1 0
0 6 1 0
0 7 2 1
0
end_operator
begin_operator
push-box-slippery2 r3c3 r3c4 r3c5 r3c6 right
1
0 0
4
0 3 -1 0
0 5 0 1
0 6 3 4
0 7 2 3
0
end_operator
begin_operator
push-box-slippery2_v2 r3c1 r3c2 r3c3 r3c4 right
2
0 0
4 1
4
0 1 -1 0
0 3 0 1
0 6 1 2
0 7 0 1
0
end_operator
begin_operator
push-box-slippery2_v2 r3c4 r3c3 r3c2 r3c1 left
2
0 0
1 1
4
0 2 0 1
0 4 -1 0
0 6 2 1
0 7 3 2
0
end_operator
begin_operator
push-box-slippery2_v3 r3c2 r3c3 r3c4 r3c5 right
2
0 0
5 1
4
0 2 -1 0
0 4 0 1
0 6 2 3
0 7 1 2
0
end_operator
0
