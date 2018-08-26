time(0..horizon).

dir(1,0;0,1;-1,0;0,-1).
at(N,X,Y,0) :- init(at(N,X,Y)).

% pick one target box
1 { goalAt(X,Y,T) : at(N,X,Y,T), N>0 } 1 :- time(T).
% stick to your goal
goalAt(X,Y,T) :- goalAt(X,Y,T-1), not at(0,X,Y,T-1), time(T).



%%%%%%%%%%%%%%%%%%%%VersionA

dirN(1,0,0;-1,0,1;0,1,2;0,-1,3).

way(1,X+DX,Y+DY,T,f(-1,N)) :- goalAt(X,Y,T), dirN(DX,DY,N), init(field(X+DX,Y+DY)), init(field(X-DX,Y-DY)), not at(_,X+DX,Y+DY,T), not at(_,X-DX,Y-DY,T).
way(N,X+DX,Y+DY,T,f(A,M)) :- way(N-1,X,Y,T,A), dirN(DX,DY,M), init(field(X+DX,Y+DY)), not at(_,X+DX,Y+DY,T).%%TODO keine stupiden wege grounden 12,132,..., A != f(_,.



