time(0..horizon).

dir(1,0;0,1;-1,0;0,-1).
at(N,X,Y,0) :- init(at(N,X,Y)).


% pick one direction to move in
1 { move(DX,DY,T) : dir(DX,DY) } 1 :- time(T).
:- move(DX,_,T), DX>0, at(0,dimX,_,T-1), time(T).
:- move(_,DY,T), DY>0, at(0,_,dimY,T-1), time(T).
:- move(DX,_,T), DX<0, at(0,1,_,T-1), time(T).
:- move(_,DY,T), DY<0, at(0,_,1,T-1), time(T).
% move the player
at(0,X+DX,Y+DY,T) :- at(0,X,Y,T-1), move(DX,DY,T), time(T).
% move box, the player collides with %%% BOXMOVE IS NEW
at(N+1,X+DX,Y+DY,T), boxmove(T) :- at(N+1,X,Y,T-1), at(0,X-DX,Y-DY,T-1), at(0,X,Y,T), move(DX,DY,T), time(T).
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


%bigmove(XA,YA,XB,YB,TA,TB) :- at(0,XA,YA,TA), at(0,XB,YB,TB), TA<TB, XA<XB, YA<YB, 
%% totally destroys performance
%bigmove(XA,YA,XB,YB,TA,TB) :- at(0,XA,YA,TA), at(0,XB,YB,TB), TA + 2 < TB, { at(N,XC,YC,TC) : N>0, TA<TC, TC<TB, |XB-XA| > |XC-XA|, |YB-YA| > |YC-YA| } 0.

%% destroys performance
%bigmove(XA,YA,XB,YB,TA,TB) :- at(0,XA,YA,TA), at(0,XB,YB,TB), XA != XB, YA != YB, TA + 2 < TB, { at(N,X,Y,T) : N>0,  }.
% nice try but doesn't realize that the lexicographical ordering might remove all correct ways (because you don't see boxes not in the primary way)



%nomove(TA,TB) :- { boxmove(TA..TB) } 0.
%longestnomove(T,X) :- X #max { TB-TA : nomove(TA,TB) } X.
% new approach: create an aggregate that counts the amount of isomorphic ways from A to B and set it to max 1
%{at(0,XA,YA,TA), at(0,XB,YB,TB), } 1.


uncovered(X,Y,T) :- init(target(X,Y)), not at(_,X,Y,T), time(T).
goal(X,Y,T) :- init(target(X,Y)), not uncovered(X,Y,T), not at(0,X,Y,T), time(T).
:- not goal(X,Y,horizon), init(target(X,Y)).

%#show bigmove/6.
%#show longestnomove/2.
%uncovered(X,Y,T) :- init(target(X,Y)), not at(_,X,Y,T), time(T).
%goal(T) :- init(target(X,Y)), not uncovered(X,Y,T), not at(0,X,Y,T), time(T).%query(T).
%:- goal(T), uncovered(_,_,T), query(T).
%goal :- goal(T).
%:- time(horizon), not goal(horizon).
%:- not goal, query(T).

%#minimize{T : goal(T)}.

%#show move/3.
%#show goal/1.
%#show at/4.
