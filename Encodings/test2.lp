time(0..horizon).

dir(1,0;0,1;-1,0;0,-1).
at(N,X,Y,0) :- init(at(N,X,Y)).

% pick one target box
1 { goalAt(X,Y,T) : at(N,X,Y,T), N>0 } 1 :- time(T).
% stick to your goal
goalAt(X,Y,T) :- goalAt(X,Y,T-1), not at(0,X,Y,T-1), time(T).



%%%%%%%%%%%%%%%%%%%%VersionA

dirN(1,0,1;-1,0,-1;0,1,2;0,-1,-2).
way(1,X+DX,Y+DY,T,f(0,N)) :- goalAt(X,Y,T), not goalAt(X,Y,T-1), dirN(DX,DY,N), init(field(X+DX,Y+DY)), init(field(X-DX,Y-DY)), not at(_,X+DX,Y+DY,T), not at(_,X-DX,Y-DY,T).
way(2,X+DX,Y+DY,T,f(f(0,N),M)) :- way(1,X,Y,T,f(0,N)), M != -N, dirN(DX,DY,M), init(field(X+DX,Y+DY)), not at(_,X+DX,Y+DY,T).
way(N,X+DX,Y+DY,T,f(f(f(A,B),C),M)) :- way(N-1,X,Y,T,f(f(A,B),C)), B != -M, C != -M, dirN(DX,DY,M), init(field(X+DX,Y+DY)), not at(_,X+DX,Y+DY,T), T+N-1 < horizon, { way(K,X+DX,Y+DY,T,_) : K<N } = 0.
1 { goodWay(N,T,W) : way(N,X,Y,T,W) } 1 :- time(T), goalAt(A,B,T), not goalAt(A,B,T-1), at(0,X,Y,T).
myGoodWay(N,T,W) :- goodWay(N,T,W).
move(-DX,-DY,T+N-1), myGoodWay(N-1,T,A) :- myGoodWay(N,T,f(A,B)), dirN(DX,DY,B), N>0.


%sym_object(robot;shelf;packing_station).
sym_assign(TYPE, ID, V) :- sym_object(TYPE), init(object(TYPE,ID), value(at, (X,Y))), V= (Y-1) * SX + X, sizeX(SX).
sym_enabled(TYPE,ID,V) :- sym_assign(TYPE,ID,V), ID<=V, 1<ID.
sym_enabled(TYPE,ID,V-1) :- sym_enabled(TYPE,ID,V), ID<=V.
:- sym_assign(TYPE,ID,V), sym_object(TYPE), not sym_enabled(TYPE,ID+1,V), object(TYpe,ID+1).




% move the player
at(0,X+DX,Y+DY,T) :- at(0,X,Y,T-1), move(DX,DY,T), time(T).
% move box, the player collides with
at(N,X+DX,Y+DY,T) :- at(N,X,Y,T-1), at(0,X,Y,T), move(DX,DY,T), time(T), N>0.
% leave boxes that aren't touched at their place with t+1
at(N,X,Y,T) :- at(N,X,Y,T-1), not at(0,X,Y,T), N>0, time(T).


