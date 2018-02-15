%% http://www.janko.at/Spiele/Sokoban/GarciaAlberto.htm Level 1

init(field(2..5,1)).
init(field((1;2;5),2)).
init(field((1;3..6),3)).
init(field((1..6),4)).
init(field((1;2;5),5)).
init(field((2;4;5),6)).
init(field(2..4,7)).
init(field(1..3,8..10)).
init(field(1..2,11)).

init(at(1,2,5)). init(at(2,3,7)). init(at(3,3,8)).
init(target(3,3)). init(target(4,3)). init(target(4,4)).

init(at(0,6,4)).