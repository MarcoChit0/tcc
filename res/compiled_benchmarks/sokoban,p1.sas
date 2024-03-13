begin_version
3
end_version
begin_metric
0
end_metric
7
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
Atom is-clear(r2c1)
<none of those>
end_variable
begin_variable
var2
-1
3
Atom is-clear(r2c2)
Atom player-at(r2c2)
<none of those>
end_variable
begin_variable
var3
-1
3
Atom is-clear(r2c3)
Atom player-at(r2c3)
<none of those>
end_variable
begin_variable
var4
-1
3
Atom is-clear(r2c4)
Atom player-at(r2c4)
<none of those>
end_variable
begin_variable
var5
-1
2
Atom is-clear(r2c5)
<none of those>
end_variable
begin_variable
var6
-1
5
Atom box-at(r2c1)
Atom box-at(r2c2)
Atom box-at(r2c3)
Atom box-at(r2c4)
Atom box-at(r2c5)
end_variable
7
begin_mutex_group
2
6 0
1 0
end_mutex_group
begin_mutex_group
3
6 1
2 0
2 1
end_mutex_group
begin_mutex_group
3
6 2
3 0
3 1
end_mutex_group
begin_mutex_group
3
6 3
4 0
4 1
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
3
2 1
3 1
4 1
end_mutex_group
begin_state
0
0
1
2
0
0
2
end_state
begin_goal
1
6 3
end_goal
11
begin_operator
move r2c3 r2c4 right
0
3
0 0 0 1
0 3 1 0
0 4 0 1
0
end_operator
begin_operator
move r2c3 r2c4 right
1
0 0
2
0 3 1 0
0 4 0 1
0
end_operator
begin_operator
push-box-slippery r2c2 r2c3 r2c4 r2c5 right
2
0 0
4 0
4
0 2 1 0
0 3 -1 1
0 5 0 1
0 6 2 4
0
end_operator
begin_operator
push-box-slippery r2c2 r2c3 r2c4 r2c5 right
2
0 0
5 0
4
0 2 1 0
0 3 -1 1
0 4 0 2
0 6 2 3
0
end_operator
begin_operator
push-box-slippery1 r2c3 r2c2 r2c1 r2c0 left
1
0 0
4
0 1 0 1
0 2 -1 1
0 3 1 0
0 6 1 0
0
end_operator
begin_operator
push-box-slippery1 r2c3 r2c4 r2c5 r2c6 right
1
0 0
4
0 3 1 0
0 4 -1 1
0 5 0 1
0 6 3 4
0
end_operator
begin_operator
push-box-slippery1 r2c4 r2c3 r2c2 r2c1 left
1
0 0
4
0 2 0 2
0 3 -1 1
0 4 1 0
0 6 2 1
0
end_operator
begin_operator
push-box-slippery2 r2c3 r2c2 r2c1 r2c0 left
1
0 0
4
0 1 0 1
0 2 -1 1
0 3 1 0
0 6 1 0
0
end_operator
begin_operator
push-box-slippery2 r2c3 r2c4 r2c5 r2c6 right
1
0 0
4
0 3 1 0
0 4 -1 1
0 5 0 1
0 6 3 4
0
end_operator
begin_operator
push-box-slippery2_v3 r2c2 r2c3 r2c4 r2c5 right
2
0 0
5 1
4
0 2 1 0
0 3 -1 1
0 4 0 2
0 6 2 3
0
end_operator
begin_operator
push-box-slippery2_v3 r2c4 r2c3 r2c2 r2c1 left
2
0 0
1 1
4
0 2 0 2
0 3 -1 1
0 4 1 0
0 6 2 1
0
end_operator
0
