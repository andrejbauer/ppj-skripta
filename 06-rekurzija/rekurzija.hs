fix :: (a -> a) -> a
fix t = t (fix t)

f :: Integer -> Integer
f = fix (\ self n -> if n == 0 then 1 else n * self (n - 1))

-- ell = 1 : 2 : ell
ell = fix (\self -> 1 : 2 : self)

-- kaj je to?
fibs = 0 : 1 : zipWith (+) fibs (drop 1 fibs)

-- fibs                          = 0 : 1 : 1 : 2 : 3 : 5
-- drop 1 fibs                   = 1 : 1 : 2 : 3 : 5 : ...
-- zipWith (+) fib (drop 1 fibs) = 1 : 2 : 3 : 5 : 8 : ...

-- strukturna rekurzija

fakt :: Integer -> Integer
fakt 0 = 1
fakt n = n * f (n - 1)
