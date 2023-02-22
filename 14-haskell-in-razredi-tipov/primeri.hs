t :: Int
t = 42

s = 100 : [1,2,3]

f :: Int -> Int
f 0 = 1
f n = n * f (n - 1)

-- primer lokalne defincije
a :: Int
a = let x = 3 in x * x + 7

b :: Int
b = x * x + 7 where x = 3

c :: Int
c = f 10 where f 0 = 1
               f n = n * f (n - 1)

-- faktoriela na tri načine

fakt1 :: Int -> Int
fakt1 0 = 1
fakt1 n = n * fakt1 (n - 1)

fakt2 :: Int -> Int
fakt2 n = case n of
            0 -> 1
            n -> n * fakt2 (n - 1)

fakt3 :: Integer -> Integer
fakt3 n = case n of { 0 -> 1 ; n -> n * fakt3 (n - 1) }

--- tipi

-- okrajšava ali sinonim
type Height = Integer

h :: Height
h = 42

--- seznami na roko

-- OCaml:
--    type 'a list = Nil | Cons of 'a * 'a list

data List a = Nil | Cons (a, List a)

-- seznam 1, 4
mojSeznam = Cons (1, Cons (4, Nil))

-- Konstruktorji so lahko "curried"
data Seznam a =
   Prazen
 | Stik a (Seznam a)

-- seznam 1 4
tvojSeznam = Stik 1 (Stik 4 Prazen)

-- Chat Klemen K
-- ghc --make -Wall (stilako -Wall bo tudi preverjalo ali je ujemanje vzorcel "izpolnjeno") v -- ghci je to :set -Wall 
