
#include <incmode>.

#program base.
dir(1,0;;0,1;;-1,0;;0,-1).
at(N,X,Y,0) :- init(at(N,X,Y)).

#program step(t).
:- 1 #sum {1 : at(N,1,_,t), N>0 ; -1 : init(target(1,_))}.
:- 1 #sum {1 : at(N,dimX,_,t), N>0 ; -1 : init(target(dimX,_))}.
:- 1 #sum {1 : at(N,_,1,t), N>0 ; -1 : init(target(_,1))}.
:- 1 #sum {1 : at(N,_,dimY,t), N>0 ; -1 : init(target(_,dimY))}.

% pick one direction to move in
1 { move(DX,DY,t) : dir(DX,DY) } 1.

% move the player
at(0,X+DX,Y+DY,t) :- at(0,X,Y,t-1), move(DX,DY,t).

% move box, the player collides with
at(N+1,X+DX,Y+DY,t) :- at(N+1,X,Y,t-1), at(0,X-DX,Y-DY,t-1), at(0,X,Y,t), move(DX,DY,t).

% leave boxes that aren't touched at their place with t+1
at(N,X,Y,t) :- at(N,X,Y,t-1), not at(0,X,Y,t), N>0.

% don't immediately take a move back
:- move(DX,DY,t), move(-DX,-DY,t-1), at(0,X,Y,t), not at(_,X-DX,Y-DY,t-1).

% there can't be boxes, players, where there is no field
:- not init(field(X,Y)), at(_,X,Y,_).

% there can't be two boxes/players, at the same spot
:- at(N,X,Y,t), at(M,X,Y,t), N>M.

dirPos(1;-1).
:- 4 #sum {1,1 : at(A,X+DX,Y,t), not init(target(X+DX,Y)), A>0 ; 1,1 : not init(field(X+DX,Y)) ;
            1,2 : at(B,X,Y+DY,t), not init(target(X,Y+DY)), B>0 ; 1,2 : not init(field(X,Y+DY)) ;
            1,3 : at(C,X+DX,Y+DY,t), not init(target(X+DX,Y+DY)), C>0 ; 1,2 : not init(field(X+DX,Y+DY)) ;
            1,4 : at(D,X,Y,t), not init(target(X,Y)), D>0 },
            dirPos(DX), dirPos(DY).


#program check(t).
#external query(t).
uncovered(X,Y,t) :- init(target(X,Y)), not at(_,X,Y,t), query(t).
goal(X,Y,t) :- init(target(X,Y)), not uncovered(X,Y,t), not at(0,X,Y,t), query(t).
:- not goal(X,Y,t), init(target(X,Y)), query(t).


#show at/4.
