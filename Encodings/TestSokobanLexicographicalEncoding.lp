time(0..horizon).

dir(1,0;0,1;-1,0;0,-1).
at(N,X,Y,0) :- init(at(N,X,Y)).

% pick one target box
1 { goalAt(X,Y,T) : at(N,X,Y,T), N>0 } 1 :- time(T).
% stick to your goal
goalAt(X,Y,T) :- goalAt(X,Y,T-1), not at(0,X,Y,T-1).
% creating a predicate for each free field at time T
%free(X,Y,T) :- init(field(X,Y)), not at(_,X,Y,T), goalAt(A,B,T), not goalAt(A,B,T-1).
%% goto predicate is created whenever the goalAt changes
%% there's one for every direction the box can go (always even (0,2,4))
goto(X2+DX,Y2+DY,T) :- at(0,X1,Y1,T),
	goalAt(X2,Y2,T), not goalAt(X2,Y2,T-1),
	free(X2+DX,Y2+DY,T), free(X2-DX,Y2-DY,T), dir(DX,DY).


%1 { free(0,X,Y,T) : goto(X,Y,T) } 1.
%free(N,X,Y,T), m(-DX,-DY,N,T) :- free(N-1,X+DX,Y+DY,T), dir(DX,DY), free(X,Y,T).
topbound(N+1,T) :- goto(X,Y,T), free(N,X+DX,Y+DY,T), dir(DX,DY).
move(DX,DY,M-N+T) :- m(DX,DY,N,T), topbound(M,T).

% move the player
at(0,X+DX,Y+DY,T) :- at(0,X,Y,T-1), move(DX,DY,T), time(T).
% move box, the player collides with
at(N,X+DX,Y+DY,T) :- at(N,X,Y,T-1), at(0,X,Y,T), move(DX,DY,T), time(T), N>0.
% leave boxes that aren't touched at their place with t+1
at(N,X,Y,T) :- at(N,X,Y,T-1), not at(0,X,Y,T), N>0, time(T).
% there can't be boxes, players, where there is no field
:- not init(field(X,Y)), at(_,X,Y,_).
% there can't be two boxes/players, at the same spot
:- at(N,X,Y,T), at(M,X,Y,T), N>M, time(T).

uncovered(X,Y,T) :- init(target(X,Y)), not at(_,X,Y,T), time(T).
goal(X,Y,T) :- init(target(X,Y)), not uncovered(X,Y,T), not at(0,X,Y,T), time(T).
:- not goal(X,Y,horizon), init(target(X,Y)).

#show at/4.
