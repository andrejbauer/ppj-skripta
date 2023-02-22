type 'a stream = Cons of 'a * 'a stream

(* Tok iz samih enic. *)
let rec enice = Cons (1, enice)

(* Tole se zacikla *)
let enice' =
  let rec e () = Cons (1, e ()) in
  e ()
