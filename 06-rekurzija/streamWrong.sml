datatype 'a stream = Cons of 'a * 'a stream

(* Lokalne definicije v SML:

  let ...(lokalne definicije)...
  in
    ...uporabimo lokalne defincije...
  end
*)

(* Tok iz samih enic.

   Naivna definicija ni možna v SML:

   val enice = Cons (1, enice)
*)

(* Tole se zacikla *)
val enice =
  let fun e () = Cons (1, e ())
  in e ()
  end
