:- 1 #sum {1 : at(N,1,_,t), N>0 ; -1 : init(target(1,_))}.
:- 1 #sum {1 : at(N,dimX,_,t), N>0 ; -1 : init(target(dimX,_))}.
:- 1 #sum {1 : at(N,_,1,t), N>0 ; -1 : init(target(_,1))}.
:- 1 #sum {1 : at(N,_,dimY,t), N>0 ; -1 : init(target(_,dimY))}.
