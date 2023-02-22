demo = do x <- [1, 2, 3]
          y <- [100, 200]
          f <- [(\i j -> i * j), (\i j -> i + j)]
          return (f x y)
