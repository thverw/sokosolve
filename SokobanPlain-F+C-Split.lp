time(0..horizon).

dir(1,0;0,1;-1,0;0,-1).
at(N,X,Y,0) :- init(at(N,X,Y)).


% pick one direction to move in
1 { move(DX,DY,T) : dir(DX,DY) } 1 :- time(T).
% move the player
at(0,X+DX,Y+DY,T) :- at(0,X,Y,T-1), move(DX,DY,T), time(T).
% move box, the player collides with
at(N+1,X+DX,Y+DY,T) :- at(N+1,X,Y,T-1), at(0,X-DX,Y-DY,t), at(0,X,Y,T), move(DX,DY,T), time(T).
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

%#show move/3.
%#show goal/1.
#show at/4.












%

%time(0..horizon).
%dir( 1,0 ; 0,1 ; -1,0 ; 0,-1 ).
%at(N,X,Y,0) :- init(at(N,X,Y)).

%% forbidden(X,Y) :- init(field(X,Y)), not init(target(X,Y)), 3 #sum {3 : not init(field(X+DX,Y+DY)), not init(field(X+DY,Y+DX)), dir(DX,DY); 3 : not init(field(X+DX,Y+DY)), not init(field(X-DY,Y-DX)), dir(DX,DY); 1,1 : forbidden(X+DX,Y+DY), dir(DX,DY); 1,2 : forbidden(X+DX,Y+DY), dir(DX,DY), forbidden(X-DX,Y-DY); 1,3 : not init(field(X+DX,Y+DY)), dir(DX,DY); 1,4 : not init(field(X+DX,Y+DY)), not init(field(X-DX,Y-DY)), dir(DX,DY)}.

%1 { move(DX,DY,T) : dir(DX,DY) } 1 :- time(T).
%:- at(_,X,Y,_), not init(field(X,Y)).
%:- at(N,X,Y,T), at(M,X,Y,T), N>M, time(T).
%:- move(DX,DY,T), move(-DX,-DY,T-1), at(0,X,Y,T), not at(_,X-DX,Y-DY,T-1), time(T).
%at(0,X+DX,Y+DY,T) :- at(0,X,Y,T-1), move(DX,DY,T), init(field(X+DX,Y+DY)), time(T).
%at(N+1,X+DX,Y+DY,T) :- at(N+1,X,Y,T-1), at(0,X,Y,T), move(DX,DY,T), time(T).
%% not forbidden(X+DX,Y+DY),
%at(N,X,Y,T) :- at(N,X,Y,T-1), not at(0,X,Y,T), N>0, time(T).

%uncovered(X,Y,T) :- init(target(X,Y)), not at(_,X,Y,T), time(T).
%goal(X,Y,T) :- init(target(X,Y)), not uncovered(X,Y,T), not at(0,X,Y,T), time(T).
%:- not goal(X,Y,horizon), init(target(X,Y)).


%#show at/4.
%#show move/3.
