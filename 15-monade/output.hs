data Output a = Out (a, String)
              deriving Show

-- Out(5, "bla bla") ... izračun, ki vrne rezultat 5 in izpiše "bla bla"

instance Functor Output where
    fmap f (Out (v, out)) = Out (f v, out)

instance Applicative Output where
    pure v = Out (v, "")

    (Out (f, out1)) <*> (Out (v, out2)) = Out (f v, out1 ++ out2)

instance Monad Output where

    (Out (v, out1)) >>= f =   let Out(w, out2) = f v in Out (w, out1 ++ out2)

write :: String -> Output ()
write s = Out ((), s)

demo :: Output Integer
demo = do write "Hello"
          x <- return 10
          y <- return (x + 5)
          write ", world! "
          if y < 1000 then write "bye" else write "foo"
          return (x * y)

-- demo2 :: Output Integer
-- demo2 = (prin "Hello") >>= (\_ -> return 10 >>= (\x -> return ....
