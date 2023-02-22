(*

Primer:

- radi bi implementirali DNS lookup, t.j.,
  preslikava iz imen domen v IP številke.

- za preslikavo uporabimo slovar (dictionary)

- poznamo več implementacij slovarjev:
   * naivna, s seznami parov
   * z uravnoteženim iskalnim drevesom
   * z zgoščeno tabel (hash table)

V JAVI:

public class DNSLookupSilly {

  ... tu delamo slovar z ListDictionary

}

public class DNSLookup<D implements Dictionary> {

  ... tu delamo slovar z D-jem

}

public static main() {

    DNSLookup<HashDictionary> dns =
      new DNSLookup<HashDictionary>() ;


*)


module Cow =
struct
  type t = int * int
  let f (x, y) = x + y
  let g x = x * x
end

module type MOO2 =
sig
  type t = int * int
  val f : t -> int
end

module type MOO3 =
sig
  type t
  val f : t -> int
end
