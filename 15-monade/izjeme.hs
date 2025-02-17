-- Primer računskega učinka "napaka"
-- V Haskellu je to že definirano kot Maybe

-- izračun bodisi javi napako bodisi vrne rezultat
data Computation a = Error | Result a
                     deriving Show

instance Functor Computation where
    fmap f Error = Error
    fmap f (Result v) = Result (f v)

instance Applicative Computation where
    pure = Result

    Error <*> _ = Error
    _ <*> Error = Error
    (Result f) <*> (Result v) = Result (f v)

instance Monad Computation where
    -- return = pure

    Error >>= f        =  Error
    (Result v) >>= f   =  f v

-- catch C H
-- C = izračun
-- H = če C javi napako, jo ujamemo in nadomestimo s H
--
-- try:
--   C
-- except Error:
--   H
catch :: Computation a -> Computation a -> Computation a
catch (Result v) _ = Result v
catch Error h      = h

-- trije načini, da se naredi isto

demo1 :: Computation Integer
demo1 = (Result 5) >>= (\v -> Result (v + 10))

demo2 :: Computation Integer
demo2 = return 5 >>= (\v -> return (v + 10))

demo3 :: Computation Integer
demo3 = do v <- return 5
           return (v + 10)

-- uporabimo error
demo4 :: Computation Integer
demo4 = do x <- return 5
           y <- return (x + 1)
           z <- if y < 7 then return 7 else Error
           w <- return (z + 3)
           return (x + y + z + w)
