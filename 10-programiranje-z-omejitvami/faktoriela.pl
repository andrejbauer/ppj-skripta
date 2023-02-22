% Funckija faktoriela z običajnim Prologom.

faktoriela(0, 1).
faktoriela(N, F) :-
    N > 0,
    M is N - 1,
    faktoriela(M, G),
    F is N * G.

% Faktoriela z omejitvami.

:- use_module(library(clpfd)).

fakulteta(0, 1).
fakulteta(N, F) :-
    N #> 0,
    M #= N - 1,
    F #= N * G,
    fakulteta(M, G).
