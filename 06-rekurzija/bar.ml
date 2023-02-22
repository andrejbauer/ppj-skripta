let x = 8 in
(let y = 10 in
   (x + y)) ;;


let x = 8
and y = 10 in
  (x + y) ;;


(*---------------*)
let x = 10 ;;

let x = 5 in
  let y = x + 3 in
      y (* y = 8 *)

(*---------------*)
let x = 10 ;;

let x = f(5) in
and y = g(x + 3) in
    y (* y = 13 *))
