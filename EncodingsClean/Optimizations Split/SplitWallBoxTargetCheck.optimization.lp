
:- 1 #sum {1 : atX(N,1,t), N>0 ; -1 : init(target(1,_))}.
:- 1 #sum {1 : atX(N,dimX,t), N>0 ; -1 : init(target(dimX,_))}.
:- 1 #sum {1 : atY(N,1,t), N>0 ; -1 : init(target(_,1))}.
:- 1 #sum {1 : atY(N,dimY,t), N>0 ; -1 : init(target(_,dimY))}.
