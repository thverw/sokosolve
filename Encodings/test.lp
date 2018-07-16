time(0..horizon).

aPool(1..2).
dir(A,0;0,A;-A,0;0,-A) :- aPool(A).
at(N,X,Y,0) :- init(at(N,X,Y)).

% constraints for preventing deadlock through box on wall
:- 0 < X, X = #sum {1 : at(N,1,_,T), N>0 ; -1 : init(target(1,_))}, time(T).
:- 0 < X, X = #sum {1 : at(N,dimX,_,T), N>0 ; -1 : init(target(dimX,_))}, time(T).
:- 0 < X, X = #sum {1 : at(N,_,1,T), N>0 ; -1 : init(target(_,1))}, time(T).
:- 0 < X, X = #sum {1 : at(N,_,dimY,T), N>0 ; -1 : init(target(_,dimY))}, time(T).

%%% CHANGE THE MIN NUMBER TO NOTHING MEANING THERE CAN BE ONE OR NONE
%%% ALSO ADD A CONSTRAINT TO PREVENT MULTIPLE MOVES IN THE SAME DIRECTION
%%% ALSO CHANGE THE AT IMPLICATIONS (OBVIOUSLY)
%%% ALSO ADD CONSTRAINT TO PREVENT MULTIPLE STEPS IN ONE T

% constraint for preventing moving over multiple boxes
minus(0..-5).
yo :- 2 {at(N,X+DX+A,Y+DY+B,T) : minus(A), minus(B), A <= DX, B <= DY, at(0,X,Y,T-1), move(DX,DY,T), N>0}.

% pick one direction to move in
1 { move(DX,DY,T) : dir(DX,DY), |DX+DY| <= T } 1 :- time(T).
% move the player
at(0,X+DX,Y+DY,T) :- at(0,X,Y,T-1), move(DX,DY,T), time(T).
% move box, the player collides with
at(N+1,X+(DX/5),Y+(DY/5),T) :- minus(A), minus(B), |A| <= |DX|, |B| <= |DY|, at(N+1,X+A,Y+B,T-1), at(0,X-DX,Y-DY,T-1), at(0,X,Y,T), move(DX,DY,T), time(T).
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


%uncovered(X,Y,T) :- init(target(X,Y)), not at(_,X,Y,T), time(T).
%goal(T) :- init(target(X,Y)), not uncovered(X,Y,T), not at(0,X,Y,T), time(T).%query(T).
%:- goal(T), uncovered(_,_,T), query(T).
%goal :- goal(T).
%:- time(horizon), not goal(horizon).
%:- not goal, query(T).

%#minimize{T : goal(T)}.

#show yo/1.
%#show goal/1.

