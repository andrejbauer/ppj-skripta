let rec loop v = function
  | 0 -> v
  | n -> loop (n + v) (n - 1)
;;

loop 100
