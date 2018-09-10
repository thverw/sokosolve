time(0..horizon).

dir(1,0;0,1;-1,0;0,-1).
at(N,X,Y,0) :- init(at(N,X,Y)).

1 { move(DX,DY,T) : dir(DX,DY) } 1 :- time(T), T>0.

at(0,X+DX,Y+DY,T) :- at(0,X,Y,T-1), move(DX,DY,T), time(T).
at(N,X+DX,Y+DY,T) :- at(N,X,Y,T-1), at(0,X,Y,T), move(DX,DY,T),
			time(T), N>0.
at(N,X,Y,T) :- at(N,X,Y,T-1), not at(0,X,Y,T), N>0, time(T).

:- not init(field(X,Y)), at(_,X,Y,_).
:- at(N,X,Y,T), at(M,X,Y,T), N>M, time(T).

uncvrd(X,Y,T) :- init(target(X,Y)), not at(_,X,Y,T), time(T).
goal(X,Y,T) :- init(target(X,Y)), not uncvrd(X,Y,T),
			not at(0,X,Y,T), time(T).
:- not goal(X,Y,horizon), init(target(X,Y)).

#show at/4.
