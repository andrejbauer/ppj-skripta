type tree = Empty | Tree of int * tree * tree

(* size : tree -> int *)
let rec size t =
  match t with
  | Empty -> 0
  | Tree (k, t1, t2) -> 1 + size t1 + size t2

let rec size' =
  fun t ->
  match t with
  | Empty -> 0
  | Tree (k, t1, t2) -> 1 + size' t1 + size' t2

let rec size'' =
  function
  | Empty -> 0
  | Tree (k, t1, t2) -> 1 + size'' t1 + size'' t2

let rec size''' = function
  | Empty -> 0
  | Tree (k, t1, t2) -> 1 + size''' t1 + size''' t2
