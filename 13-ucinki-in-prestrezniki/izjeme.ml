exception TooBig

let rec f x =
  match x with
  | 0 -> 1
  | 1 -> 1
  | n ->
     if n > 30 then
       raise TooBig
     else
       f (n - 1) + f (n - 2)

let main =
  try
    let a = f 10 in
    Format.printf "a = %d@." a ;
    let b =
      (try
         f 50
       with
      | TooBig -> 42)
    in
    Format.printf "b = %d@." b ;
    let c = f 500 in
    Format.printf "c = %d@." c
  with
    | TooBig -> Format.printf "Prišlo je do tehničnih motenj. Hvala za pozornost.@."
