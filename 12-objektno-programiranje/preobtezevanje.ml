(** Preobteževanje (overloading) na nivoju modulov ne obstaja, lahko pa imamo v različnih
   modulih komponente z enakimi imeni. *)

module Matrix =
struct
  let (++) x y = x + y - 1
end

module Vector =
struct
  let (++) x y = x * y - 1
end

let a =
  let open Vector in
  let u = 3 ++ 4 in
  let v = u ++ 5 in
  v

let a' = Vector.((3 ++ 4) ++ 5)

let b =
  let open Matrix in
  let u = 3 ++ 4 in
  let v = u ++ 5 in
  v

let b' = Matrix.((3 ++ 4) ++ 5)
