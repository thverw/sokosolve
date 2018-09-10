
dirPos(1;-1).
:- 4 #sum {1,1 : at(A,X+DX,Y,t), not init(target(X+DX,Y)), A>0 ;
		1,1 : not init(field(X+DX,Y)) ;
            1,2 : at(B,X,Y+DY,t), not init(target(X,Y+DY)), B>0 ;
		1,2 : not init(field(X,Y+DY)) ;
            1,3 : at(C,X+DX,Y+DY,t), not init(target(X+DX,Y+DY)), C>0 ;
		1,3 : not init(field(X+DX,Y+DY)) ;
            1,4 : at(D,X,Y,t), not init(target(X,Y)), D>0 },
            dirPos(DX), dirPos(DY), init(field(X,Y)).
