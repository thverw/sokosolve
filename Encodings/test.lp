%time(0..horizon).

#const horizon=10.

%sym(a,f(-1,0), 1).
%sym(b,f(-1,1), 1).
%sym(c,f(-1,2), 1).
%sym(d,f(-1,3), 1).

%reductor(4,b(),0).
%yo(1) :- reductor(4,b(_),0), 4 > -1.
%reductor(N-1,G,T) :- b(G) = A, reductor(N,A,T), N > -1.
%move(1,0,N+T) :- b(G) = A, reductor(N,A,T), N > -1.
goodway(2,4,3,5,a(a)).
reductor(N,G,T) :- goodway(N,_,_,T,G).

%sym(a(X),f(f(-1,N),0), 2) :- sym(X,f(-1,N), 1), N != 1.
%sym(b(X),f(f(-1,N),1), 2) :- sym(X,f(-1,N), 1), N != 0.
%sym(c(X),f(f(-1,N),2), 2) :- sym(X,f(-1,N), 1), N != 3.
%sym(d(X),f(f(-1,N),3), 2) :- sym(X,f(-1,N), 1), N != 2.

%sym(a(Y),f(f(f(X,A),B),0),N+1) :- sym(Y,f(f(X,A),B),N), A != 1, B != 1, N<horizon.
%sym(b(Y),f(f(f(X,A),B),1),N+1) :- sym(Y,f(f(X,A),B),N), A != 0, B != 0, N<horizon.
%sym(c(Y),f(f(f(X,A),B),2),N+1) :- sym(Y,f(f(X,A),B),N), A != 3, B != 3, N<horizon.
%sym(d(Y),f(f(f(X,A),B),3),N+1) :- sym(Y,f(f(X,A),B),N), A != 2, B != 2, N<horizon.

%eleA(1;4).
%eleB(2;5).
%ele1(1;5).ele2(2;4).
%ele(1;2;4;5).

%sum(C,0,0,C) :- ele(C).
%sum(B*10+C,0,B,C) :- sum(B,0,0,B),eleA(B),eleA(C).
%sum(B*10+C,0,B,C) :- sum(B,0,0,B),eleB(B),eleB(C).
%sum(B*10+C,0,B,C) :- sum(B,0,0,B),ele1(B),ele1(C).
%sum(B*10+C,0,B,C) :- sum(B,0,0,B),ele2(B),ele2(C).
%sum(A*100+B*10+C,A,B,C) :- eleA(A),eleA(B),eleA(C).
%sum(A*100+B*10+C,A,B,C) :- eleB(A),eleB(B),eleB(C).
%sum(A*100+B*10+C,A,B,C) :- ele1(A),ele1(B),ele1(C).
%sum(A*100+B*10+C,A,B,C) :- ele2(A),ele2(B),ele2(C).
%sum(A*10+B,X,Y,B) :- sum(A,W,X,Y), ele1(X), ele1(Y), ele1(B), A<(10 ** horizon).
%sum(A*10+B,X,Y,B) :- sum(A,W,X,Y), ele2(X), ele2(Y), ele2(B), A<(10 ** horizon).
%sum(A*10+B,X,Y,B) :- sum(A,W,X,Y), eleA(X), eleA(Y), eleA(B), A<(10 ** horizon).
%sum(A*10+B,X,Y,B) :- sum(A,W,X,Y), eleB(X), eleB(Y), eleB(B), A<(10 ** horizon).



%aPool(1..2).
%dir(A,0;0,A;-A,0;0,-A) :- aPool(A).
%at(N,X,Y,0) :- init(at(N,X,Y)).

% constraints for preventing deadlock through box on wall
%:- 0 < X, X = #sum {1 : at(N,1,_,T), N>0 ; -1 : init(target(1,_))}, time(T).
%:- 0 < X, X = #sum {1 : at(N,dimX,_,T), N>0 ; -1 : init(target(dimX,_))}, time(T).
%:- 0 < X, X = #sum {1 : at(N,_,1,T), N>0 ; -1 : init(target(_,1))}, time(T).
%:- 0 < X, X = #sum {1 : at(N,_,dimY,T), N>0 ; -1 : init(target(_,dimY))}, time(T).

%%% CHANGE THE MIN NUMBER TO NOTHING MEANING THERE CAN BE ONE OR NONE
%%% ALSO ADD A CONSTRAINT TO PREVENT MULTIPLE MOVES IN THE SAME DIRECTION
%%% ALSO CHANGE THE AT IMPLICATIONS (OBVIOUSLY)
%%% ALSO ADD CONSTRAINT TO PREVENT MULTIPLE STEPS IN ONE T

% constraint for preventing moving over multiple boxes
%minus(0..-5).
%yo :- 2 {at(N,X+DX+A,Y+DY+B,T) : minus(A), minus(B), A <= DX, B <= DY, at(0,X,Y,T-1), move(DX,DY,T), N>0}.

% pick one direction to move in
%1 { move(DX,DY,T) : dir(DX,DY), |DX+DY| <= T } 1 :- time(T).
% move the player
%at(0,X+DX,Y+DY,T) :- at(0,X,Y,T-1), move(DX,DY,T), time(T).
% move box, the player collides with
%at(N+1,X+(DX/5),Y+(DY/5),T) :- minus(A), minus(B), |A| <= |DX|, |B| <= |DY|, at(N+1,X+A,Y+B,T-1), at(0,X-DX,Y-DY,T-1), at(0,X,Y,T), move(DX,DY,T), time(T).
% leave boxes that aren't touched at their place with t+1
%at(N,X,Y,T) :- at(N,X,Y,T-1), not at(0,X,Y,T), N>0, time(T).
% there can't be boxes, players, where there is no field
%:- move(DX,DY,T), move(-DX,-DY,T-1), at(0,X,Y,T), not at(_,X-DX,Y-DY,T-1), time(T).
%:- not init(field(X,Y)), at(_,X,Y,_).
% there can't be two boxes/players, at the same spot
%:- at(N,X,Y,T), at(M,X,Y,T), N>M, time(T).
%dirPos(1;-1).
%:- 3 #sum {1,1 : at(A,X+DX,Y,T), A>0 ; 1,1 : not init(field(X+DX,Y)) ;
%            1,2 : at(B,X,Y+DY,T), B>0 ; 1,2 : not init(field(X,Y+DY)) ;
%            1,3 : at(C,X+DX,Y+DY,T), C>0 ; 1,2 : not init(field(X+DX,Y+DY)) },
%            dirPos(DX), dirPos(DY), at(N,X,Y,T), N>0, time(T).




%uncovered(X,Y,T) :- init(target(X,Y)), not at(_,X,Y,T), time(T).
%goal(X,Y,T) :- init(target(X,Y)), not uncovered(X,Y,T), not at(0,X,Y,T), time(T).
%:- not goal(X,Y,horizon), init(target(X,Y)).


%uncovered(X,Y,T) :- init(target(X,Y)), not at(_,X,Y,T), time(T).
%goal(T) :- init(target(X,Y)), not uncovered(X,Y,T), not at(0,X,Y,T), time(T).%query(T).
%:- goal(T), uncovered(_,_,T), query(T).
%goal :- goal(T).
%:- time(horizon), not goal(horizon).
%:- not goal, query(T).

%#minimize{T : goal(T)}.

%#show yo/1.
%#show goal/1.

