-- Ideja: podatki imajo neko velikost
-- Funkcionalnost: tipi, katerih vrednosti imajo "velikost"

-- Razred, ki opisuje tiste tipe a, ki so opremljeni s funkcijo "size", ki slika v Int
class Sized a where
    size :: a -> Int

-- Funkcija, ki vrne velikost svojega argumenta, povečana za 3
f :: Sized a => a -> Int
f x = size x * 3

-- Booli so veliki 1 bit
instance Sized Bool where
    size True = 1
    size False = 1

-- Chari imajo velikost 8 bitov
instance Sized Char where
    size _ = 8

-- Inti so veliki 64 bitov
instance Sized Int where
    size x = 64

-- Velikost seznamov
instance Sized a => Sized [a] where
    size [] = 0
    size (x : xs) = size x + size xs

-- Velikost parov
instance (Sized a, Sized b) => Sized (a,b) where
    size (x, y) = size x + size y

-- Primeri

-- V Haskellu so nizi seznami znakov, se pravi [Char], zato Haskell iz zgornjih
-- instanc izpelje velikost niza kot 8 * dolžina niza.
demo1 = size "This string contains forty-two characters."

-- Če napišemo samo 14, dobimo tip Num a => a, če pa napišemo 14 :: Int,
-- Haskell prislimo, da ima 14 tip Int. (Če bi napisali 14 :: Float, bi
-- ga prisilil, da bi imel tip Float).
demo2 = size [(14 :: Int), 15]

demo3 = size ("foo", (False, 42 :: Int))
