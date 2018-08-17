time(0..horizon).

dir(1,0;0,1;-1,0;0,-1).
at(N,X,Y,0) :- init(at(N,X,Y)).

% pick one target box
1 { goalAt(X,Y,T) : at(N,X,Y,T), N>0 } 1 :- time(T).
% stick to your goal
goalAt(X,Y,T) :- goalAt(X,Y,T-1), not at(0,X,Y,T-1), time(T).
blocked(X,Y,T) :- goalAt(X2,_,T), at(N,X,Y,T), N>0, X!=X2.
blocked(X,Y,T) :- goalAt(_,Y2,T), at(N,X,Y,T), N>0, Y!=Y2.



% creating a predicate for each free field at time T
free(X,Y,T) :- init(field(X,Y)), not at(_,X,Y,T), goalAt(A,B,T), not goalAt(A,B,T-1).
%% goto predicate is created whenever the goalAt changes
%% there's one for every direction the box can go (always even (0,2,4))
goto(X2+DX,Y2+DY,T,X2+DX-X1,Y2+DY-Y1) :- at(0,X1,Y1,T),
	goalAt(X2,Y2,T), not goalAt(X2,Y2,T-1),
	free(X2+DX,Y2+DY,T), free(X2-DX,Y2-DY,T), dir(DX,DY).


%% NO 12, 1*2, 21, 2*1, 45, 54, 4*5, 5*4
%% I ONLY WANNA GROUND THE SHORT WAYS, AND ONLY IF NO OTHER WAY EXISTS
dirN(1,0,0;-1,0,1;0,1,2;0,-1,3).
%way(1,X+DX,Y+DY,T,K) :- at(0,X,Y,T), goto(X2,Y2,T), sum(K,0,0,K),dirN(DX,DY,K),free(X+DX,Y+DY,T).
%way(N,X+DX,Y+DY,T,K) :- way(N-1,X,Y,T,L),sum(K,B,C,M), sum(L,_,B,C), dirN(DX,DY,M), free(X,Y,T), N+T<horizon+1.
%goodWay(N+1,X+DX,Y+DY,T,L*10+K) :- way(N,X,Y,T,L), sum(L,_,B,C),dirN(DX,DY,K),goto(X,Y,T),goalAt(X+DX,Y+DY,T).

way(1,X+DX,Y+DY,T,f(K)) :- at(0,X,Y,T), goto(_,_,T,_,_), dirN(DX,DY,K), free(X+DX,Y+DY,T).
way(N+1,X+DX,Y+DY,T,f()) :- way(N,X,Y,T,f()), dirN(DX,DY,M), free(X,Y,T), N+T-1<horizon.
%at(0,X1,Y1,T), goto(X2,Y2,T,DISX,DISY), 

eleA(0;3).
eleB(1;2).
ele1(0;2).ele2(1;3).
ele(0;1;2;3).
sum(C,-1,-1,C) :- ele(C).
sum(B*4+C,-1,B,C) :- sum(B,-1,-1,B),eleA(B),eleA(C).
sum(B*4+C,-1,B,C) :- sum(B,-1,-1,B),eleB(B),eleB(C).
sum(B*4+C,-1,B,C) :- sum(B,-1,-1,B),ele1(B),ele1(C).
sum(B*4+C,-1,B,C) :- sum(B,-1,-1,B),ele2(B),ele2(C).
sum(A*16+B*4+C,A,B,C) :- eleA(A),eleA(B),eleA(C).
sum(A*16+B*4+C,A,B,C) :- eleB(A),eleB(B),eleB(C).
sum(A*16+B*4+C,A,B,C) :- ele1(A),ele1(B),ele1(C).
sum(A*16+B*4+C,A,B,C) :- ele2(A),ele2(B),ele2(C).
%% PROBLEM: A⁽¹¹⁾ funktioniert nicht mehr (Overflow führt zu komischen Zahlen) KEINE WARNUNG VOM COMPILER!!
sum(A*4+B,X,Y,B) :- sum(A,W,X,Y), ele1(X), ele1(Y), ele1(B), A<(4 ** horizon).
sum(A*4+B,X,Y,B) :- sum(A,W,X,Y), ele2(X), ele2(Y), ele2(B), A<(4 ** horizon).
sum(A*4+B,X,Y,B) :- sum(A,W,X,Y), eleA(X), eleA(Y), eleA(B), A<(4 ** horizon).
sum(A*4+B,X,Y,B) :- sum(A,W,X,Y), eleB(X), eleB(Y), eleB(B), A<(4 ** horizon).
way(1,X+DX,Y+DY,T,K) :- at(0,X,Y,T), goto(X2,Y2,T,_,_), sum(K,0,0,A),dirN(DX,DY,A),free(X+DX,Y+DY,T).
way(N,X+DX,Y+DY,T,K) :- way(N-1,X,Y,T,L),sum(K,B,C,M), sum(L,_,B,C), dirN(DX,DY,M), free(X,Y,T), N+T<horizon+1.
goodWay(N+1,X+DX,Y+DY,T,L*4+K) :- way(N,X,Y,T,L), sum(L,_,B,C),dirN(DX,DY,K),goto(X,Y,T,_,_),goalAt(X+DX,Y+DY,T).
#minimize { W@1,X,Y,T : goodWay(_,X,Y,T,W) }.
#minimize { N@2,X,Y,T : goodWay(N,X,Y,T,_) }.


%% HERE IM TRYING TO GET THE MOVES BY USING GOTO/3 AND THE FREE/3 PREDICATES
%% THIS WILL BE GROUNDED TO ALL POSSIBLE WAYS FROM at(0,X,Y) TO goto(X2,Y2,T)
%% => VERY BAD BEHAVIOUR ; GROUNDS FOREVER (ALSO BC FREE/4 DOESNT LIMIT THE VALUE OF N :D)
%% UPDATE: IT NOW STILL GROUNDS ALL WAYS, 

move(DX,DY,T+N) :- goodWay(N,_,_,T,K),sum(K,_,_,C),dirN(DX,DY,C).
reductor(K,A,B,C,T-1) :- reductor(K*4+L,B,C,L,T), sum(K,A,B,C), time(T-1).
reductor(K,A,B,C,T+N) :- goodWay(N,_,_,T,K), sum(K,A,B,C).
move(DX,DY,T) :- reductor(K,A,B,C,T), dirN(DX,DY,C).
%move(DX,DY,T-1) :- move(DX2,DY2,T),reductor(K,A,B,C,T),dirN(DX,DY,B),dirN(DX2,DY2,C).
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


#show reductor/5.
