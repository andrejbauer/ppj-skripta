class MyOrd a where
    leq :: a -> a -> Bool -- less or equal

    geq :: a -> a -> Bool -- greater or equal
    geq x y = leq y x

instance MyOrd Int where
    leq x y = (x <= y)
