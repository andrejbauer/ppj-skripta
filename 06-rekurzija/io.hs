-- Program, ki simulira operaciji Read in Write s podatkovnim tipom

data InputOutput a =
    Read (String -> InputOutput a) -- program prebere niz in nadaljuje delo
  | Write (String, InputOutput a)  -- program izpiše niz in nadaljuje delo
  | Return a                       -- program konča z danim rezultatom

-- Primer: program, ki izpiše "Hello, world!" in konča z rezultatom ()
hello_world :: InputOutput ()
hello_world = Write ("Hello, world!", Return ())

-- Primer: greeter n uporabnika n-krat vpraša po imenu in ga pozdravi, nato
--         vrne 42
greeter :: Integer -> InputOutput Integer
greeter 0 = Return 42
greeter n = Write ("Your name?", Read (\ str -> Write ("Hello, " ++ str, greeter (n-1))))

-- Lahko bi naredili tudi potencialno neskončni program?
annoyance :: InputOutput ()
annoyance = Write ("Should I stop? (Y/N)",
                    Read (\answer -> case answer of { "Y" -> Write ("Bye", Return ()) ; _   -> annoyance }))

-- Ker simuliramo I/O, moramo simulirati tudi operacijski sistem.
-- To naredimo s funkcijo, ki sprejme seznam vhodnih nizov,
-- niz, v katerem hranimo do sedaj izpisane podatke, in program.
-- Funkcija vrne rezultat programa in skupni niz, ki ga je program izpisal.
os :: [String] -> String -> InputOutput a -> (a, String)
os  _            output (Return v)       = (v, output)
os (str : input) output (Read p)         = os input output (p str)
os []            output (Read _)         = error "kernel panic: input not available"
os input         output (Write (str, p)) = os input (output ++ str) p

primer1 = os [] "" hello_world
-- Dobimo: ((),"Hello, world!")

primer2 = os ["Janezek", "Micka", "Mojca", "Darko"] "" (greeter 3)
-- Dobimo: (42,"Your name?Hello, JanezekYour name?Hello, MickaYour name?Hello, Mojca")

primer3 = os ["Janezek", "Micka", "Mojca", "Darko"] "" (greeter 5)
-- Dobimo izjemo: *** Exception: kernel panic: input not available

-- Neskončen seznam "N"
no = "N" : no
primer4 = os no "" annoyance
-- Dobimo: se zacikla
