dirPos(1;-1).
:- 4 #sum {1,1 : at(A,X+DX,Y,T), A>0 ;
	1,1 : not init(field(X+DX,Y)) ;
	1,2 : at(B,X,Y+DY,T), B>0 ;
	1,2 : not init(field(X,Y+DY)) ;
	1,3 : at(C,X+DX,Y+DY,T), C>0 ;
	1,3 : not init(field(X+DX,Y+DY)) ;
	1,4 : at(D,X,Y,T), not init(target(X,Y)), D>0 },
	dirPos(DX), dirPos(DY), init(field(X,Y)).
