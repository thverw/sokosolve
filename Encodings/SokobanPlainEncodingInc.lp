#include <incmode>.

#program base.
dir( 1,0 ; 0,1 ; -1,0 ; 0,-1 ).
at(N,X,Y,0) :- init(at(N,X,Y)).

#program step(t).
% pick one direction to move in
1 { move(DX,DY,t) : dir(DX,DY) } 1.
% move the player
at(0,X+DX,Y+DY,t) :- at(0,X,Y,t-1), move(DX,DY,t), init(field(X+DX,Y+DY)).
% move box, the player collides with
at(N,X+DX,Y+DY,t) :- at(N,X,Y,t-1), at(0,X,Y,t), move(DX,DY,t), N>0.
% leave boxes that aren't touched at their place with t+1
at(N,X,Y,t) :- at(N,X,Y,t-1), not at(0,X,Y,t), N>0.
% there can't be boxes, players, where there is no field
:- at(_,X,Y,_), not init(field(X,Y)).
% there can't be two boxes/players, at the same spot
:- at(N,X,Y,t), at(M,X,Y,t), N>M.

#program check(t).
#external query(t).
uncovered(X,Y,t) :- init(target(X,Y)), not at(_,X,Y,t), query(t).
goal(X,Y,t) :- init(target(X,Y)), not uncovered(X,Y,t), not at(0,X,Y,t), query(t).
:- not goal(X,Y,t), init(target(X,Y)), query(t).

#show at/4.
