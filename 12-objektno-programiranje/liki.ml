let kvadrat x0 y0 =
  object (self)
    val mutable a = 10
    val mutable x = x0
    val mutable y = y0

    method get_xy = (x,y)

    method stranica = a

    method obseg = 4 * a

    method premik dx dy =
      x <- x + dx ;
      y <- y + dy
  end

(* Premakni objekt ob1 na lokacijo objekta ob2. *)
let skupaj ob1 ob2 =
  let (x1, y1) = ob1#get_xy
  and (x2, y2) = ob2#get_xy
  in ob1 # premik (x2 - x1) (y2 - y1)

let k1 = kvadrat 10 2
let k2 = kvadrat 5 5
let k3 = skupaj k1 k2

(* Objekt lahko naredimo neposredno *)
let ob1 =
  object
    val mutable x = 10

    method get = x
    method put y = (x <- y)
  end

let ob2 =
  object
    val mutable x = 5.5

    method get = x
    method put y = (x <- y)
  end

let inc1 o = o#put (o#get + 1)

let inc2 o = o#put (o#get +. 1.0)
