zenska(ana).
zenska(mojca).
moski(miha).
moski(janez).

otrok(mojca, ana).
otrok(moja, miha).
otrok(miha, janez).

mati(X,Y) :-
    zenska(Y),
    otrok(X, Y).

babica(X,Z) :-
    otrok(X,Y),
    mati(Y,Z).
