type 'a lazy = unit -> 'a

datatype 'a stream = Nil | Cons of 'a * 'a stream lazy

fun activate x = x ()

val pozdrav =
  Cons ("H",
           (fn () => Cons ("e",
                                   (fn () => Cons ("l",
                                      (fn () => Cons ("l",
                                               (fn () => Cons ("o", (fn () => Nil))))))))))

val theanswer =
   let fun f () = Cons (42, f)
   in f ()
   end

fun zip f Nil _ = Nil
  | zip f _ Nil = Nil
  | zip f (Cons (x, s)) (Cons (y, t)) = Cons (f x y, (fn () => zip f (activate s) (activate t)))

fun tail Nil = Nil
  | tail (Cons (_, s)) = activate s

val nat =
    let fun f k = Cons (k, fn () => f (k + 1))
    in f 0
    end

fun map f Nil = Nil
  | map f (Cons (x, s)) = Cons (f x, fn () => map f (activate s))

(* Tako kot map, le da imam akumulator a, ki ga f vsakič popravi na naslednjo vrednost *)
fun mapa f a Nil = Nil
  | mapa f a (Cons (x, s)) =
    let val (b, y) = f a x
    in Cons (y, fn () => mapa f b (activate s))
    end

val squares = map (fn n => n * n) nat

val fibonacci =
    let fun f a b = Cons (a, (fn () => f b (a + b)))
    in
        f 0 1
    end

(* Take at most [n] elements of the stream and return them in a list *)
fun take 0 s = []
  | take n Nil = []
  | take n (Cons (x, s')) = x :: (take (n-1) (activate s'))

fun powerseries n x t =
  let fun f _ End = 0.0
        | f (0, _) _ = 0.0
        | f (k, x_power) (Cons (a, s)) = a * x_power + f (k - 1, x_power * x) (activate s)
  in f (0, 1.0) t
  end
