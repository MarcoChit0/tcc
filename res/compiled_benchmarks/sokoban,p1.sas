begin_version
3
end_version
begin_metric
0
end_metric
16
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
Atom is-clear(r1c1)
<none of those>
end_variable
begin_variable
var2
-1
2
Atom is-clear(r1c2)
<none of those>
end_variable
begin_variable
var3
-1
2
Atom is-clear(r1c3)
<none of those>
end_variable
begin_variable
var4
-1
2
Atom is-clear(r1c4)
<none of those>
end_variable
begin_variable
var5
-1
2
Atom is-clear(r2c1)
<none of those>
end_variable
begin_variable
var6
-1
2
Atom is-clear(r2c2)
<none of those>
end_variable
begin_variable
var7
-1
2
Atom is-clear(r2c3)
<none of those>
end_variable
begin_variable
var8
-1
2
Atom is-clear(r2c4)
<none of those>
end_variable
begin_variable
var9
-1
2
Atom is-clear(r2c5)
<none of those>
end_variable
begin_variable
var10
-1
2
Atom is-clear(r3c1)
<none of those>
end_variable
begin_variable
var11
-1
2
Atom is-clear(r3c2)
<none of those>
end_variable
begin_variable
var12
-1
2
Atom is-clear(r3c3)
<none of those>
end_variable
begin_variable
var13
-1
2
Atom is-clear(r3c4)
<none of those>
end_variable
begin_variable
var14
-1
13
Atom box-at(r1c1)
Atom box-at(r1c2)
Atom box-at(r1c3)
Atom box-at(r1c4)
Atom box-at(r2c1)
Atom box-at(r2c2)
Atom box-at(r2c3)
Atom box-at(r2c4)
Atom box-at(r2c5)
Atom box-at(r3c1)
Atom box-at(r3c2)
Atom box-at(r3c3)
Atom box-at(r3c4)
end_variable
begin_variable
var15
-1
13
Atom player-at(r1c1)
Atom player-at(r1c2)
Atom player-at(r1c3)
Atom player-at(r1c4)
Atom player-at(r2c1)
Atom player-at(r2c2)
Atom player-at(r2c3)
Atom player-at(r2c4)
Atom player-at(r2c5)
Atom player-at(r3c1)
Atom player-at(r3c2)
Atom player-at(r3c3)
Atom player-at(r3c4)
end_variable
15
begin_mutex_group
3
14 0
1 0
15 0
end_mutex_group
begin_mutex_group
3
14 1
2 0
15 1
end_mutex_group
begin_mutex_group
3
14 2
3 0
15 2
end_mutex_group
begin_mutex_group
3
14 3
4 0
15 3
end_mutex_group
begin_mutex_group
3
14 4
5 0
15 4
end_mutex_group
begin_mutex_group
3
14 5
6 0
15 5
end_mutex_group
begin_mutex_group
3
14 6
7 0
15 6
end_mutex_group
begin_mutex_group
3
14 7
8 0
15 7
end_mutex_group
begin_mutex_group
3
14 8
9 0
15 8
end_mutex_group
begin_mutex_group
3
14 9
10 0
15 9
end_mutex_group
begin_mutex_group
3
14 10
11 0
15 10
end_mutex_group
begin_mutex_group
3
14 11
12 0
15 11
end_mutex_group
begin_mutex_group
3
14 12
13 0
15 12
end_mutex_group
begin_mutex_group
13
14 0
14 1
14 2
14 3
14 4
14 5
14 6
14 7
14 8
14 9
14 10
14 11
14 12
end_mutex_group
begin_mutex_group
13
15 0
15 1
15 2
15 3
15 4
15 5
15 6
15 7
15 8
15 9
15 10
15 11
15 12
end_mutex_group
begin_state
0
0
0
0
0
0
1
1
0
0
0
0
0
0
6
5
end_state
begin_goal
1
14 7
end_goal
85
begin_operator
move-non-slippery2 r1c1 r1c2 right
1
0 0
3
0 1 -1 0
0 2 0 1
0 15 0 1
0
end_operator
begin_operator
move-non-slippery2 r1c1 r2c1 down
1
0 0
3
0 1 -1 0
0 5 0 1
0 15 0 4
0
end_operator
begin_operator
move-non-slippery2 r1c2 r1c1 left
1
0 0
3
0 1 0 1
0 2 -1 0
0 15 1 0
0
end_operator
begin_operator
move-non-slippery2 r1c2 r1c3 right
1
0 0
3
0 2 -1 0
0 3 0 1
0 15 1 2
0
end_operator
begin_operator
move-non-slippery2 r1c2 r2c2 down
1
0 0
3
0 2 -1 0
0 6 0 1
0 15 1 5
0
end_operator
begin_operator
move-non-slippery2 r1c3 r1c2 left
1
0 0
3
0 2 0 1
0 3 -1 0
0 15 2 1
0
end_operator
begin_operator
move-non-slippery2 r1c3 r1c4 right
1
0 0
3
0 3 -1 0
0 4 0 1
0 15 2 3
0
end_operator
begin_operator
move-non-slippery2 r1c3 r2c3 down
1
0 0
3
0 3 -1 0
0 7 0 1
0 15 2 6
0
end_operator
begin_operator
move-non-slippery2 r1c4 r1c3 left
1
0 0
3
0 3 0 1
0 4 -1 0
0 15 3 2
0
end_operator
begin_operator
move-non-slippery2 r2c1 r1c1 up
1
0 0
3
0 1 0 1
0 5 -1 0
0 15 4 0
0
end_operator
begin_operator
move-non-slippery2 r2c1 r2c2 right
1
0 0
3
0 5 -1 0
0 6 0 1
0 15 4 5
0
end_operator
begin_operator
move-non-slippery2 r2c1 r3c1 down
1
0 0
3
0 5 -1 0
0 10 0 1
0 15 4 9
0
end_operator
begin_operator
move-non-slippery2 r2c2 r1c2 up
1
0 0
3
0 2 0 1
0 6 -1 0
0 15 5 1
0
end_operator
begin_operator
move-non-slippery2 r2c2 r2c1 left
1
0 0
3
0 5 0 1
0 6 -1 0
0 15 5 4
0
end_operator
begin_operator
move-non-slippery2 r2c2 r2c3 right
1
0 0
3
0 6 -1 0
0 7 0 1
0 15 5 6
0
end_operator
begin_operator
move-non-slippery2 r2c2 r3c2 down
1
0 0
3
0 6 -1 0
0 11 0 1
0 15 5 10
0
end_operator
begin_operator
move-non-slippery2 r2c3 r1c3 up
1
0 0
3
0 3 0 1
0 7 -1 0
0 15 6 2
0
end_operator
begin_operator
move-non-slippery2 r2c3 r2c2 left
1
0 0
3
0 6 0 1
0 7 -1 0
0 15 6 5
0
end_operator
begin_operator
move-non-slippery2 r2c3 r3c3 down
1
0 0
3
0 7 -1 0
0 12 0 1
0 15 6 11
0
end_operator
begin_operator
move-non-slippery2 r2c4 r1c4 up
1
0 0
3
0 4 0 1
0 8 -1 0
0 15 7 3
0
end_operator
begin_operator
move-non-slippery2 r2c4 r2c3 left
1
0 0
3
0 7 0 1
0 8 -1 0
0 15 7 6
0
end_operator
begin_operator
move-non-slippery2 r2c4 r2c5 right
1
0 0
3
0 8 -1 0
0 9 0 1
0 15 7 8
0
end_operator
begin_operator
move-non-slippery2 r2c4 r3c4 down
1
0 0
3
0 8 -1 0
0 13 0 1
0 15 7 12
0
end_operator
begin_operator
move-non-slippery2 r3c1 r2c1 up
1
0 0
3
0 5 0 1
0 10 -1 0
0 15 9 4
0
end_operator
begin_operator
move-non-slippery2 r3c1 r3c2 right
1
0 0
3
0 10 -1 0
0 11 0 1
0 15 9 10
0
end_operator
begin_operator
move-non-slippery2 r3c2 r2c2 up
1
0 0
3
0 6 0 1
0 11 -1 0
0 15 10 5
0
end_operator
begin_operator
move-non-slippery2 r3c2 r3c1 left
1
0 0
3
0 10 0 1
0 11 -1 0
0 15 10 9
0
end_operator
begin_operator
move-non-slippery2 r3c2 r3c3 right
1
0 0
3
0 11 -1 0
0 12 0 1
0 15 10 11
0
end_operator
begin_operator
move-non-slippery2 r3c3 r2c3 up
1
0 0
3
0 7 0 1
0 12 -1 0
0 15 11 6
0
end_operator
begin_operator
move-non-slippery2 r3c3 r3c2 left
1
0 0
3
0 11 0 1
0 12 -1 0
0 15 11 10
0
end_operator
begin_operator
move-non-slippery2 r3c3 r3c4 right
1
0 0
3
0 12 -1 0
0 13 0 1
0 15 11 12
0
end_operator
begin_operator
move-non-slippery2 r3c4 r3c3 left
1
0 0
3
0 12 0 1
0 13 -1 0
0 15 12 11
0
end_operator
begin_operator
move-slippery r1c4 r2c4 down
0
4
0 0 0 1
0 4 -1 0
0 8 0 1
0 15 3 7
0
end_operator
begin_operator
move-slippery r1c4 r2c4 down
1
0 0
3
0 4 -1 0
0 8 0 1
0 15 3 7
0
end_operator
begin_operator
move-slippery r2c3 r2c4 right
0
4
0 0 0 1
0 7 -1 0
0 8 0 1
0 15 6 7
0
end_operator
begin_operator
move-slippery r2c3 r2c4 right
1
0 0
3
0 7 -1 0
0 8 0 1
0 15 6 7
0
end_operator
begin_operator
move-slippery r2c5 r2c4 left
0
4
0 0 0 1
0 8 0 1
0 9 -1 0
0 15 8 7
0
end_operator
begin_operator
move-slippery r2c5 r2c4 left
1
0 0
3
0 8 0 1
0 9 -1 0
0 15 8 7
0
end_operator
begin_operator
move-slippery r3c4 r2c4 up
0
4
0 0 0 1
0 8 0 1
0 13 -1 0
0 15 12 7
0
end_operator
begin_operator
move-slippery r3c4 r2c4 up
1
0 0
3
0 8 0 1
0 13 -1 0
0 15 12 7
0
end_operator
begin_operator
push-box-not-slippery1 r1c1 r1c2 r1c3 r1c4 right
1
0 0
4
0 1 -1 0
0 3 0 1
0 14 1 2
0 15 0 1
0
end_operator
begin_operator
push-box-not-slippery1 r1c1 r2c1 r3c1 r4c1 down
1
0 0
4
0 1 -1 0
0 10 0 1
0 14 4 9
0 15 0 4
0
end_operator
begin_operator
push-box-not-slippery1 r1c2 r1c3 r1c4 r1c5 right
1
0 0
4
0 2 -1 0
0 4 0 1
0 14 2 3
0 15 1 2
0
end_operator
begin_operator
push-box-not-slippery1 r1c2 r2c2 r3c2 r4c2 down
1
0 0
4
0 2 -1 0
0 11 0 1
0 14 5 10
0 15 1 5
0
end_operator
begin_operator
push-box-not-slippery1 r1c3 r1c2 r1c1 r1c0 left
1
0 0
4
0 1 0 1
0 3 -1 0
0 14 1 0
0 15 2 1
0
end_operator
begin_operator
push-box-not-slippery1 r1c3 r2c3 r3c3 r4c3 down
1
0 0
4
0 3 -1 0
0 12 0 1
0 14 6 11
0 15 2 6
0
end_operator
begin_operator
push-box-not-slippery1 r1c4 r1c3 r1c2 r1c1 left
1
0 0
4
0 2 0 1
0 4 -1 0
0 14 2 1
0 15 3 2
0
end_operator
begin_operator
push-box-not-slippery1 r1c4 r2c4 r3c4 r4c4 down
1
0 0
4
0 4 -1 0
0 13 0 1
0 14 7 12
0 15 3 7
0
end_operator
begin_operator
push-box-not-slippery1 r2c1 r2c2 r2c3 r2c4 right
1
0 0
4
0 5 -1 0
0 7 0 1
0 14 5 6
0 15 4 5
0
end_operator
begin_operator
push-box-not-slippery1 r2c3 r2c2 r2c1 r2c0 left
1
0 0
4
0 5 0 1
0 7 -1 0
0 14 5 4
0 15 6 5
0
end_operator
begin_operator
push-box-not-slippery1 r2c3 r2c4 r2c5 r2c6 right
1
0 0
4
0 7 -1 0
0 9 0 1
0 14 7 8
0 15 6 7
0
end_operator
begin_operator
push-box-not-slippery1 r2c4 r2c3 r2c2 r2c1 left
1
0 0
4
0 6 0 1
0 8 -1 0
0 14 6 5
0 15 7 6
0
end_operator
begin_operator
push-box-not-slippery1 r2c5 r2c4 r2c3 r2c2 left
1
0 0
4
0 7 0 1
0 9 -1 0
0 14 7 6
0 15 8 7
0
end_operator
begin_operator
push-box-not-slippery1 r3c1 r2c1 r1c1 r0c1 up
1
0 0
4
0 1 0 1
0 10 -1 0
0 14 4 0
0 15 9 4
0
end_operator
begin_operator
push-box-not-slippery1 r3c1 r3c2 r3c3 r3c4 right
1
0 0
4
0 10 -1 0
0 12 0 1
0 14 10 11
0 15 9 10
0
end_operator
begin_operator
push-box-not-slippery1 r3c2 r2c2 r1c2 r0c2 up
1
0 0
4
0 2 0 1
0 11 -1 0
0 14 5 1
0 15 10 5
0
end_operator
begin_operator
push-box-not-slippery1 r3c2 r3c3 r3c4 r3c5 right
1
0 0
4
0 11 -1 0
0 13 0 1
0 14 11 12
0 15 10 11
0
end_operator
begin_operator
push-box-not-slippery1 r3c3 r2c3 r1c3 r0c3 up
1
0 0
4
0 3 0 1
0 12 -1 0
0 14 6 2
0 15 11 6
0
end_operator
begin_operator
push-box-not-slippery1 r3c3 r3c2 r3c1 r3c0 left
1
0 0
4
0 10 0 1
0 12 -1 0
0 14 10 9
0 15 11 10
0
end_operator
begin_operator
push-box-not-slippery1 r3c4 r2c4 r1c4 r0c4 up
1
0 0
4
0 4 0 1
0 13 -1 0
0 14 7 3
0 15 12 7
0
end_operator
begin_operator
push-box-not-slippery1 r3c4 r3c3 r3c2 r3c1 left
1
0 0
4
0 11 0 1
0 13 -1 0
0 14 11 10
0 15 12 11
0
end_operator
begin_operator
push-box-not-slippery2 r1c1 r2c1 r3c1 r4c1 down
1
0 0
4
0 1 -1 0
0 10 0 1
0 14 4 9
0 15 0 4
0
end_operator
begin_operator
push-box-not-slippery2 r1c2 r1c3 r1c4 r1c5 right
1
0 0
4
0 2 -1 0
0 4 0 1
0 14 2 3
0 15 1 2
0
end_operator
begin_operator
push-box-not-slippery2 r1c2 r2c2 r3c2 r4c2 down
1
0 0
4
0 2 -1 0
0 11 0 1
0 14 5 10
0 15 1 5
0
end_operator
begin_operator
push-box-not-slippery2 r1c3 r1c2 r1c1 r1c0 left
1
0 0
4
0 1 0 1
0 3 -1 0
0 14 1 0
0 15 2 1
0
end_operator
begin_operator
push-box-not-slippery2 r1c3 r2c3 r3c3 r4c3 down
1
0 0
4
0 3 -1 0
0 12 0 1
0 14 6 11
0 15 2 6
0
end_operator
begin_operator
push-box-not-slippery2 r1c4 r2c4 r3c4 r4c4 down
1
0 0
4
0 4 -1 0
0 13 0 1
0 14 7 12
0 15 3 7
0
end_operator
begin_operator
push-box-not-slippery2 r2c3 r2c2 r2c1 r2c0 left
1
0 0
4
0 5 0 1
0 7 -1 0
0 14 5 4
0 15 6 5
0
end_operator
begin_operator
push-box-not-slippery2 r2c3 r2c4 r2c5 r2c6 right
1
0 0
4
0 7 -1 0
0 9 0 1
0 14 7 8
0 15 6 7
0
end_operator
begin_operator
push-box-not-slippery2 r3c1 r2c1 r1c1 r0c1 up
1
0 0
4
0 1 0 1
0 10 -1 0
0 14 4 0
0 15 9 4
0
end_operator
begin_operator
push-box-not-slippery2 r3c2 r2c2 r1c2 r0c2 up
1
0 0
4
0 2 0 1
0 11 -1 0
0 14 5 1
0 15 10 5
0
end_operator
begin_operator
push-box-not-slippery2 r3c2 r3c3 r3c4 r3c5 right
1
0 0
4
0 11 -1 0
0 13 0 1
0 14 11 12
0 15 10 11
0
end_operator
begin_operator
push-box-not-slippery2 r3c3 r2c3 r1c3 r0c3 up
1
0 0
4
0 3 0 1
0 12 -1 0
0 14 6 2
0 15 11 6
0
end_operator
begin_operator
push-box-not-slippery2 r3c3 r3c2 r3c1 r3c0 left
1
0 0
4
0 10 0 1
0 12 -1 0
0 14 10 9
0 15 11 10
0
end_operator
begin_operator
push-box-not-slippery2 r3c4 r2c4 r1c4 r0c4 up
1
0 0
4
0 4 0 1
0 13 -1 0
0 14 7 3
0 15 12 7
0
end_operator
begin_operator
push-box-not-slippery2_v2 r1c1 r1c2 r1c3 r1c4 right
2
0 0
4 1
4
0 1 -1 0
0 3 0 1
0 14 1 2
0 15 0 1
0
end_operator
begin_operator
push-box-not-slippery2_v2 r1c4 r1c3 r1c2 r1c1 left
2
0 0
1 1
4
0 2 0 1
0 4 -1 0
0 14 2 1
0 15 3 2
0
end_operator
begin_operator
push-box-not-slippery2_v2 r2c1 r2c2 r2c3 r2c4 right
2
0 0
8 1
4
0 5 -1 0
0 7 0 1
0 14 5 6
0 15 4 5
0
end_operator
begin_operator
push-box-not-slippery2_v2 r2c2 r2c3 r2c4 r2c5 right
2
0 0
9 1
4
0 6 -1 0
0 8 0 1
0 14 6 7
0 15 5 6
0
end_operator
begin_operator
push-box-not-slippery2_v2 r2c4 r2c3 r2c2 r2c1 left
2
0 0
5 1
4
0 6 0 1
0 8 -1 0
0 14 6 5
0 15 7 6
0
end_operator
begin_operator
push-box-not-slippery2_v2 r2c5 r2c4 r2c3 r2c2 left
2
0 0
6 1
4
0 7 0 1
0 9 -1 0
0 14 7 6
0 15 8 7
0
end_operator
begin_operator
push-box-not-slippery2_v2 r3c1 r3c2 r3c3 r3c4 right
2
0 0
13 1
4
0 10 -1 0
0 12 0 1
0 14 10 11
0 15 9 10
0
end_operator
begin_operator
push-box-not-slippery2_v2 r3c4 r3c3 r3c2 r3c1 left
2
0 0
10 1
4
0 11 0 1
0 13 -1 0
0 14 11 10
0 15 12 11
0
end_operator
begin_operator
push-box-slippery r2c2 r2c3 r2c4 r2c5 right
2
0 0
8 0
4
0 6 -1 0
0 9 0 1
0 14 6 8
0 15 5 6
0
end_operator
begin_operator
push-box-slippery r2c2 r2c3 r2c4 r2c5 right
2
0 0
9 0
4
0 6 -1 0
0 8 0 1
0 14 6 7
0 15 5 6
0
end_operator
0
