time(0..horizon).

dir(1,0;0,1;-1,0;0,-1).
at(N,X,Y,0) :- init(at(N,X,Y)).

% pick one target box
1 { goalAt(X,Y,T) : at(N,X,Y,T), N>0 } 1 :- time(T).
% stick to your goal
goalAt(X,Y,T) :- goalAt(X,Y,T-1), not at(0,X,Y,T-1), time(T).



% creating a predicate for each free field at time T
free(X,Y,T) :- init(field(X,Y)), not at(_,X,Y,T), goalAt(A,B,T), not goalAt(A,B,T-1).
%% goto predicate is created whenever the goalAt changes
%% there's one for every direction the box can go (always even (0,2,4))
goto(X2+DX,Y2+DY,T) :- at(0,X1,Y1,T),
	goalAt(X2,Y2,T), not goalAt(X2,Y2,T-1),
	free(X2+DX,Y2+DY,T), free(X2-DX,Y2-DY,T), dir(DX,DY).


%% NO 12, 1*2, 21, 2*1, 34, 43, 3*4, 4*3
%% n stellen, die letzten 2 stellen sind, x*10+l
dirN(1,0,1;-1,0,2;0,1,4;0,-1,5).
eleA(1;4).
eleB(2;5).
ele1(1;5).ele2(2;4).
ele(1;2;4;5).
h(1;-1).
sum(C,0,0,C) :- ele(C).
sum(B*10+C,0,B,C) :- sum(B,0,0,B),eleA(B),eleA(C).
sum(B*10+C,0,B,C) :- sum(B,0,0,B),eleB(B),eleB(C).
sum(B*10+C,0,B,C) :- sum(B,0,0,B),ele1(B),ele1(C).
sum(B*10+C,0,B,C) :- sum(B,0,0,B),ele2(B),ele2(C).
sum(A*100+B*10+C,A,B,C) :- eleA(A),eleA(B),eleA(C).
sum(A*100+B*10+C,A,B,C) :- eleB(A),eleB(B),eleB(C).
sum(A*100+B*10+C,A,B,C) :- ele1(A),ele1(B),ele1(C).
sum(A*100+B*10+C,A,B,C) :- ele2(A),ele2(B),ele2(C).
sum(A*10+B,X,Y,B) :- sum(A,W,X,Y), ele1(X), ele1(Y), ele1(B), A<(10 ** horizon).
sum(A*10+B,X,Y,B) :- sum(A,W,X,Y), ele2(X), ele2(Y), ele2(B), A<(10 ** horizon).
sum(A*10+B,X,Y,B) :- sum(A,W,X,Y), eleA(X), eleA(Y), eleA(B), A<(10 ** horizon).
sum(A*10+B,X,Y,B) :- sum(A,W,X,Y), eleB(X), eleB(Y), eleB(B), A<(10 ** horizon).
way(1,X+DX,Y+DY,T,K) :- at(0,X,Y,T), goto(X2,Y2,T), not goto(X2,Y2,T-1), sum(K,0,0,A),dirN(DX,DY,A),free(X+DX,Y+DY,T).
way(N,X+DX,Y+DY,T,K) :- way(N-1,X,Y,T,L),sum(K,B,C,M), sum(L,_,B,C), dirN(DX,DY,M), free(X,Y,T), N+T<horizon+1.
goodWay(N+1,X+DX,Y+DY,T,L*10+K) :- way(N,X,Y,T,L), sum(L,_,B,C),dirN(DX,DY,K),goto(X,Y,T),goalAt(X+DX,Y+DY,T).
#minimize { W@1,X,Y,T : goodWay(_,X,Y,T,W) }.
#minimize { N@2,X,Y,T : goodWay(N,X,Y,T,_) }.


%% HERE IM TRYING TO GET THE MOVES BY USING GOTO/3 AND THE FREE/3 PREDICATES
%% THIS WILL BE GROUNDED TO ALL POSSIBLE WAYS FROM at(0,X,Y) TO goto(X2,Y2,T)
%% => VERY BAD BEHAVIOUR ; GROUNDS FOREVER (ALSO BC FREE/4 DOESNT LIMIT THE VALUE OF N :D)

move(DX,DY,T+N) :- goodWay(N,_,_,T,K),sum(K,_,_,C),dirN(DX,DY,C).
khelper(T,K,A,B,C) :- goodWay(_,_,_,T,K),sum(K,A,B,C).
khelper(T,K,X,A,B) :- khelper(T,L,A,B,C), sum(K,X,A,B),sum(L,A,B,C),L=K*10+C.
move(DX,DY,T-1) :- move(DX2,DY2,T),khelper(T,K,A,B,C),dirN(DX,DY,B),dirN(DX2,DY2,C).
%move(DX,DY,M-N+T) :- m(DX,DY,N,T), topbound(M,T).
{ move(DX,DY,T) : dir(DX,DY) } = 1 :- time(T), T>0.


at(0,X+DX,Y+DY,T) :- at(0,X,Y,T-1), move(DX,DY,T), time(T).
% move box, the player collides with
at(N,X+DX,Y+DY,T) :- at(N,X,Y,T-1), at(0,X,Y,T), move(DX,DY,T), time(T), N>0.
% leave boxes that aren't touched at their place with t+1
at(N,X,Y,T) :- at(N,X,Y,T-1), not at(0,X,Y,T), N>0, time(T).
uncovered(X,Y,T) :- init(target(X,Y)), not at(_,X,Y,T), time(T).
goal(X,Y,T) :- init(target(X,Y)), not uncovered(X,Y,T), not at(0,X,Y,T), time(T).
:- not goal(X,Y,horizon), init(target(X,Y)).


#show move/3.
