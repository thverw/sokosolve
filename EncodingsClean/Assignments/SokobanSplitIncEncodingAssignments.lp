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

atX(N,X,t) :- atX(N,X,t-1), N>0, not atX(0,X,t).
atX(N,X,t) :- atX(N,X,t-1), atY(N,Y,t), N>0,
	not atY(0,Y,t).
atX(N,X,t) :- atX(N,X,t-1), N>0, not move(_,0,t).

atY(N,Y,t) :- atY(N,Y,t-1), N>0, not atY(0,Y,t).
atY(N,Y,t) :- atY(N,Y,t-1), atX(N,X,t), N>0,
	not atX(0,X,t).
atY(N,Y,t) :- atY(N,Y,t-1), N>0, not move(0,_,t).

:- not init(field(X,Y)), atX(N,X,t), atY(N,Y,t).
:- atX(N,X,t), atY(N,Y,t), atX(M,X,t), atY(M,Y,t), N>M.


#program check(t).
#external query(t).
:- init(target(N,X,_)), not atX(N,X,t), query(t).
:- init(target(N,_,Y)), not atY(N,Y,t), query(t).
