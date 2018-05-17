time(0..horizon).

dir(1,0;0,1;-1,0;0,-1).
atX(N,X,0) :- init(at(N,X,Y)).
atY(N,Y,0) :- init(at(N,X,Y)).

forbidden(X,Y) :- init(field(X,Y)), not init(target(X,Y)),
3 #sum {3 : not init(field(X+DX,Y+DY)), not init(field(X+DY,Y+DX)), dir(DX,DY);
 3 : not init(field(X+DX,Y+DY)), not init(field(X-DY,Y-DX)), dir(DX,DY);
 1,1 : forbidden(X+DX,Y+DY), dir(DX,DY); 1,2 : forbidden(X+DX,Y+DY), dir(DX,DY), forbidden(X-DX,Y-DY);
 1,3 : not init(field(X+DX,Y+DY)), dir(DX,DY);
 1,4 : not init(field(X+DX,Y+DY)), not init(field(X-DX,Y-DY)), dir(DX,DY)}.

% pick one direction to move in
1 { move(DX,DY,T) : dir(DX,DY) } 1 :- time(T).
% move the player
atX(0,X+DX,T) :- atX(0,X,T-1), move(DX,_,T), time(T).
atY(0,Y+DY,T) :- atY(0,Y,T-1), move(_,DY,T), time(T).
% move box, the player collides with
atX(N+1,X+DX,T) :- atX(N+1,X,T-1), atX(0,X,T), atY(N+1,Y,T-1), atY(0,Y,T), move(DX,_,T), time(T).
atY(N+1,Y+DY,T) :- atX(N+1,X,T-1), atX(0,X,T), atY(N+1,Y,T-1), atY(0,Y,T), move(_,DY,T), time(T).
% leave boxes that aren't touched at their place with t+1
atX(N,X,T) :- atX(N,X,T-1), atY(N,Y,T-1), { atX(0,X,T) ; atY(0,Y,T) } 1, N>0, time(T).
atY(N,Y,T) :- atX(N,X,T-1), atY(N,Y,T-1), { atX(0,X,T) ; atY(0,Y,T) } 1, N>0, time(T).
% there can't be boxes, players, where there is no field
:- not init(field(X,Y)), atX(N,X,T), atY(N,Y,T).
% there can't be two boxes/players, at the same spot
:- atX(N,X,T), atX(M,X,T), atY(N,Y,T), atY(M,Y,T), N>M, time(T).
% forbidden fields
:- atX(N,X,T), atY(N,Y,T), forbidden(X,Y), N>0, T>0, { atX(N,X,T-1) ; atY(N,Y,T-1) } 1.
dirPos(1;-1).
:- 3 #sum {1,1 : atX(A,X+DX,T), atY(A,Y,T), A>0 ; 1,1 : not init(field(X+DX,Y)) ;
            1,2 : atX(B,X,T), atY(B,Y+DY,T), B>0 ; 1,2 : not init(field(X,Y+DY)) ;
            1,3 : atX(C,X+DX,T), atY(C,Y+DY,T), C>0 ; 1,2 : not init(field(X+DX,Y+DY)) },
            dirPos(DX), dirPos(DY), atX(N,X,T), atY(N,Y,T), N>0, time(T).


covered(X,Y,T) :- init(target(X,Y)), atX(N,X,T), atY(N,Y,T), time(T).
goal(X,Y,T) :- init(target(X,Y)), covered(X,Y,T), { atX(0,X,T) ; atY(0,Y,T) } 1, time(T).
:- not goal(X,Y,horizon), init(target(X,Y)).

#show move/3.
