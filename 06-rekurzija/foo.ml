let f k = 30000

let f n = if n = 0 then 1 else n * f (n - 1)


let init_driver x y = failwith "neka koda nekaj dela"




let i = 10

let init_driver x y = failwith "neka druga koda"



let main =
   if 3 < 7 then
      let i = i + 10 in
        init_driver


let moja_funkcija s =
  let s' = strip_spaces s in

    .... uporabljamo samo s'....
    .... ooops s .....


let moja_funkcija s =
  let s = strip_spaces s in
  let s = .... in
  let s = .... in

    .... uporabljamo samo s iz "let"....
    .... ooops s .....


public static int moja_funkcija(String s) {

  final String s = s.strip_spaces() ;

  ...
}


(* odvijemo faktorielo *)

let f n = if n = 0 then 1 else n * f (n - 1)

let f' n =
  if n = 0 then 1
  else if n = 1 then 1 * 1 else n * (n - 1) * f (n - 2))

let f'' n =
  if n = 0 then 1
  else if n = 1 then 1 * 1
  else if n = 2 then 2 * 1 * 1 else n * (n - 1) * (n - 2) * f (n - 3))
