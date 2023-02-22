(* Podtipi & objekti *)

type color = Red | Green | Blue

(* Brez podtipov, navadni zapisi *)
type point = { x : float ; y : float }
type color_point = { x : float ; y : float ; c : color }

let p = {x = 3.4; y = 1.7} ;;
let foo = p.x +. p.y ;;

(* Če bi imeli podtipe zapisov, bi veljalo color_point <= point, vendar
   to ne velja, ker OCaml tega nima. *)

(* Pri objektih to gre. *)
type tocka = < get_x : float; get_y : float >
type barvna_tocka = < get_x : float; get_y : float ; get_color : color >

(* Velja, da je barvna_tocka <= tocka *)

(* Sintaksa: o#m dostopa do metode m v objektu o *)

(* OCaml določi tip objekta o tako, da lahko uporabljamo tudi podtipe. *)
let f o = o#get_x +. o#get_y

(* Če predpišemo tip o natančno, potem se podtipi ne bodo uporabljali. *)
let g (o : tocka) = o#get_x +. o#get_y

let (a : tocka) =
  object
    method get_x = 3.4
    method get_y = 1.7
  end

let (b : barvna_tocka) =
  object
    method get_x = 103.4
    method get_y = 101.7
    method get_color = Red
  end

let foo = f a

(* Tole deluje, če zamenjamo z g, pa ne deluje *)
let bar = f b
