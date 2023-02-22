(* Razred, ki ima samo eno metodo get_x *)
class a (x0 : int) =
  object
    method get_x = (x0, "a")
  end

(* Razred b podeduje razred a *)
class b (x0 : int) =
  object
    inherit a x0 as super
    (* sami izberemo, kako se reče nadrazredu, namesto
       super bi lahko rekli tudi banana in potem povsod
       pisali banana *)

    (* za prekrivanje v Javi pišemo "@Override", v OCamlu "method!" (s klicajem) *)
    method! get_x =
      let (x, _) = super#get_x in
      (x, "b")
  end

class c (x0 : int) =
  object
    inherit a (x0 + 100) as super

    method! get_x =
      let (x, _) = super#get_x in
      (x, "c")
  end

(* Večkratno dedovanje *)
class d (x0 : int) =
  object (talele) (* V Kočevju rečejo "talele kislina" namesto "ta kuli" *)
    inherit b x0 as super1
    inherit c x0 as super2

    method get_x1 =
      let (x, _) = super1#get_x in
      (x, "d")

    method get_x2 =
      let (x, _) = super2#get_x in
      (x, "d")

    method get_x' =
      (* ali bomo dobili get_x iz super1 ali iz super2? *)
      let (x, s) = talele#get_x in
      (x, s ^ "d")
  end
