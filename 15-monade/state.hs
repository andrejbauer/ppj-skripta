-- State s a je tip izračunov, ki imajo stanje tipa s in rezultat tipa a
-- naivna definicija:
--   type State s a = (s -> (s, a))

newtype State s a = State { run ::  s -> (s, a) }
-- State c .... izračun c, ki uporablja state,
--              c je funkcija, ki sprejme začetno stanje
--              in vrne (končno stanje, rezultat)
--
-- run c s0 ... poženi izračun c v začetnem stanju s0

instance Functor (State s) where
    fmap f c = State (\s -> let (s', x) = run c s in (s', f x))

instance Applicative (State a) where
    pure x = State (\s -> (s, x))

    cf <*> cx = State (\s0 -> let (s1, f)  = run cf s0
                                  (s2, x) = run cx s1
                              in (s2, f x))

instance Monad (State a) where
    -- return x = State (\s -> (s, x))

    c >>= f = State (\s0 -> let (s1, x) = run c s0
                            in run (f x) s1)

-- operacije na stanju

-- vrni trenutno stanje
get :: State s s
get = State (\s0 -> (s0, s0))

-- nastavi trenutno stanje
set :: s -> State s ()
set s = State (\_ -> (s, ()))

demo :: State Int String
demo = do x <- get
          set (x + 30)
          y <- get
          set (x + y)
          z <- get
          return (if z < 100 then "foo" else "bar")

-- run demo 15
