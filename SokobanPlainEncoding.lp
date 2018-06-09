time(0..horizon).

dir(1,0;0,1;-1,0;0,-1).
at(N,X,Y,0) :- init(at(N,X,Y)).
%atX(N,X,0) :- init(at(N,X,Y)).
%atY(N,Y,0) :- init(at(N,X,Y)).


% pick one direction to move in
1 { move(DX,DY,T) : dir(DX,DY) } 1 :- time(T).
% move the player
at(0,X+DX,Y+DY,T) :- at(0,X,Y,T-1), move(DX,DY,T), time(T).
% move box, the player collides with
at(N+1,X+DX,Y+DY,T) :- at(N+1,X,Y,T-1), at(0,X,Y,T), move(DX,DY,T), time(T).
% leave boxes that aren't touched at their place with t+1
at(N,X,Y,T) :- at(N,X,Y,T-1), not at(0,X,Y,T), N!=0, time(T).
% there can't be boxes, players, where there is no field
:- not init(field(X,Y)), at(_,X,Y,_).
% there can't be two boxes/players, at the same spot
:- at(N,X,Y,T), at(M,X,Y,T), N!=M, time(T).




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
