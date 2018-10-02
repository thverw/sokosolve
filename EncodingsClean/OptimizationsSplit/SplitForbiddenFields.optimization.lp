
forbidden(X,Y) :- init(field(X,Y)), not init(target(X,Y)),
3 #sum {3 : not init(field(X+DX,Y+DY)), not init(field(X+DY,Y+DX)), dir(DX,DY);
 3 : not init(field(X+DX,Y+DY)), not init(field(X-DY,Y-DX)), dir(DX,DY);
 1,1 : forbidden(X+DX,Y+DY), dir(DX,DY); 1,2 : forbidden(X+DX,Y+DY), dir(DX,DY), forbidden(X-DX,Y-DY);
 1,3 : not init(field(X+DX,Y+DY)), dir(DX,DY);
 1,4 : not init(field(X+DX,Y+DY)), not init(field(X-DX,Y-DY)), dir(DX,DY)}.
% forbidden fields
:- atX(N,X,T), atY(N,Y,T), { atX(N,X,T-1) ; atY(N,Y,T-1) } 1, forbidden(X,Y), N>0, T>0.
