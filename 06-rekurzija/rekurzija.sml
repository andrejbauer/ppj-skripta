(* Oznaka za funkcijo:

   * matematika: x ↦ e
   * lambda račun: λ x . e
   * Python: lambda x: e
   * SML: fn x => e
   * OCaml: fun x => e
   * Racket: (lambda (x) e)
   * C: se ne piše
   * Java: se simulira z objekti (kao, ne zares)
*)

fun rek t = (fn x => t (rek t) x)
(* rek je funkcija, ki sprejme t in vrne funkcijo.
   Funkcija, ki jo vrne, sprejme x in vrne t (rek t) x.
*)

val f = rek (fn g => (fn n => if n = 0 then 1 else n * g (n - 1)))

(** Funkcija dveh argumentov. *)

fun s (n, k) = (if k = 0 then n else s (n + k, k - 1))

val s' = rek (fn g => fn (n, k) => if k = 0 then n else g (n + k, k - 1))

fun s'' n k = (if k = 0 then n else s'' (n + k) (k - 1))

val s''' = rek (fn g => fn n => fn k => (if k = 0 then n else g (n + k) (k - 1)))

datatype stevilo = Nic | Naslednik of stevilo

(* Čuden tip *)
datatype d = Foo of (d -> bool)

(* Čudna vrednost *)
val x = Foo (fn (Foo f) => f (Foo (fn _ => false))) ;
