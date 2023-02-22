type 'a stream = Cons of 'a * (unit -> 'a stream)

(* Neskončni tok enic *)
let enice =
  let rec e () = Cons (1, e) in
  e ()

(* Neskončni tok k, k+1, k+2, ... *)
let rec count k = Cons (k, (fun () -> count (k+1)))

(* Neskončni tok enic *)
let rec enice =
  let rec generate () = Cons (1, generate) in
  generate ()

(* Prvih n elementov toka pretvori v seznam *)
let rec to_list k s =
  match (k, s) with
  | (0, _) -> []
  | (n, Cons (x, s)) -> x :: to_list (n-1) (s ())

(* n-ti element toka *)
let rec elementAt k s =
  match (k, s) with
  | (0, Cons (x, _)) -> x
  | (n, Cons (_, s)) -> elementAt (n-1) (s ())

(* Potenčne vrste. Tok a₀, a₁, a₂, ... predstavlja potenčno vrsto

      a₀ + a₁ x + a₂ x² + a₃ x³ + ...
 *)

(* Izračunaj vrednost potenčne vrste s v točki x, uporabi prvih n členov *)
let rec eval n x s =
  let rec loop k xpow v (Cons (a, t)) =
    match k with
    | 0 -> v
    | k ->  loop (k-1) (xpow *. x) (v +. a *. xpow) (t ())
  in
  loop n 1.0 0.0 s

(* V pythonu:

   def eval (n, x, s):
     k = n
     xpow = 1.0
     v = 0
     while k > 0:
       a = s.getNext()
       v = v + a * xpow
       xpow = xpow * x
       k = k - 1
     return v
 *)

(* Potenčna vrsta za eksponentno funkcijo exp(x). Koeficienti so:

   1/0!, 1/1!, 1/2!, 1/3!, 1/4!, …
 *)
let exp =
  let rec exp k a = Cons (a, fun () -> exp (k+1) (a /. float k)) in
  exp 1 1.0

(* Potenčna vrsta za sinus *)
let sin =
  let rec sin k a = Cons (0.0, fun () -> Cons (a, fun () -> sin (k+2) (-. a /. float (k * (k+1)))))
  in sin 2 1.0

(* Odvod vrste

      a₀ + a₁ x + a₂ x² + a₃ x³ + a₄ x⁴ + ...

   je

      a₁ + 2 a₂ x¹ + 3 a₃ x² + 4 a₄ x³ + ...

 *)
let diff (Cons (_, s)) =
      let rec diff' k (Cons (a, s)) = Cons (float k *. a, fun () -> diff' (k+1) (s ()))
      in diff' 1 (s ())

let cos = diff sin
