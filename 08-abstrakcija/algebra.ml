(* Najprej definiramo signature. *)

module type GROUP =
sig
    type g
    val mul : g * g -> g
    val inv : g -> g
    val e : g
end

module type DIRECTED_GRAPH =
sig
    type v
    type e
    val src : e -> v
    val trg : e -> v
end

(* Signaturo implementiramo z modulom ali strukturo.
   Dana signatura ima lahko več implementacij. *)

module Z3 : GROUP =
struct

  type g = Zero | One | Two

  let e = Zero

  let plus = function
    | (Zero, y) -> y
    | (x, Zero) -> x
    | (One, One) -> Two
    | (One, Two) -> Zero
    | (Two, One) -> Zero
    | (Two, Two) -> One

  let mul = plus

  let inv = function
    | Zero -> Zero
    | One -> Two
    | Two -> One
end

module Z3' : GROUP =
struct

    type g = int

    let mul (x, y) = (x + y) mod 3
    let inv x = (3 - x) mod 3
    let e = 0
end

module K4 : DIRECTED_GRAPH =
struct

    type v = V0 | V1 | V2 | V3
    type e = E0 | E1 | E2 | E3 | E4 | E5

    let src = function
      | E0 -> V0
      | E1 -> V1
      | E2 -> V2
      | E3 -> V3
      | E4 -> V0
      | E5 -> V1

    let trg = function
      | E0 -> V1
      | E1 -> V2
      | E2 -> V3
      | E3 -> V0
      | E4 -> V2
      | E5 -> V3
end

module Cycle3 : DIRECTED_GRAPH =
struct
  type v = int (* uporabimo 0, 1, 2 *)
  type e = int (* uporabimo 0, 1, 2 *)
  let src e = e
  let trg e = (e + 1) mod 3

  (* Graf z vozlišči 0, 1, 2 in povezavami 0, 1, 2:
        src    trg
     0 : 0 --> 1
     1 : 1 --> 2
     2 : 2 --> 0
  *)
end

(* Takole pa naredimo modul, ki je parametriziran s
   strukturo. Kasneje bomo videli bolj uporabne primere. *)
module Cycle (S : sig val n : int end) : DIRECTED_GRAPH =
struct
  type v = int
  type e = int
  let src k = k
  let trg k = (k + 1) mod S.n
end

module C5 = Cycle(struct let n = 5 end)
module C15 = Cycle(struct let n = 15 end)
