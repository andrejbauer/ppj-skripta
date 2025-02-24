-- Problem šahovskih dan, rešen z monado za nedeterminizem

-- Polja na šahovnici predstavim s koordinatami
type Polje = (Int, Int)

-- Dama je predstavljena kar s poljem, na katerem stoji
type Dama = Polje

-- ali se dve polji napadata?
napad :: Polje -> Polje -> Bool
napad (x1,y1) (x2,y2) =
    (x1 == x2) || (y1 == y2) || abs (x1 - x2) == abs (y1 - y2)

-- napadeno p ds -- ali dame ds napadajo polje p?
napadeno :: Polje -> [Dama] -> Bool
napadeno p = any (napad p)

-- preveri b prekine izvajanje (vrne nič možnosti) ali nadaljuje z eno samo možnostjo,
-- glede na to, ali pogoj b velja
preveri :: Bool -> [()]
preveri True = [()]
preveri False = []

-- Postavi n dam na šahovnico n x n, tako da se ne napadajo
dame :: Int -> [[Dama]]
dame n = postavi [] 1
  where postavi :: [Dama] -> Int -> [[Dama]]
        postavi dame k | k > n     = return dame
                       | otherwise = do j <- [1..n]
                                        preveri $ not (napadeno (k,j) dame)
                                        postavi ((k,j) : dame) (k+1)
