time(0..horizon).

dir(1,0;0,1;-1,0;0,-1).
atX(N,X,0) :- init(at(N,X,_)).
atY(N,Y,0) :- init(at(N,_,Y)).

1 { move(DX,DY,T) : dir(DX,DY) } 1 :- time(T), T>0.

atX(0,X+DX,T) :- atX(0,X,T-1), move(DX,_,T), time(T).
atY(0,Y+DY,T) :- atY(0,Y,T-1), move(_,DY,T), time(T).

atX(N,X+DX,T) :- atX(N,X,T-1), move(DX,0,T), atX(0,X,T),
		atY(N,Y,T-1), atY(0,Y,T-1), N>0, time(T).
atY(N,Y+DY,T) :- atY(N,Y,T-1), move(0,DY,T), atY(0,Y,T),
		atX(N,X,T-1), atX(0,X,T-1), N>0, time(T).

atX(N,X,T) :- atX(N,X,T-1), atY(N,Y,T), N>0, time(T),
	{ atX(0,X,T) ; atY(0,Y,T) ; move(_,0,T) } 2.
atY(N,Y,T) :- atY(N,Y,T-1), atX(N,X,T), N>0, time(T),
	{ atX(0,X,T) ; atY(0,Y,T) ; move(0,_,T) } 2.

:- not init(field(X,Y)), atX(N,X,T), atY(N,Y,T).
:- atX(N,X,T), atY(N,Y,T), atX(M,X,T), atY(M,Y,T), N>M.

box(X,Y) :- atX(N,X,horizon), atY(N,Y,horizon), N>0.
goal(X,Y) :- init(target(X,Y)), box(X,Y).
:- not goal(X,Y), init(target(X,Y)).

#show atX/3.
#show atY/3.
