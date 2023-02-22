-- Potenčne vrste

data Series = Cons Float Series

to_list :: Integer -> Series -> [Float]
to_list 0 _ = []
to_list n (Cons a s) = a : to_list (n-1) s

instance Num Series where

    (Cons a s) + (Cons b t) = Cons (a + b) $ s + t

    (Cons a s) * (Cons b t) = mul [a] [b] s t
        where
          mul us vs (Cons u s) (Cons v t) = Cons (scalarProduct us vs) $ mul (u:us) (vs ++ [v]) s t

          scalarProduct [] [] = 0
          scalarProduct (u:us) (v:vs) = u * v + scalarProduct us vs

    abs (Cons a s) = Cons (abs a) (abs s)

    signum _ = undefined

    fromInteger k = Cons (fromInteger k) $ zeroes
                    where zeroes = Cons 0 zeroes

    negate (Cons a s) = Cons (negate a) $ negate s


derivative :: Series -> Series
derivative (Cons _ s) = derive 1 s
                        where derive k (Cons a t) = Cons (k * a) $ derive (k+1) t

eval :: Integer -> Float -> Series -> Float
eval n x s = eval' n 1 s
             where eval' 0 _ _ = 0
                   eval' n xn (Cons a s) = a * xn + eval' (n-1) (xn * x) s

expSeries :: Series
expSeries = exp' 1 1
      where exp' k a = Cons a $ exp' (k+1) (a / k)

sinSeries :: Series
sinSeries = sin' 2 1
            where sin' k a = Cons 0 $ Cons a $ sin' (k+2) (- a / k / (k + 1))

cosSeries :: Series
cosSeries = cos' 1 1
            where cos' k a = Cons a $ Cons 0 $ cos' (k+2) (- a / k / (k + 1))
