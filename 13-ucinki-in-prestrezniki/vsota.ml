let rec vsota1 = function
  | 0 -> 0
  | n -> n + vsota1 (n-1)

let vsota2 n =
  let v = ref 0 in
  for k = n downto 0 do
    v := !v + k
  done ;
  !v

let vsota3 n =
  let rec loop v = function
    | 0 -> v
    | n -> loop (n + v) (n - 1)
  in
  loop 0 n

exception Rezultat of int

let vsota4 n =
  let rec loop v = function
    | 0 -> raise (Rezultat v)
    | n -> loop (n + v) (n - 1)
  in
  try
    loop 0 n
  with
  | Rezultat v -> v
