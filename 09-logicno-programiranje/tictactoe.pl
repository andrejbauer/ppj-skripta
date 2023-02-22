win(P , [P,P,P,_,_,_,_,_,_]).
win(P , [_,_,_,P,P,P,_,_,_]).
win(P , [_,_,_,_,_,_,P,P,P]).

win(P , [P,_,_,P,_,_,P,_,_]).
win(P , [_,P,_,_,P,_,_,P,_]).
win(P , [_,_,P,_,_,P,_,_,P]).

win(P , [P,_,_,_,P,_,_,_,P]).
win(P , [_,_,P,_,P,_,P,_,_]).

opponent(x, o).
opponent(o, x).

move(P, [b,B,C,D,E,F,G,H,I], [P,B,C,D,E,F,G,H,I]).
move(P, [A,b,C,D,E,F,G,H,I], [A,P,C,D,E,F,G,H,I]).
move(P, [A,B,b,D,E,F,G,H,I], [A,B,P,D,E,F,G,H,I]).
move(P, [A,B,C,b,E,F,G,H,I], [A,B,C,P,E,F,G,H,I]).
move(P, [A,B,C,D,b,F,G,H,I], [A,B,C,D,P,F,G,H,I]).
move(P, [A,B,C,D,E,b,G,H,I], [A,B,C,D,E,P,G,H,I]).
move(P, [A,B,C,D,E,F,b,H,I], [A,B,C,D,E,F,P,H,I]).
move(P, [A,B,C,D,E,F,G,b,I], [A,B,C,D,E,F,G,P,I]).
move(P, [A,B,C,D,E,F,G,H,b], [A,B,C,D,E,F,G,H,P]).

allmoves(P, U, M) :-
    findall(X, move(P, U, X), M).

tie([A,B,C,D,E,F,G,H,I]) :-
  (x = A ; o = A),
  (x = B ; o = B),
  (x = C ; o = C),
  (x = D ; o = D),
  (x = E ; o = E),
  (x = F ; o = F),
  (x = G ; o = G),
  (x = H ; o = H),
  (x = I ; o = I),
  \+ win(_, [A,B,C,D,E,F,G,H,I]).

winning(P, U, U) :-
    win(P, U).

winning(P, U, V) :-
    move(P, U, V),
    opponent(P, O),
    losing(O, V).

losing(P, U) :-
    opponent(P, O),
    win(O, U).

losing(P, U) :-
    opponent(P, O),
    forall(move(P, U, V), winning(O, V, _)).
