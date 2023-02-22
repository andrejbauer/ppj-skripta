(* Objekt lahko definiramo neposredno tako, da podamo njegove
   atribute in metode. *)
let p =
  object
    (* atributi, v OCamlu se imenujejo "instance variable" *)
    val mutable x = 10
    val mutable y = 20

    (* metode *)
    method get_x = x

    method get_y = y

    method move dx dy =
      x <- x + dx ;
      y <- y + dy
  end

(* Če želimo klicati eno eno metodo iz druge, moramo podati tudi ime,
   s katerim se objekt sklicuje sam nase. *)
let q =
  object (this) (* namesto "this" bi lahko uporabili kako drugo ime *)
    val mutable x = 10
    val mutable y = 20

    method get_x = x

    method get_y = y

    method move dx dy =
      x <- this#get_x + dx ;  (* tu se sklicujemo na metodo get_x *)
      y <- y + dy
  end

(* Funkcija, ki sprejme začetni vrednosti atributov x in y ter
   vrne ustrezno inicializiran objekt. To je zelo podobno konstruktorjem
   v Javi, a je le funkcija. *)
let make_point x0 y0 =
  object
    val mutable x = x0
    val mutable y = y0

    method get_x = x

    method get_y = y

    method move dx dy =
      x <- x + dx ;
      y <- y + dy
  end

(* S tako funkcijo naredimo nov objekt. *)
let r = make_point 1 3

(* OCaml pozna tudi razrede, ki jih definiramo, kot da bi bili funkcije, ki
   vračajo objekte (vendar to niso). *)
class point x0 y0 =
  object
    val mutable x = x0
    val mutable y = y0

    method get_x = x

    method get_y = y

    method move dx dy =
      x <- x + dx ;
      y <- y + dy
  end

(* Z "new" naredimo nov objekt danega razreda. *)
let s = new point 1 3

(* Primerjajmo tipa objektov r in s:

   r : < get_x : int; get_y : int; move : int -> int -> unit >
   s : point

   Tip r je podoben tipu zapisa, saj našteje metode (ne pa atributov, ki so
   popolnoma skriti). Tip s je kar ime razreda, ki mu s pripada.

   Ker razred point definira natanko iste metode, kot tip r, sta r in s
   pravzaprav istega tipa, "point" je samo okrajšava.
*)

(* Poglejmo še, kako deluje dedovanje in podrazredi. *)

type color = { r : float; g : float ; b : float }

let pink = { r = 1.0; g = 0.75; b = 0.75 }

(* Razred color_point podeduje razred point. *)
class color_point x0 y0 (c0 : color) =
object
  inherit point x0 y0 (* dedovanje *)

  val color = c0

  method get_color = color
end
