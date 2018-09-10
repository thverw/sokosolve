time(0..horizon).

dir(1,0;0,1;-1,0;0,-1).
at(N,X,Y,0) :- init(at(N,X,Y)).

% pick one target box
%1 { goalAt(X+DX,Y+DY,X,Y,T) } 1 :- time(T), free(X+DX,Y+DY,T), dir(DX,DY), at(N,X,Y,T), N>0.

% stick to your goal

goalAt(X,Y,A,B,T) :- goalAt(X,Y,A,B,T-1), not at(0,A,B,T-1), time(T).

move(DX,DY,T+1) :- goalAt(X,Y,X+DX,Y+DY,T), at(0,X,Y,T), time(T+1), dir(DX,DY).

1 { goalAt(X,Y,X+DX,Y+DY,T) : init(field(X,Y)), dir(DX,DY) } 1 :- time(T).



% Version B ***********************************************************

%sym(a,f(-1,0), 1).
%sym(b,f(-1,1), 1).
%sym(c,f(-1,2), 1).
%sym(d,f(-1,3), 1).

sym(a(X),f(f(-1,N),0), 2) :- sym(X,f(-1,N), 1), N != 1.
sym(b(X),f(f(-1,N),1), 2) :- sym(X,f(-1,N), 1), N != 0.
sym(c(X),f(f(-1,N),2), 2) :- sym(X,f(-1,N), 1), N != 3.
sym(d(X),f(f(-1,N),3), 2) :- sym(X,f(-1,N), 1), N != 2.

sym(a(Y),f(f(f(X,A),B),0),N+1) :- sym(Y,f(f(X,A),B),N), A != 1, B != 1, N<horizon.
sym(b(Y),f(f(f(X,A),B),1),N+1) :- sym(Y,f(f(X,A),B),N), A != 0, B != 0, N<horizon.
sym(c(Y),f(f(f(X,A),B),2),N+1) :- sym(Y,f(f(X,A),B),N), A != 3, B != 3, N<horizon.
sym(d(Y),f(f(f(X,A),B),3),N+1) :- sym(Y,f(f(X,A),B),N), A != 2, B != 2, N<horizon.

notat(X,Y,T) :- init(field(X,Y)), not at(_,X,Y,T), time(T).
free(X,Y,T) :- init(field(X,Y)), notat(X,Y,T), time(T).
free(X,Y,T) :- init(field(X,Y)), at(0,X,Y,T), time(T).


way(1,X+1,Y,T,a) :- goalAt(X,Y,A,B,T), not goalAt(X,Y,A,B,T-1), free(X+1,Y,T), T < horizon.
way(1,X-1,Y,T,b) :- goalAt(X,Y,A,B,T), not goalAt(X,Y,A,B,T-1), free(X-1,Y,T), T < horizon.
way(1,X,Y+1,T,c) :- goalAt(X,Y,A,B,T), not goalAt(X,Y,A,B,T-1), free(X,Y+1,T), T < horizon.
way(1,X,Y-1,T,d) :- goalAt(X,Y,A,B,T), not goalAt(X,Y,A,B,T-1), free(X,Y-1,T), T < horizon.

way(2,X+1,Y,T,a(G)) :- way(1,X,Y,T,G), free(X+1,Y,T), T+1 < horizon.%, sym(a(G),_,2).
way(2,X-1,Y,T,b(G)) :- way(1,X,Y,T,G), free(X-1,Y,T), T+1 < horizon.%, sym(b(G),_,2).
way(2,X,Y+1,T,c(G)) :- way(1,X,Y,T,G), free(X,Y+1,T), T+1 < horizon.%, sym(c(G),_,2).
way(2,X,Y-1,T,d(G)) :- way(1,X,Y,T,G), free(X,Y-1,T), T+1 < horizon.%, sym(d(G),_,2).

way(N,X+1,Y,T,a(G)) :- way(N-1,X,Y,T,G), free(X+1,Y,T), T+N-1 < horizon, { way(K,X+1,Y,T,_) : K<N } = 0.
way(N,X-1,Y,T,b(G)) :- way(N-1,X,Y,T,G), free(X-1,Y,T), T+N-1 < horizon, { way(K,X-1,Y,T,_) : K<N } = 0.
way(N,X,Y+1,T,c(G)) :- way(N-1,X,Y,T,G), free(X,Y+1,T), T+N-1 < horizon, { way(K,X,Y+1,T,_) : K<N } = 0.
way(N,X,Y-1,T,d(G)) :- way(N-1,X,Y,T,G), free(X,Y-1,T), T+N-1 < horizon, { way(K,X,Y-1,T,_) : K<N } = 0.

goodway(N,X,Y,T,G) :- way(N,X,Y,T,G), { way(N,X,Y,T,H) : H < G } 0, at(0,X,Y,T).
%%, { way(M,X,Y,T,_) : M < N } 0
reductor(N,G,T) :- goodway(N,_,_,T,G).

reductor(N-1,G,T) :- reductor(N,a(G),T).
reductor(N-1,G,T) :- reductor(N,b(G),T).
reductor(N-1,G,T) :- reductor(N,c(G),T).
reductor(N-1,G,T) :- reductor(N,d(G),T).
move(-1,0,N+T) :- reductor(N,a(G),T).
move(1,0,N+T) :- reductor(N,b(G),T).
move(0,-1,N+T) :- reductor(N,c(G),T).
move(0,1,N+T) :- reductor(N,d(G),T).
move(-1,0,N+T) :- reductor(N,a,T).
move(1,0,N+T) :- reductor(N,b,T).
move(0,-1,N+T) :- reductor(N,c,T).
move(0,1,N+T) :- reductor(N,d,T).


%1 { move(DX,DY,T) : dir(DX,DY) } 1 :- time(T).

at(0,X+DX,Y+DY,T) :- at(0,X,Y,T-1), move(DX,DY,T), time(T).
% move box, the player collides with
at(N,X+DX,Y+DY,T) :- at(N,X,Y,T-1), at(0,X,Y,T), move(DX,DY,T),
			time(T), N>0.
% leave boxes that aren't touched at their place with t+1
at(N,X,Y,T) :- at(N,X,Y,T-1), not at(0,X,Y,T), N>0, time(T).


uncvrd(X,Y,T) :- init(target(X,Y)), not at(_,X,Y,T), time(T).
goal(X,Y,T) :- init(target(X,Y)), not uncvrd(X,Y,T),
			not at(0,X,Y,T), time(T).
:- not goal(X,Y,horizon), init(target(X,Y)).

%#show way/5.
#show goalAt/5.
%#show goodway/5.
#show reductor/3.
#show move/3.
%#show at/4.
