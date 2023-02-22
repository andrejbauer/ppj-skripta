(* Funkcije, ki uporabljajo učinke in zato niso običajne matematične funkcije. *)

(* stanje *)
let f =
  let k = ref 0 in
  fun n -> (k := !k + 1 ; n + !k)
;;

(* izjema *)
exception Abort

let g =
  fun n ->
    if n = 42 then raise Abort else n + 3
;;

(* output *)
let h =
  fun n ->
    print_endline "Hello, world!" ; n + 3
;;

(* input *)
let k =
  fun n ->
    let k = int_of_string (read_line ()) in
    n + k
;;

(* izračun, ki uporablja input *)
let c =
  let s = read_line () in
  match s with
  | "yes" -> 42
  | _ -> 30
