module type QUEUE =
sig
  type queue
  val empty : queue
  val put : int -> queue -> queue
  val get : queue -> int option * queue
end

module Q : QUEUE =
struct
  type queue = int list

  let fortytwo = 42

  let empty = []

  let put x q = q @ [x]

  let get = function
    | [] -> (None, [])
    | x :: xs -> (Some x, xs)
end
