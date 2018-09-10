
:- move(1,0,T), atX(0,dimX,T-1), time(T).
:- move(0,1,T), atY(0,dimY,T-1), time(T).
:- move(-1,0,T), atX(0,1,T-1), time(T).
:- move(0,-1,T), atY(0,1,T-1), time(T).
