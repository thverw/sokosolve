#const horizon=8.
time(0..horizon).
dir(1,0;0,1;-1,0;0,-1).
safeDXDY(1;2;3;-1;-2;-3;0).

at(N,X,Y,0) :- init(at(N,X,Y)).

:- not init(field(X,Y)), at(_,X,Y,_).
:- at(N,X,Y,T), at(M,X,Y,T), N!=M, time(T).
:- at(0,X,Y,T), at(0,X+DX,Y+DY,T+1), move(DX,DY,T), time(T+1), not dir(DX,DY).


1 { at(0,X,Y,T) : init(field(X,Y)) } 1 :- time(T).

move(DX,DY,T-1) :- at(0,X,Y,T-1), at(0,X+DX,Y+DY,T), time(T), safeDXDY(DX), safeDXDY(DY).
at(N+1,X+DX,Y+DY,T) :- at(N+1,X,Y,T-1), at(0,X,Y,T), move(DX,DY,T-1), time(T).
at(N+1,X,Y,T) :- at(N+1,X,Y,T-1), not at(0,X,Y,T), time(T).


success(X,Y) :- init(target(X,Y)), at(N,X,Y,horizon), N!=0.

#show move/3.
#show at/4.