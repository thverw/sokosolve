#include <incmode>.

#program base.
dir(1,0;0,1;-1,0;0,-1).
atX(N,X,0) :- init(at(N,X,_)).
atY(N,Y,0) :- init(at(N,_,Y)).


#program step(t).
1 { move(DX,DY,t) : dir(DX,DY) } 1.

atX(0,X+DX,t) :- atX(0,X,t-1), move(DX,_,t).
atY(0,Y+DY,t) :- atY(0,Y,t-1), move(_,DY,t).

atX(N,X+DX,t) :- atX(N,X,t-1), atX(0,X,t), move(DX,0,t),
		atY(N,Y,t-1), atY(0,Y,t-1), N>0.
atY(N,Y+DY,t) :- atY(N,Y,t-1), atY(0,Y,t), move(0,DY,t),
		atX(N,X,t-1), atX(0,X,t-1), N>0.

atX(N,X,t) :- atX(N,X,t-1), atY(N,Y,t), N>0,
	{ atX(0,X,t) ; atY(0,Y,t) ; move(_,0,t) } 2.
atY(N,Y,t) :- atY(N,Y,t-1), atX(N,X,t), N>0,
	{ atX(0,X,t) ; atY(0,Y,t) ; move(0,_,t) } 2.

:- not init(field(X,Y)), atX(N,X,t), atY(N,Y,t).
:- atX(N,X,t), atY(N,Y,t), atX(M,X,t), atY(M,Y,t), N>M.


#program check(t).
#external query(t).
boxX(N,X,t) :- atX(N,X,t), N>0.
boxY(N,Y,t) :- atY(N,Y,t), N>0.
goal(X,Y,t) :- init(target(X,Y)), boxX(N,X,t), boxY(N,Y,T), query(t).
:- not goal(X,Y,t), init(target(X,Y)), query(t).

#show atX/3.
#show atY/3.
