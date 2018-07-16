#include <incmode>.

#program base.
dir(1,0;0,1;-1,0;0,-1).
atX(N,X,0) :- init(at(N,X,Y)).
atY(N,Y,0) :- init(at(N,X,Y)).

forbidden(X,Y) :- init(field(X,Y)), not init(target(X,Y)),
3 #sum {3 : not init(field(X+DX,Y+DY)), not init(field(X+DY,Y+DX)), dir(DX,DY);
 3 : not init(field(X+DX,Y+DY)), not init(field(X-DY,Y-DX)), dir(DX,DY);
 1,1 : forbidden(X+DX,Y+DY), dir(DX,DY); 1,2 : forbidden(X+DX,Y+DY), dir(DX,DY), forbidden(X-DX,Y-DY);
 1,3 : not init(field(X+DX,Y+DY)), dir(DX,DY);
 1,4 : not init(field(X+DX,Y+DY)), not init(field(X-DX,Y-DY)), dir(DX,DY)}.

#program step(t).
% pick one direction to move in
1 { move(DX,DY,t) : dir(DX,DY) } 1.
% move the player
atX(0,X+DX,t) :- atX(0,X,t-1), move(DX,_,t).
atY(0,Y+DY,t) :- atY(0,Y,t-1), move(_,DY,t).
% move box, the player collides with
atX(N+1,X+DX,t) :- atX(N+1,X,t-1), atX(0,X,t), atX(0,X-DX,t-1), atY(N+1,Y,t-1), atY(0,Y,t), move(DX,_,t).
atY(N+1,Y+DY,t) :- atX(N+1,X,t-1), atX(0,X,t), atY(0,Y-DY,t-1), atY(N+1,Y,t-1), atY(0,Y,t), move(_,DY,t).
% leave boxes that aren't touched at their place with t+1
atX(N,X,t) :- atX(N,X,t-1), atY(N,Y,t-1), { atX(0,X,t) ; atY(0,Y,t) } 1, N>0.
atY(N,Y,t) :- atX(N,X,t-1), atY(N,Y,t-1), { atX(0,X,t) ; atY(0,Y,t) } 1, N>0.
% there can't be boxes, players, where there is no field
:- not init(field(X,Y)), atX(N,X,t), atY(N,Y,t).
% there can't be two boxes/players, at the same spot
:- atX(N,X,t), atX(M,X,t), atY(N,Y,t), atY(M,Y,t), N>M.
% forbidden fields
:- atX(N,X,t), atY(N,Y,t), forbidden(X,Y), N>0, t>0, { atX(N,X,t-1) ; atY(N,Y,t-1) } 1.
dirPos(1;-1).
:- 3 #sum {1,1 : atX(A,X+DX,t), atY(A,Y,t), A>0 ; 1,1 : not init(field(X+DX,Y)) ;
            1,2 : atX(B,X,t), atY(B,Y+DY,t), B>0 ; 1,2 : not init(field(X,Y+DY)) ;
            1,3 : atX(C,X+DX,t), atY(C,Y+DY,t), C>0 ; 1,2 : not init(field(X+DX,Y+DY)) },
            dirPos(DX), dirPos(DY), atX(N,X,t), atY(N,Y,t), N>0.

#program check(t).
#external query(t).

covered(X,Y,t) :- init(target(X,Y)), atX(N,X,t), atY(N,Y,t), query(t).
goal(X,Y,t) :- init(target(X,Y)), covered(X,Y,t), { atX(0,X,t) ; atY(0,Y,t) } 1, query(t).
:- not goal(X,Y,horizon), init(target(X,Y)), query(t).

#show move/3.
