let f n = failwith "kaboom"

let rec f n =
  if n = 0 then 1 else n * f (n - 1)































(* let telo g n = *)
(*   if n = 0 then 1 else n * g (n - 1) *)

(* let rec f' n = telo f' n *)
