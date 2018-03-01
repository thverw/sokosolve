#const horizon=7.
time(1..horizon+1).
dir(1,0;0,1;-1,0;0,-1).

at(N,X,Y,0) :- init(at(N,X,Y)).
atX(N,X,0) :- init(at(N,X,Y)).
atY(N,Y,0) :- init(at(N,X,Y)).

:- not init(field(X,Y)), at(_,X,Y,_).
:- at(N,X,Y,T), at(M,X,Y,T), N!=M, time(T).


1 { move(DX,DY,T-1) : dir(DX,DY) } 1 :- time(T).

%TODO: split, e.g. atX(3, 5). atY(3, 1).
%TODO: generalize at(X,Y) :- at(N+1, X, Y).


at(0,X+DX,Y+DY,T) :- at(0,X,Y,T-1), move(DX,DY,T-1), time(T).
at(N+1,X+DX,Y+DY,T) :- at(N+1,X,Y,T-1), at(0,X,Y,T), move(DX,DY,T-1), time(T).
at(N,X,Y,T) :- at(N,X,Y,T-1), not at(0,X,Y,T), time(T), N!=0.

%goal:
uncovered(X,Y,T) :- init(target(X,Y)), not at(_,X,Y,T), time(T).
goal(T) :- init(target(X,Y)), not uncovered(X,Y,T), not at(0,X,Y,T), time(T).
goal :- goal(T).
:- not goal.

%#minimize{T : goal(T)}.

%#show move/3.
%#show goal/1.
#show at/4.
