/* Tolmač za preprost ukazni jezik z nedeterministično izbiro choose(e₁, e₂). */

/* Sintaksa jezika:

   Celoštevilski izrazi:
   - celo število k pišemo "int(k)"
   - spremenljivko x pišemo "var(x)"
   - "e₁ + e₂" pišemo "plus(e₁, e₂)"
   - "e₁ * e₂" pišemo "times(e₁, e₂)"
   - choose(e₁, e₂) nedeterministično izbere med e₁ in e₂

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
    V is V1 + V2.

eval(Env, times(E1, E2), V) :-
    eval(Env, E1, V1),
    eval(Env, E2, V2),
    V is V1 * V2.

eval(Env, choose(E1, _), V) :-
   eval(Env, E1, V).

eval(Env, choose(_, E2), V) :-
   eval(Env, E2, V).

/* Boolovi izrazi */
eval(Env, less(E1, E2), true) :-
    eval(Env, E1, V1),
    eval(Env, E2, V2),
    V1 < V2.

eval(Env, less(E1, E2), false) :-
    eval(Env, E1, V1),
    eval(Env, E2, V2),
    V1 >= V2.

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

/* i := choose(5, 10) ;
   j := choose(10, i) ;
   k := i + j
*/
primer(K) :-
    run(
        seq(let(i, choose(int(5), int(10))),
        seq(let(j, choose(int(10), var(i))),
            let(k, plus(var(i), var(j))))),
        [[i,42], [j,0], [k,105]],
        Env),
    get(k, Env, K).

/* Poženemo primer:

?- primer(K).
K = 15 ;
K = 10 ;
K = 20 ;
K = 20 ;
false.

*/

/* v := 0 ;
   i := 1 ;
   while i < N do
     v := v + choose(i, 0);
     i := i + 1
   done
*/
vsota(N, V) :-
  run(seq(let(v, int(0)),
      seq(let(i, int(1)),
          while(less(var(i), int(N)),
                seq(let(v, plus(var(v), choose(var(i), int(0)))),
                    let(i, plus(var(i), int(1)))
                   )
               )
         )
         ),
      [[v,42], [i,23]],
      Env),
  get(v, Env, V).
