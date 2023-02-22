

data Stream a = Cons (a, Stream a) deriving Show

-- tok iz samih enic
enice :: Stream Integer
enice = Cons (1, enice)

-- prvih n elementov toka daj v seznam
to_list :: Integer -> Stream a -> [a]
to_list 0 _ = []
to_list n (Cons (x, s)) = x : (to_list (n-1) s)

-- tok števil od k naprej
from :: Integer -> Stream Integer
from k = Cons (k, from (k + 1))
