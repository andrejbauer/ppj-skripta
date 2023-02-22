datatype searchtree = Empty | Node of int * searchtree * searchtree

(*
           5
          / \
         3   8
          \   \
           4  10
             /  \
            9   20
*)
val primer =
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
fun velikost Empty = 0
  | velikost (Node (_, l, r)) = 1 + velikost l + velikost r

fun velikost' t =
    case t
     of Empty => 0
      | Node (_, l, r) => 1 + velikost' l + velikost' r

(** Seznam elementov v drevesu *)

fun to_list Empty = []
  | to_list (Node (x, l, r)) = to_list l @ [x] @ to_list r

(* Vrni true, če se x pojavi v drevesu, sicer false *)
fun search x Empty = false
  | search x (Node (y, l, r)) =
    case Int.compare (x, y)
     of EQUAL => true
     |  LESS => search x l
     |  GREATER => search x r

fun add x Empty = Node (x, Empty, Empty)
  | add x (t as Node (y, l, r)) =
    case Int.compare (x, y)
     of EQUAL => t
      | LESS => Node (y, add x l, r)
      | GREATER => Node (y, l, add x r)

fun remove x Empty = Empty
  | remove x (Node (y, l, r)) =
    let fun split Empty = raise Fail "impossible"
          | split (Node (y, l, Empty)) = (l, y)
          | split (Node (y, l, r)) =
                   let val (r', z) = split r
                   in (Node (y, l, r'), z)
                   end
    in
    case Int.compare (x, y)
     of LESS => Node (y, remove x l, r)
     |  GREATER => Node (y, l, remove x r)
     |  EQUAL =>
        case (l, r)
         of (Empty, Empty) => Empty
         |  (Empty, _) => r
         |  (_, Empty) => l
         |  (_, _) =>
            let val (l', y') = split l
            in Node (y', l', r)
            end
    end

(** Vstavimo števila oblike (17 n^2 + 3 n + 8) mod 103. *)
val d =
    let fun dodaj 100 = Empty
          | dodaj n = add ((17 * n * n + 3 * n + 8) mod 103) (dodaj (n + 1))
    in dodaj 0
    end
