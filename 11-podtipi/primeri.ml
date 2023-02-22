(* Objekti v OCamlu *)

(* Objekt definiramo neposredno *)
let p =
  object
    method x = 10
    method y = 20
  end

let f o = o#x + 100

let demo1 =
   f (object method x = 42 end)

let demo2 =
   f p

let demo3 =
   let g o = o#x + o#y + o#z in
   g (object
        method x = 10
        method y = 20
        method z = 30
        method t = 0
      end)

(* Atributi so skriti *)

(* Naloga: točka v ravnini, ki jo lahko premikamo. *)

let t =
  object
    val mutable x = 10.0
    val mutable y = 7.5

    method get_x = x
    method get_y = y
    method premakni dx dy =
      x <- x +. dx ;
      y <- y +. dy
  end

let s =
  object (jaz)
    val mutable r = 2.0
    val mutable phi = 0.532 (* radiani *)

    method get_x = r *. cos phi
    method get_y = r *. sin phi

    method premakni dx dy =
      let x = jaz#get_x +. dx
      and y = jaz#get_y +. dy in
      r <- sqrt (x *. x +. y *. y) ;
      phi <- atan2 x y

  end

let demo4 = [t; s]

let u =
  object (jaz)
    val mutable r = 2.0
    val mutable phi = 0.532 (* radiani *)

    method get_x = r *. cos phi
    method get_y = r *. sin phi

    method premakni dx dy =
      let x = jaz#get_x +. dx
      and y = jaz#get_y +. dy in
      r <- sqrt (x *. x +. y *. y) ;
      phi <- atan2 x y

    method krneki = "wat"
  end

(** Sprejmemo objekt in seznam premikov, ter
    jih izvedemo na objektu. *)
let rec premiki o = function
  | [] -> ()
  | (dx,dy) :: lst ->
     o#premakni dx dy ;
     premiki o lst

(** Knjižnica za delo s točkami. *)

(** Funkcija, ki ustvari novo točko z danima začetnima koordinatama. *)
(** To ni nič drugega kot "na roke" sprogramiran konstruktor za točke. *)
let new_point x0 y0 =
  object
    val mutable x = x0
    val mutable y = y0

    method get_x = x
    method get_y = y
    method premakni dx dy =
      x <- x +. dx ;
      y <- y +. dy
  end

let demo6 =
   let a = new_point 3.4 7.6
   and b = new_point 1.0 2.0 in
   b#premakni 2.3 4.5 ;
   (a, b)

(** Ustvari novo točko na diagonali *)
let on_diagonal x0 =
  object
    val mutable x = x0
    val mutable y = x0

    method get_x = x
    method get_y = y
    method premakni dx dy =
      x <- x +. dx ;
      y <- y +. dy
  end

let demo7 = on_diagonal 3.3
