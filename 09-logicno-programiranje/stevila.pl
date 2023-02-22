nat(z).
nat(s(X)) :- nat(X).

plus(X, z, X).
plus(X, s(Y), s(Z)) :- plus(X, Y, Z).

times(_, z, z).
times(X, s(Y), Z) :-
    times(X, Y, W),
    plus(X, W, Z).
