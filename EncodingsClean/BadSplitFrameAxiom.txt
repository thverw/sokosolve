atX(N,X,T) :- atX(N,X,T-1), not atX(0,X,T).
		N>0, time(T).
atX(N,X,T) :- atX(N,X,T-1), atY(N,Y,T), not atY(0,Y,T),
		N>0, time(T).
atX(N,X,T) :- atX(N,X,T-1), not move(_,0,T),
		N>0, time(T).
