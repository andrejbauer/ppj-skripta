let f x =
  let y = 2 * x + 7 in
  y

let g a =
  let u = f (a + 3) in
  let z = f (2 * u) in
  z

let demo () =
  let r = g 5 in
  Format.printf "Danšnji rezultat je %d@." r

(** Continuation-passing style *)
let f' x k =
  let y = 2 * x + 7 in
  k y

let g' a k =
  f' (a + 3) (fun u -> f' (2 * u) (fun z -> k z))

let demo' () =
  g' 5 (fun r -> Format.printf "Danšnji rezultat je %d@." r)
