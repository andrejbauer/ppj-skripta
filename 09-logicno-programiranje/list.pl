elem(X, cons(X, _)).
elem(X, cons(_, L)) :- elem(X, L).

join(nil, Y, Y).
join(cons(A, X), Y, cons(A, Z)) :- join(X, Y, Z).

:- use_module(library(lists)).
