type comparison = Less | Equal | Greater

let cmp x y = Less (* kr neki *)

let main_good =
  match cmp x y with
    | Less -> "ena"
    | Equal -> "druga"
    | Greater -> "tretja"

let main_annoying =
  let cmp = compare x y in
  if cmp < 0 then
    "ena"
  else if cmp = 0 then
    "druga"
  else
    "tretja"

let main_also_annoying =
  if x < y then
    "ena"
  else if x = y then
    "druga"
  else
    "tretja"
