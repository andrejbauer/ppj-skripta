/* faktoriela(0) = 1
   faktoriela(N) = N * faktoriela(N-1)

   faktoriela(N) =
     M = N - 1;
     G = faktoriela(M);
     F = N * G;
     return F

*/

faktoriela(0, 1).
faktoriela(N, F) :-
    N > 0,
    M is N - 1,
    faktoriela(M, G),
    F is N * G.
