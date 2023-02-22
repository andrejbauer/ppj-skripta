type color = {red : float; green : float; blue: float}

type izdelek =
  | Cevelj of color * int
  | Palica of int
  | Posoda of int

let z = Palica 7 ;;

match z with
| Cevelj (b, v) -> if v < 25 then 10 else 15
| Palica x -> 1 + 2 * x
| Posoda v -> 7
