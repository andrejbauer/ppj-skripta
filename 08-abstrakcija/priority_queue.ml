module type PRIORITY_QUEUE =
  sig
    type element
    val priority : element -> int
    type queue
    val empty : queue
    val put : element -> queue -> queue
    val get : queue -> element option * queue
  end

module MyFirstQueue : PRIORITY_QUEUE with type element = int * int =
  struct
    type element = int * int

    let priority (a, b) = a

    type queue = element list

    let empty = []

    let rec put x = function
      | [] -> [x]
      | y :: ys ->
         if priority x <= priority y then
           x :: y :: ys
         else
           y :: put x ys

    let get = function
      | [] -> (None, [])
      | x :: xs -> (Some x, xs)
  end

module type PRIORITY =
sig
  type t
  val priority : t -> int
end


(* Implementacija prioritetne vrste s seznami. To je funktor, ki
   sprejme tip elemetov in prioritetno funkcijo. *)
module ListQueue (M : PRIORITY) : PRIORITY_QUEUE with type element = M.t
  =
  struct
    type element = M.t

    let priority = M.priority

    type queue = element list

    let fortytwo = 42

    let empty = []

    let rec put x = function
      | [] -> [x]
      | y :: ys ->
         if priority x <= priority y then
           x :: y :: ys
         else
           y :: put x ys

    let get = function
      | [] -> (None, [])
      | x :: xs -> (Some x, xs)
  end

(* Naredimo prioritetno vrsto nizov, prioriteta je dolžina niza. *)
module A =
  ListQueue(
      struct
        type t = string
        let priority = String.length
      end)

(* Preizkus. *)
let example1 =
  A.get (A.put "kiwi" (A.put "jabolko" (A.put "banana" A.empty)))

(* Naredimo prioritetno vrsto nizov, prioriteta je dolžina niza. *)
module A' =
  ListQueue(
      struct
        type t = string
        let priority s = - String.length s
      end)

(* Preizkus. *)
let example1' =
  A'.get (A'.put "kiwi" (A'.put "jabolko" (A'.put "banana" A'.empty)))

(* Naredimo prioritetno vrsto parov števil. *)
module B =
  ListQueue(
      struct
        type t = int * int
        let priority (a,b) = a
      end
    )

module IntQueue =
  ListQueue(
    struct
      type t = int
      let priority k = k
    end
  )


(* Učinkovita implementacija z levičarskimi kopicami,
   glej https://en.wikipedia.org/wiki/Leftist_tree.
   Implementacija je abstraktna, ker uporabimo :,
   vendar dodamo določilo, da je tip element enak tipu t.
 *)
module LeftistHeapQueue (M : PRIORITY)
       : PRIORITY_QUEUE with type element = M.t =
  struct
    type element = M.t

    let priority = M.priority

    type queue = Leaf | Node of int * element * queue * queue

    let rank = function
      | Leaf -> 0
      | Node (r, _, _, _) -> r

    let node (x, a, b) =
      if rank a < rank b then
        Node (1 + rank a, x, b, a)
      else
        Node (1 + rank b, x, a, b)

    let rec meld a b =
      match (a, b) with
      | (_, Leaf) -> a
      | (Leaf, _) -> b
      | (Node (_, ka, la, ra), Node (_, kb, lb, rb)) ->
         if priority ka < priority kb then
           node (ka, la, meld ra b)
         else
           node (kb, lb, meld a rb)

    let singleton x = Node (1, x, Leaf, Leaf)

    let empty = Leaf

    let put x q = meld q (singleton x)

    let get = function
      | Leaf -> (None, Leaf)
      | Node (_, y, l, r) -> (Some y, meld l r)
  end


module D = LeftistHeapQueue(
               struct
                 type t = int * int
                 let priority (x, y) = x + y
               end)

let example2 =
  let rec loop q = function
    | 0 -> D.put (0, 0) q
    | k -> loop (D.put ((47 * k * k + 13) mod 1000, k) q) (k - 1)
  in
  loop D.empty 300000

let rec to_list q =
  match D.get q with
  | (None, _) -> []
  | (Some x, q) -> x :: to_list q
