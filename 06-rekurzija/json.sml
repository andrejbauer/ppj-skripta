datatype json
  = String of string
  | Number of int
  | Object of (string * json) list
  | Array of json array (* vgrajeni array *)
  | True
  | False
  | Null
