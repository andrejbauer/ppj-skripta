datatype 'a stream = Cons of 'a * (unit -> 'a stream)

(* Neskončni tok enic *)
val enice =
  let fun e () = Cons (1, e)
  in e ()
  end

(* Neskončni tok k, k+1, k+2, ... *)
fun count k = Cons (k, (fn () => count (k+1)))

(* Neskončni tok enic *)
val enice =
  let fun generate () = Cons (1, generate)
  in generate ()
  end

(* Prvih n elementov toka pretvori v seznam *)
fun to_list 0 _ = []
  | to_list n (Cons (x, s)) = x :: (to_list (n-1) (s ()))

(* n-ti element toka *)
fun elementAt 0 (Cons (x, _)) = x
  | elementAt n (Cons (_, s)) = elementAt (n-1) (s ())

(* Potenčne vrste. Tok a₀, a₁, a₂, ... predstavlja potenčno vrsto

      a₀ + a₁ x + a₂ x² + a₃ x³ + ...
*)

(* Izračunaj vrednost potenčne vrste s v točki x, uporabi prvih n členov *)
fun eval n x s =
    let fun loop 0 _ v _ = v
          | loop k xpow v (Cons (a, t)) = loop (k-1) (xpow * x) (v + a * xpow) (t ())
    in loop n 1.0 0.0 s
    end

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
val exp =
    let fun exp k a = Cons (a, fn () => exp (k+1) (a / real k))
    in exp 1 1.0
    end

(* Potenčna vrsta za sinus *)
val sin =
    let fun sin k a = Cons (0.0, fn () => Cons (a, fn () => sin (k+2) (~a / real (k * (k+1)))))
    in sin 2 1.0
    end

(* Odvod vrste

      a₀ + a₁ x + a₂ x² + a₃ x³ + a₄ x⁴ + ...

   je

      a₁ + 2 a₂ x¹ + 3 a₃ x² + 4 a₄ x³ + ...

 *)
fun diff (Cons (_, s)) =
    let fun diff' k (Cons (a, s)) = Cons (real k * a, fn () => diff' (k+1) (s ()))
    in diff' 1 (s ())
    end

val cos = diff sin
