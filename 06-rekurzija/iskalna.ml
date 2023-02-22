type searchtree =
  | Empty
  | Node of int * searchtree * searchtree

(*
           5
          / \
         3   8
          \   \
           4  10
             /  \
            9   20
*)
let primer =
    Node (5,
          Node (3,
               Empty,
               Node (4, Empty, Empty)),
          Node (8,
               Empty,
               Node (10,
                     Node (9, Empty, Empty),
                     Node (20, Empty, Empty)
                    )
               )
         )

(** Velikost drevesa: *)
let rec velikost = function
  | Empty -> 0
  | Node (_, l, r) -> 1 + velikost l + velikost r

(* Zapis funkcije v OCaml:

   fun x -> ...

   fun x -> (fun y -> ...)
   fun x y -> ...

   Kombinacija fun in match:

   fun x ->
     match x with
     | p1 -> e1
     | p2 -> e2
     ..
     | pn -> en

   To krajše zapišemo:

   function
   | p1 -> e1
   | p2 -> e2
   ...
   | pn -> en
*)

let rec velikost' t =
  match t with
  | Empty -> 0
  | Node (_, l, r) -> 1 + velikost' l + velikost' r

(** Seznam elementov v drevesu *)
let rec to_list = function
  | Empty -> []
  | (Node (x, l, r)) -> to_list l @ [x] @ to_list r

let rec to_list' = function
  | Empty -> []
  | (Node (x, l, r)) -> to_list' l @ (x :: to_list' r)

(* OCaml ima ponesrečno implementirano funkcijo za primerjavo vrednosti.
   Definirajmo svojo funkcijo, ki vrne eno od treh vrednosti tipa [order]. *)
type order = Less | Equal | Greater

let cmp x y =
  match compare x y with
  | 0 -> Equal
  | r when r < 0 -> Less
  | _ -> Greater

(* Vrni true, če se x pojavi v drevesu, sicer false *)
let rec search x = function
  | Empty -> false
  | Node (y, l, r) ->
     (match cmp x y with
      | Equal -> true
      | Less -> search x l
      | Greater -> search x r)

(* Dodaj nov element v iskalno drevo *)
let rec add x = function
  | Empty -> Node (x, Empty, Empty)
  | Node (y, l, r) as t ->
    (match cmp x y with
     | Equal -> t
     | Less -> Node (y, add x l, r)
     | Greater -> Node (y, l, add x r))

(* Odstrani element iz iskalnega drevesa *)
let rec remove x = function
  | Empty -> Empty

  | Node (y, l, r) ->
     begin
       match cmp x y with
       | Less -> Node (y, remove x l, r)
       | Greater -> Node (y, l, remove x r)
       | Equal ->
         begin match (l, r) with
          | (Empty, Empty) -> Empty
          | (Empty, _) -> r
          | (_, Empty) -> l
          | (_, _) ->
             let rec split = function
               | Empty -> failwith "impossible"
               | Node (y, l, Empty) -> (l, y)
               | Node (y, l, r) ->
                  let (r', z) = split r in
                  (Node (y, l, r'), z)
             in
             let (l', y') = split l in
             Node (y', l', r)
         end
     end

(** Vstavimo števila oblike (17 n^2 + 3 n + 8) mod 103. *)
let d =
  let rec dodaj = function
    | 100 -> Empty
    | n -> add ((17 * n * n + 3 * n + 8) mod 103) (dodaj (n + 1))
  in dodaj 0
