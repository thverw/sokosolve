#include <incmode>.

#program base.
dir( 1,0 ; 0,1 ; -1,0 ; 0,-1 ).
at(N,X,Y,0) :- init(at(N,X,Y)).

#program step(t).
1 { move(DX,DY,t) : dir(DX,DY) } 1.

at(0,X+DX,Y+DY,t) :- at(0,X,Y,t-1), move(DX,DY,t).
at(N,X+DX,Y+DY,t) :- at(N,X,Y,t-1), at(0,X,Y,t),
			move(DX,DY,t), N>0.
at(N,X,Y,t) :- at(N,X,Y,t-1), not at(0,X,Y,t), N>0.

:- at(_,X,Y,_), not init(field(X,Y)).
:- at(N,X,Y,t), at(M,X,Y,t), N>M.

#program check(t).
#external query(t).
box(X,Y,t) :- at(N,X,Y,t), N>0, query(t).
:- not box(X,Y,t), init(target(X,Y)), query(t).

#show at/4.
