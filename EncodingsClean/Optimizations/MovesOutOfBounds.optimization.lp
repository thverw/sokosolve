
:- move(1,0,T), at(0,dimX,_,T-1), time(T).
:- move(0,1,T), at(0,_,dimY,T-1), time(T).
:- move(-1,0,T), at(0,1,_,T-1), time(T).
:- move(0,-1,T), at(0,_,1,T-1), time(T).
