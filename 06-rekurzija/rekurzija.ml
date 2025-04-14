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

let rec rek t = fun x -> t (rek t) x
(* rek je funkcija, ki sprejme t in vrne funkcijo.
   Funkcija, ki jo vrne, sprejme x in vrne t (rek t) x.
*)

let f = rek (fun g -> (fun n -> if n = 0 then 1 else n * g (n - 1)))

(** Funkcija dveh argumentov. *)
let rec  s (n, k) = (if k = 0 then n else s (n + k, k - 1))

let s' = rek (fun g -> fun (n, k) -> if k = 0 then n else g (n + k, k - 1))

let rec s'' n k = (if k = 0 then n else s'' (n + k) (k - 1))

let s''' = rek (fun g -> fun n -> fun k -> (if k = 0 then n else g (n + k) (k - 1)))

type stevilo = Nic | Naslednik of stevilo

(* Čuden tip *)
type d = Foo of (d -> bool)

let cow = Foo (fun v -> true)
let rabbit = Foo (fun v -> false)

(* Čudna vrednost *)
let x = Foo (fun (Foo f) -> f (Foo (fun _ -> false)))

type cow =
  | Cow of int * bool
  | Tail of cow

(* Cow = 0 *)
(* Tail = 1 *)

let demo = Cow (3, false)
(* p: [0, 3, 0] *)

let demo' = Tail demo
(* [1, p]

let f = function
  | Cow (a, b) -> (a, b)

type dog = Dog of (int * bool)

let g = function
  | Dog a -> a
