% Pitagorejska trojica je trojica celih števil (A, B, C),
% za katero velja A² + B² = C².

:- use_module(library(clpfd)).

pitagora(A, B, C) :-
    0 #< A,
    A #=< B,
    B #< C,
    A * A + B * B #= C * C.

% Pitagorejske trojice A, B, C, kjer so
% A, B in C manjši ali enaki N.
pitagora_do([A,B,C], N) :-
    pitagora(A,B,C),
    [A, B, C] ins 1..N,
    label([A,B,C]).
