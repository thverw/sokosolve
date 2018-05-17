
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
at(N+1,X+DX,Y+DY,t) :- at(N+1,X,Y,t-1), at(0,X-DX,Y-DY,t), at(0,X,Y,t), move(DX,DY,t).
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


%uncovered(X,Y,t) :- init(target(X,Y)), not at(_,X,Y,t).
%goal(t) :- init(target(X,Y)), not uncovered(X,Y,t), not at(0,X,Y,t).%query(t).
%:- goal(t), uncovered(_,_,t), query(t).
%goal :- goal(t).
%:- time(horizon), not goal(horizon).
%:- not goal, query(t).

%#minimize{t : goal(t)}.

%#show move/3.
%#show goal/3.
%#show at/4.
#show all.












%

%time(0..horizon).
%dir( 1,0 ; 0,1 ; -1,0 ; 0,-1 ).
%at(N,X,Y,0) :- init(at(N,X,Y)).

%% forbidden(X,Y) :- init(field(X,Y)), not init(target(X,Y)), 3 #sum {3 : not init(field(X+DX,Y+DY)), not init(field(X+DY,Y+DX)), dir(DX,DY); 3 : not init(field(X+DX,Y+DY)), not init(field(X-DY,Y-DX)), dir(DX,DY); 1,1 : forbidden(X+DX,Y+DY), dir(DX,DY); 1,2 : forbidden(X+DX,Y+DY), dir(DX,DY), forbidden(X-DX,Y-DY); 1,3 : not init(field(X+DX,Y+DY)), dir(DX,DY); 1,4 : not init(field(X+DX,Y+DY)), not init(field(X-DX,Y-DY)), dir(DX,DY)}.

%1 { move(DX,DY,t) : dir(DX,DY) } 1 :- time(t).
%:- at(_,X,Y,_), not init(field(X,Y)).
%:- at(N,X,Y,t), at(M,X,Y,t), N>M.
%:- move(DX,DY,t), move(-DX,-DY,t-1), at(0,X,Y,t), not at(_,X-DX,Y-DY,t-1).
%at(0,X+DX,Y+DY,t) :- at(0,X,Y,t-1), move(DX,DY,t), init(field(X+DX,Y+DY)).
%at(N+1,X+DX,Y+DY,t) :- at(N+1,X,Y,t-1), at(0,X-DX,Y-DY,t), at(0,X,Y,t), move(DX,DY,t).
%% not forbidden(X+DX,Y+DY),
%at(N,X,Y,t) :- at(N,X,Y,t-1), not at(0,X,Y,t), N>0.

%uncovered(X,Y,t) :- init(target(X,Y)), not at(_,X,Y,t).
%goal(X,Y,t) :- init(target(X,Y)), not uncovered(X,Y,t), not at(0,X,Y,t).
%:- not goal(X,Y,horizon), init(target(X,Y)).


%#show at/4.
%#show move/3.
