forbidden(X,Y) :- init(field(X,Y)), not init(target(X,Y)),
	3 #sum {3 : not init(field(X+DX,Y+DY)),
		not init(field(X+DY,Y+DX)), dir(DX,DY);
		3 : not init(field(X+DX,Y+DY)),
		not init(field(X-DY,Y-DX)), dir(DX,DY);
		1,1 : forbidden(X+DX,Y+DY), dir(DX,DY);
		1,2 : forbidden(X+DX,Y+DY), dir(DX,DY),
		forbidden(X-DX,Y-DY);
		1,3 : not init(field(X+DX,Y+DY)), dir(DX,DY);
		1,4 : not init(field(X+DX,Y+DY)),
		not init(field(X-DX,Y-DY)), dir(DX,DY)}.
:- at(N,X,Y,T), forbidden(X,Y), N>0, T>0, not at(N,X,Y,T-1).
