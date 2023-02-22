type 'a list = Nil | Cons of 'a * 'a list

let rec elem = function
  | (x, Cons (y, _)) when x = y -> true
  | (x, Cons (_, l)) -> elem (x, l)
