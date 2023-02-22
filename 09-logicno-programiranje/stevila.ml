(* Naravna števila z golimi rokami. *)

type nat =
  | Zero
  | Succ of nat

(* Primer *)
let three = Succ (Succ (Succ Zero))

(* Seštevanje *)
let rec plus = function
  | (x, Zero) -> x
  | (x, Succ y) -> Succ (plus (x, y))

(* Primer *)
let five = plus (three, Succ (Succ Zero))
