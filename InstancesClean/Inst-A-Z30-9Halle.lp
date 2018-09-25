#const horizon=70.
#const dimX = 6.
#const dimY = 5.
init(field(1..6,1..5)).
init(at(0,3,5)).
init(at(1,4,1)).
init(at(2,2,2)).
init(at(3,4,2)).
init(at(4,2,3)).
init(at(5,4,3)).
init(at(6,3,4)).
init(at(7,4,4)).
init(at(8,2,5)).
init(at(9,4,5)).
init(target(5,1)).
init(target(5,2)).
init(target(5,3)).
init(target(5,5)).
init(target(6,1)).
init(target(6,2)).
init(target(6,3)).
init(target(6,4)).
init(target(6,5)).

move(1,0,1).	%R
move(1,0,2).	%R
move(-1,0,3).	%L
move(-1,0,4).	%L
move(0,-1,5).	%U

move(0,-1,6).	%U
move(0,1,7).	%D
move(-1,0,8).	%L
move(-1,0,9).	%L
move(0,1,10).	%D

move(1,0,11).	%R
move(1,0,12).	%R
move(1,0,13).	%R
move(-1,0,14).	%L
move(0,-1,15).	%U

move(1,0,16).	%R
move(1,0,17).	%R
move(-1,0,18).	%L
move(-1,0,19).	%L
move(0,-1,20).	%U

move(1,0,21).	%R
move(1,0,22).	%R
move(0,1,23).	%U
move(-1,0,24).	%L
move(-1,0,25).	%L

move(-1,0,26).	%L
move(-1,0,27).	%L
move(0,-1,28).	%U
move(1,0,29).	%R
move(1,0,30).	%R

move(1,0,31).	%R
move(-1,0,32).	%L
move(-1,0,33).	%L
move(-1,0,34).	%L
move(0,-1,35).	%U

move(0,-1,36).	%U
move(1,0,37).	%R
move(1,0,38).	%R
move(1,0,39).	%R
move(1,0,40).	%R

move(-1,0,41).	%L
move(-1,0,42).	%L
move(-1,0,43).	%L
move(-1,0,44).	%L
move(0,1,45).	%D

move(0,1,46).	%D
move(1,0,47).	%R
move(1,0,48).	%R
move(0,-1,49).	%U
move(0,1,50).	%D
%RRllU5 Udlld10 RRRlu15 RRllu20 RRdll25 lluRR30 Rlllu35 urrRR40 lllld45 drrUd50 lluur55 RRldR60 Rlull65 ldRRR70









