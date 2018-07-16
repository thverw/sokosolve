time(0..horizon).

aPool(1..5).
dir(A,0;0,A;-A,0;0,-A) :- aPool(A).
at(N,X,Y,0) :- init(at(N,X,Y)).


% pick one direction to move in
1 { move(DX,DY,T) : dir(DX,DY) } 1 :- time(T).

% constraints for preventing deadlock through box on wall
:- 0 < #sum {1 : at(N+1,1,_,T) ; -1 : init(target(1,_))}, time(T).
:- 0 < #sum {1 : at(N+1,dimX,_,T) ; -1 : init(target(dimX,_))}, time(T).
:- 0 < #sum {1 : at(N+1,_,1,T) ; -1 : init(target(_,1))}, time(T).
:- 0 < #sum {1 : at(N+1,_,dimY,T) ; -1 : init(target(_,dimY))}, time(T).

% constraint for preventing moving over multiple boxes
minus(0;-1;-2;-3;-4;-5).
:- 2 {at(N+1,X+DX+A,Y+DY+B,T) : minus(A), minus(B), A <= DX, B <= DY, at(0,X,Y,T-1), move(DX,DY,T)}.

% move the player
at(0,X+DX,Y+DY,T) :- at(0,X,Y,T-1), move(DX,DY,T), time(T).
% move box, the player collides with

at(N+1,X+(DX/5),Y+(DY/5),T), info(A,B,DX,DY,T) :- minus(A), minus(B), A <= DX, B <= DY, at(N+1,X+A,Y+B,T-1), at(0,X-DX,Y-DY,T-1), at(0,X,Y,T), move(DX,DY,T), time(T).
% leave boxes that aren't touched at their place with t+1
at(N,X,Y,T) :- at(N,X,Y,T-1), not at(0,X,Y,T), N>0, time(T).
% there can't be boxes, players, where there is no field
:- move(DX,DY,T), move(-DX,-DY,T-1), at(0,X,Y,T), not at(_,X-DX,Y-DY,T-1), time(T).
:- not init(field(X,Y)), at(_,X,Y,_).
% there can't be two boxes/players, at the same spot
:- at(N,X,Y,T), at(M,X,Y,T), N>M, time(T).
dirPos(1;-1).
:- 3 #sum {1,1 : at(A,X+DX,Y,T), A>0 ; 1,1 : not init(field(X+DX,Y)) ;
            1,2 : at(B,X,Y+DY,T), B>0 ; 1,2 : not init(field(X,Y+DY)) ;
            1,3 : at(C,X+DX,Y+DY,T), C>0 ; 1,2 : not init(field(X+DX,Y+DY)) },
            dirPos(DX), dirPos(DY), at(N,X,Y,T), N>0, time(T).


uncovered(X,Y,T) :- init(target(X,Y)), not at(_,X,Y,T), time(T).
goal(X,Y,T) :- init(target(X,Y)), not uncovered(X,Y,T), not at(0,X,Y,T), time(T).
:- not goal(X,Y,horizon), init(target(X,Y)).

#show all.



#include <incmode>.

#program base.

dir(1,0;0,1;-1,0;0,-1).
at(N,X,Y,0) :- init(at(N,X,Y)).

#program step(t).
% pick one direction to move in
1 { move(DX,DY,t) : dir(DX,DY) } 1.
% move the player
at(0,X+DX,Y+DY,t) :- at(0,X,Y,t-1), move(DX,DY,t).
% move box, the player collides with
at(N+1,X+DX,Y+DY,t) :- at(N+1,X,Y,t-1), at(0,X-DX,Y-DY,t-1), at(0,X,Y,t), move(DX,DY,t).
% leave boxes that aren't touched at their place with t+1
at(N,X,Y,t) :- at(N,X,Y,t-1), not at(0,X,Y,t), N>0.
% there can't be boxes, players, where there is no field
:- move(DX,DY,t), move(-DX,-DY,t-1), at(0,X,Y,t), not at(_,X-DX,Y-DY,t-1).
:- not init(field(X,Y)), at(_,X,Y,_).
% there can't be two boxes/players, at the same spot
:- at(N,X,Y,t), at(M,X,Y,t), N>M.
dirPos(1;-1).
:- 4 #sum {1,1 : at(A,X+DX,Y,t), not init(target(X+DX,Y)), A>0 ; 1,1 : not init(field(X+DX,Y)) ;
            1,2 : at(B,X,Y+DY,t), not init(target(X,Y+DY)), B>0 ; 1,2 : not init(field(X,Y+DY)) ;
            1,3 : at(C,X+DX,Y+DY,t), not init(target(X+DX,Y+DY)), C>0 ; 1,2 : not init(field(X+DX,Y+DY)) ;
            1,4 : at(D,X,Y,t), not init(target(X,Y)), D>0 },
            dirPos(DX), dirPos(DY), init(field(N,X,Y,t)), N>0.


#program check(t).
#external query(t).
goal(X,Y,t) :- init(target(X,Y)), at(N+1,X,Y,t), query(t).
:- not goal(X,Y,t), init(target(X,Y)), query(t).

#show at/4.
