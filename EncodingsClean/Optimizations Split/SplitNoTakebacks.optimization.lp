
:- move(DX,DY,T), move(-DX,-DY,T-1), atX(0,X,T), atY(0,Y,T), not atX(_,X-DX,T-1), not atY(_,Y-DY,T-1), time(T).
