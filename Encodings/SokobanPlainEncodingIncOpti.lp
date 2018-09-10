%%% OPTIMIERUNGEN:
%%% Split at into atX, atY
%atX(N,X,0) :- init(at(N,X,Y)).
%atY(N,Y,0) :- init(at(N,X,Y)).
%%% nicht vor und zurück laufen (wenn man keine Kiste schiebt)
%%% keine Kisten in Ecken schieben (vllt auch Wand/Kiste Ecken), die keine Targets sind
%%% HEURISTIKEN:
%%% x-Züge in eine Richtung
%%% Kisten von den Targets wegschieben
%%%


#include <incmode>.

#program base.
dir( 1,0 ; 0,1 ; -1,0 ; 0,-1 ).
at(N,X,Y,0) :- init(at(N,X,Y)).
%% Optimierung keine Kisten in Ecken schieben (es sei denn es sind Zielfelder):
%% Dazu gibt es ein neues Prädikat VerbotenesFeld:

%#program forbidden.
forbidden(X,Y) :- init(field(X,Y)), not init(target(X,Y)),
3 #sum {3 : not init(field(X+DX,Y+DY)), not init(field(X+DY,Y+DX)), dir(DX,DY);
 3 : not init(field(X+DX,Y+DY)), not init(field(X-DY,Y-DX)), dir(DX,DY);
 1,1 : forbidden(X+DX,Y+DY), dir(DX,DY); 1,2 : forbidden(X+DX,Y+DY), dir(DX,DY), forbidden(X-DX,Y-DY);
 1,3 : not init(field(X+DX,Y+DY)), dir(DX,DY);
 1,4 : not init(field(X+DX,Y+DY)), not init(field(X-DX,Y-DY)), dir(DX,DY)}.

%atX(N,X,0) :- init(at(N,X,Y)).
%atY(N,Y,0) :- init(at(N,X,Y)).



#program step(t).
box(N,X,Y,t) :- at(N,X,Y,t), N>0.
1 { move(DX,DY,t) : dir(DX,DY) } 1.
:- at(_,X,Y,_), not init(field(X,Y)).
:- at(N,X,Y,t), at(M,X,Y,t), N>M.
%% Optimierung keine Schritte zurücknehmen (wenn man keine Kiste geschoben hat)

%#program nostepsback.
:- move(DX,DY,t), move(-DX,-DY,t-1), at(0,X,Y,t), not at(_,X-DX,Y-DY,t-1).
at(0,X+DX,Y+DY,t) :- at(0,X,Y,t-1), move(DX,DY,t), init(field(X+DX,Y+DY)).
at(N,X+DX,Y+DY,t) :- at(N,X,Y,t-1), at(0,X-DX,Y-DY,t), at(0,X,Y,t), move(DX,DY,t), N>0, not forbidden(X+DX,Y+DY).

%% Optimierung keine Kisten in Ecken schieben (es sei denn es sind Zielfelder):
%% hier wird das Programm ein bisschen langsamer
%#program nocornerboxes.
:- at(N+1,X,Y,t), {init(field(X+DX,Y+DY)) : dir(DX,DY)} 1, not init(target(X,Y)).
%% als Alternative erkennt das Programm jetzt verbotene Felder (wo die Kiste das Zielfeld nicht mehr erreichen kann)
%% auch damit ist das Programm ein bisschen langsamer
%#program deadlockcheck.
:- forbidden(X,Y), box(N,X,Y,t).
at(N,X,Y,t) :- at(N,X,Y,t-1), not at(0,X,Y,t), N>0.


#program check(t).
#external query(t).
uncovered(X,Y,t) :- init(target(X,Y)), not at(_,X,Y,t), query(t).
goal(X,Y,t) :- init(target(X,Y)), not uncovered(X,Y,t), not at(0,X,Y,t), query(t).
:- not goal(X,Y,t), init(target(X,Y)), query(t).

#show at/4.
