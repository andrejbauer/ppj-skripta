type color = { r : float; g : float; b : float }

module type POINT =
sig
  val x : float
  val y : float
end

module type COLOR_POINT =
sig
  val x : float
  val y : float
  val c : color
end

module Pika : POINT =
struct
  let x = 1.2
  let y = 3.4
end

module BarvnaPika : COLOR_POINT =
struct
  let x = 1.2
  let y = 3.4
  let c = {r = 1.0; g = 0.5; b = 0.0}
end

module F (P : POINT) = struct
  let z = P.x +. P.y
end

module G (P : COLOR_POINT) = struct
  let c = P.c.r +. P.c.g
end

(* COLOR_POINT ≤ POINT *)

module A = F (Pika)
module B = F (BarvnaPika)
module C = G (BarvnaPika)
(* ne deluje: module C = G (Pika) *)
