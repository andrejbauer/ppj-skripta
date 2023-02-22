/* Tolmač za preprost ukazni jezik v 100 vrsticah (s komentarji). */

:- use_module(library(clpfd)).

/* Sintaksa jezika:

   Celoštevilski izrazi:
   - celo število k pišemo "int(k)"
   - spremenljivko x pišemo "var(x)"
   - "e₁ + e₂" pišemo "plus(e₁, e₂)"
   - "e₁ * e₂" pišemo "times(e₁, e₂)"

   Boolovi izrazi:
   - "e₁ < e₂" pišemo "less(e1, e2)"
   - "b₁ ∨ b₂" pišemo "or(b1, b2)"
   - "b₁ ∧ b₂" pišemo "and(b1, b2)"
   - "¬ b" pišemo "not(b)"

   Ukazi:
   - "skip" pišemo "skip"
   - "x := e" pišemo "let(x, e)"
   - "c₁ ; c₂" pišemo "seq(c1, c2)"
   - "if b then c₁ else c₂ end" pišemo "if(b, c₁, c₂)"
   - "while b do c done" pišemo "while(b, c)"
*/

/* Okolje predstavimo s seznamom seznamov [[x₁,v₁], …, [xᵢ,vᵢ]] */

/* get(X, Env, V) velja, če ima spremenljivka X v okolju Env vrednost V. */
get(X, [[X,V] | _], V).
get(X, [_ | Env], V) :- get(X, Env, V).

/* put(X, V, Env1, Env2) velja, če dobimo Env2 iz Env1, ko X nastavimo na V */
put(X, V, [[X,_] | L], [[X,V] | L]).
put(X, V, [[Y,W] | L], [[Y,W] | M]) :- put(X, V, L, M).

/* eval(Env, E, V) velja, če v okolju Env izraz E evaluira v vrednost V */

/* Aritmetični izrazi */
eval(_, int(V), V).

eval(Env, var(X), V) :- get(X, Env, V).

eval(Env, plus(E1, E2), V) :-
    eval(Env, E1, V1),
    eval(Env, E2, V2),
    V #= V1 + V2.

eval(Env, times(E1, E2), V) :-
    eval(Env, E1, V1),
    eval(Env, E2, V2),
    V #= V1 * V2.

/* Boolovi izrazi */
eval(_, false, false).

eval(_, true, true).

eval(Env, less(E1, E2), true) :-
    eval(Env, E1, V1),
    eval(Env, E2, V2),
    V1 #< V2.

eval(Env, less(E1, E2), false) :-
    eval(Env, E1, V1),
    eval(Env, E2, V2),
    V1 #>= V2.

eval(Env, or(B1, _), true) :- eval(Env, B1, true).
eval(Env, or(B1, B2), V) :- eval(Env, B1, false), eval(Env, B2, V).

eval(Env, and(B1, _), false) :- eval(Env, B1, false).
eval(Env, and(B1, B2), V) :- eval(Env, B1, true), eval(Env, B2, V).

eval(Env, not(B), false) :- eval(Env, B, true).
eval(Env, not(B), true) :- eval(Env, B, false).

/* finish(C, Env1, Env2) velja, če ukaz C v okolju Env1 v enem koraku konča v
   okolju Env2 */
finish(skip, Env, Env).

finish(let(X, E), Env1, Env2) :-
    eval(Env1, E, V),
    put(X, V, Env1, Env2).

/* step(C1, Env1, C2, Env2) velja, če ukaz C1 v okolju Env1 v enem koraku
   spremeni okolje v Env2 in program se nadaljuje z ukazom C2 */

step(if(B, C1, _), Env, C1, Env) :- eval(Env, B, true).
step(if(B, _, C2), Env, C2, Env) :- eval(Env, B, false).

step(seq(C1, C2), Env1, C2, Env2) :- finish(C1, Env1, Env2).
step(seq(C1, C3), Env1, seq(C2, C3), Env2) :- step(C1, Env1, C2, Env2).

/* Upoštevamo enačbo:

   while b do c done    ≡     if b then (c; while b do c done) else skip end

*/
step(while(B, C), Env, if(B, seq(C, while(B, C)), skip), Env).


/* run(C, Env1, Env2) velja, če ukaz C v okolju Env1 po končno mnogo korakih
   konča v okolju Env2 */
run(C, Env1, Env2) :- finish(C, Env1, Env2).
run(C, Env1, Env3) :- step(C, Env1, C2, Env2), run(C2, Env2, Env3).

/* Primeri */

/* Minimum:

   if x < y then z := x else z := y end
*/
minimum(X, Y, Z) :-
  run(
    if(less(var(x), var(y)), let(z, var(x)), let(z, var(y))),
    [[x,X], [y,Y], [z,42]],
    Env),
  get(z, Env, Z).

/* S števcem i štej od 0 do N:

   i = 0 ;
   while (i < N) do
     i := i + 1
   done

   Opomba: spremenljivke j ne potrebujemo, v okolje jo postavimo za hec.
*/
count(N, Env) :-
  run(
    seq(let(i,int(0)),
        while(less(var(i), int(N)),
              let(i, plus(var(i), int(1)))
    )),
    [[i,42], [j,100]],
    Env).

/* Faktoriela N!:

   i := 1 ;
   p := 1 ;
   while (i < N + 1) do
     p := p * i ;
     i := i + 1
   done
 */

faktoriela(N, F) :-
  run(
    seq(let(i, int(1)),
    seq(let(p, int(1)),
        while(less(var(i), plus(int(N), int(1))),
              seq(let(p, times(var(p), var(i))),
                  let(i, plus(var(i), int(1))))
    ))),
    [[i,0],[p,0]],
    Env2
  ),
  get(p, Env2, F).

/* Celoštevilski kvadratni koren N, zaokrožen navzgor:

   i := 0
   while i * i < N do
     i := i + 1
   done
*/
sqrt(N, S) :-
  run(
    seq(let(i, int(0)),
        while(less(times(var(i), var(i)), int(N)),
              let(i, plus(var(i), int(1)))
        )
    ),
   [[i,42]],
   Env),
   get(i, Env, S).

/* Ali lahko računamo nazaj? */
