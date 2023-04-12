-- neskončen podatkovni tok elementov tipa a
data Stream a = Cons a (Stream a)

-- Prvih n elementov toka pretvori v seznam
to_list :: Integer -> Stream a -> [a]
to_list 0 _ = []
to_list n (Cons x s) = x : (to_list (n-1) s)

-- rep podatkovnega toka
rest :: Stream a -> Stream a
rest (Cons _ s) = s

-- konstantni podatkovni tok, ki vedno vrača x
constant :: a -> Stream a
constant x = Cons x (constant x)

-- uporabi funkcijo na vseh elementih toka
streamMap :: (a -> b) -> Stream a -> Stream b
streamMap f (Cons x s) = Cons (f x) (streamMap f s)

-- spni dva tokova z dano funkcijo
streamZip :: (a -> b -> c) -> Stream a -> Stream b -> Stream c
streamZip f (Cons x s) (Cons y t) = Cons (f x y) (streamZip f s t)

-- filtriraj tok z dano Boolovo funkcijo
streamFilter :: (a -> Bool) -> Stream a -> Stream a
streamFilter p (Cons x s) | p x       = Cons x $ streamFilter p s
                          | otherwise = streamFilter p s

-- Tok naravnih števil
natural = Cons 0 $ streamMap (+ 1) natural

-- Tok števil od n naprej
naturalFrom :: Integer -> Stream Integer
naturalFrom n = Cons n $ naturalFrom (n + 1)

-- Kvadrati naravnih števil
squares = streamMap (\ n -> n * n) natural

-- Fibonaccijeva števila
fibonacci = Cons 0 $ Cons 1 $ streamZip (+) fibonacci (rest fibonacci)

-- Eratostenovo sito in praštevila
erastoten :: Stream Integer -> Stream Integer
erastoten (Cons k s) =
    Cons k $ erastoten (streamFilter (\ n -> n `mod` k /= 0) s)

primes :: Stream Integer
primes = erastoten $ naturalFrom 2
