% Permutacije števil 1..N s pomočjo omejitev.

:- use_module(library(clpfd)).

permutacija(N,P) :-
    length(P, N),
    P ins 1..N,
    all_distinct(P).

% Primer uporabe: ?- permutacija(6,P), label(P).
