(** Enakpsulacija kot "skrivanje komponent" na noviju modulov:
    uporabimo signature. *)

module Point :
sig
  type point

  val new_point : int -> int -> point
  val get_x : point -> int
  val get_y : point -> int
  val move : point -> int -> int -> point
end
=
struct
  type point = { x : int; y : int }

  let new_point x0 y0 = { x = x0; y = y0 }

  let get_x p = p.x

  let get_y p = p.y

  let move p dx dy = { x = p.x + dx ; y = p.y + dy }
end
