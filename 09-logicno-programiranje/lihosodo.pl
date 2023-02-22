sodo(zero).
sodo(succ(Y)) :- liho(Y).
liho(succ(X)) :- sodo(X).
