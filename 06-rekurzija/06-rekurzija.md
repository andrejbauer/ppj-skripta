# Rekurzija in rekurzivni tipi

Rekurzija je osnovni koncept v logiki, matematiki in računalništvu. V tej lekciji bomo spoznali
vlogo rekurzije v programiranju in programskih jezikih.

## Rekurzija in negibne točke

Pravimo, da je funkcija *rekurzivna*, kadar kliče sama sebe. Kot primer vzemimo funkcijo `f`,
ki računa faktorielo. V Javi bi jo zapisali takole:

```java
public static int f(int n) {
    if (n == 0) {
        return 1 ;
    } else {
        return n * f(n - 1)
    }
}
```

Ekvivalentna definicija v Pythonu:

```python
def f(n):
  if n == 0:
      return 1
  else:
      return n * f(n -1)
```

Ekvivalentna definicija v OCamlu:

```ocaml
let rec f n =
  if n = 0 then 1 else n * f (n - 1)
```

Ekvivalenta definicija v Haskellu:

```haskell
f :: Integer -> Integer
f n = if n == 0 then 1 else n * f (n - 1)
```

Obravnavajmo verzijo v Haskellu. Funkcijo prepišemo takole:

```haskell
f :: Integer -> Integer
f = \n -> if n == 0 then 1 else n * f (n - 1)
```

Sedaj definicijo razstavimo na dva dela: na *telo* rekurzije, ki samo po sebi ni rekurzivno, in na
*rekurzivni sklic* funkcije `f` same nase:

```haskell
telo :: (Integer -> Integer) -> (Integer -> Integer)
telo g =  \n -> if n == 0 then 1 else n * g  (n - 1)

f :: Integer -> Integer
f = telo f
```

Rekurzivno funkcijo smo zapisali kot negibno točko funkcije `telo`.

:::{admonition} Definicija
**Negibna točka** funkcije $h : X \to X$ je tak $x \in X$, da velja $x = h(x)$.
:::

V našem primeru je $h$ funkcija `telo`, $X$ je tip `Integer -> Integer` in $x$ je `f`.
Negibne točke so pomembne tudi na drugih področjih matematike in o njih matematiki veliko vedo.

:::{admonition} Primer

V numeričnih metodah enačbo oblike $x = h (x)$ poiščemo z zaporedjem približkov

$$
x_0,  h(x_0),  h(h(x_0)),  h(h(h(x_0))), \ldots
$$

Če imamo srečo (kar pomeni, da je absolutna vrednost odvoda $h$ v okolici negibne točke manjša od $1$ in je $x_0$ v taki okolici), zaporedje konvergira k negibni točki.
Na primer, enačbo $x^2 = 1/2$ prepišemo v obliko $x = 1/2 - x^2 + x$, se pravi $x = h(x)$, kjer je $h(x) = 1/2 - x^2 + x$.
Če vzamemo $x_0 = 1$, dobimo zaporedje

$$
1.0, 0.5, 0.75, 0.6875, 0.714844, 0.703842, 0.708448, 0.706549, 0.707337, 0.707011, 0.707146,
$$

ki konvergira k rešitvi enačbe $1/\sqrt{2} = 0.70710678118654752440$.

:::

Ali je tudi rekurzivna funkcija dveh argumentov negibna točka, na primer funkcija, ki računa binomske koeficiente?

```haskell
binom :: (Integer, Integer) -> Integer
binom (n, k) = if k == 0 || k == n then 1 else binom (n - 1, k - 1) + binom (n - 1, k)
```

Seveda, saj lahko `binom` še vedno razstavimo na telo funkcije in sklic samega nase:

```haskell
telo :: ((Integer, Integer) -> Integer) -> ((Integer, Integer) -> Integer)
telo self = \(n, k) -> if k == 0 || k == n then 1 else self (n - 1, k - 1) + self (n - 1, k)

binom :: (Integer, Integer) -> Integer
binom = telo binom
```

Kaj pa definicija rekurzivnih funkcij `f` in `g`, ki kličeta druga drugo?

Na primer, obravnavajmo funkcijo `f`, ki kliče `f` in `g`, ter funkcijo `g`, ki kliče `f`:

```haskell
f x = if x == 0 then 1 + f (x - 1) else 2 + g (x - 1)
g y = if y == 0 then 1 else 3 * f (y - 1)
```

Če ju združimo v urejeni par `(f, g)` in ju zapišemo z λ-računom, dobimo

```none
(f, g) = ((λ x . if x == 0 then 1 + f (x - 1) else 2 + g (x - 1)),
          (λ y . if y == 0 then 1 else 3 * f (y - 1)))
```
To je *rekurzivna definicija urejenega para (funkcij)*, kar prepišemo v

```none
(f, g) = t (f, g)
```

kjer je

```none
t = λ (f', g') . ((λ x . if x = 0 then 1 + f' (x - 1) else 2 + g' (x - 1)),
                 (λ y . if y = 0 then 1 else 3 * f' (y - 1)))
```

Torej tudi za hkratne rekurzivne definicije velja, da so to negibne točke.

## Operator `fix`

Recept za rekurzivno funkcijo je vedno isti:

1. Zapišemo telo `t` funkcije.
2. Definiramo negibno točko `f = t f`.

Pri tem je samo drugi korak rekurziven in vedno enak. Zapišemo ga lahko kot funkcijo `fix`, ki izračuna negibno točko dane funkcije:

```haskell
fix :: (a -> a) -> a
fix t = t (fix t)
```

V Haskellu tip `(a -> a) -> a` pomeni »funkcija, ki sprejme funkcjo tipa `a -> a` in vrne vrednost tipa `a`. Pri tem je tip `a` poljuben, pravimo, da je *parameter*.

Vso rekurzijo smo "spravili" v `fix`. Od tu naprej bi lahko rekurzivne funkcije definirali s pomočjo `fix`:

```haskell
f :: Integer -> Integer
f = fix (\ self n -> if n == 0 then 1 else n * self (n - 1))
```

:::{admonition} Vaja

Katero vrednost zavzame tip `a` iz definicije `fix` v zgornji definiciji `f`?
:::

Poglejmo postopek še enkrat, tokrat zapisan z λ-računom:

1. Prvotna definicija `f` se glasi:     `f n = if n = 0 then 1 else n * f (n - 1)`
2. Zapišemo s pomočjo λ-abstrakcije:  `f = λ n . if n = 0 then 1 else n * f (n - 1)`
3. Ločimo rekurzijo in telo funkcije: `f = t f` kjer je `t = (λ g n . if n = 0 then 1 else n * g (n - 1))`
4. S pomočjo `fix` definiramo `f`:        `f = fix t`


## Iteracija je poseben primer rekurzije

V ukaznem programiranju poznamo zanke, na primer zanko `while`:

```none
while b do c done
```

 Tudi ta je negibna točka! Res, taka zanka je ekvivalentna svojemu »odvitju«

```none
if b then (c ; while b do c done) else skip
```

Če pišemo `W` za našo zanko, dobimo:

```none
W ≡ (if b then (c ; W) else skip)
```

Torej je `W`  negibna točka funkcije

```none
t = (λ V . if b then (c ; V) else skip)
```

saj velja

```none
(while b do c done) = t (while b do c done)
```

:::{note}

Zanko `while` lahko na zgornji način »odvijamo v nedogled«:

Odvitje 0:

```none
while b do c done
```

Odvitje 1:

```none
if b
then
  (c ; while b do c done)
else skip
```

Odvitje 2:

```none
if b
then
  (c ;
   if b
   then
     (c ; while b do c done)
   else skip
  )
else skip
```

Faza 3:

```none
if b
then
  (c ;
   if b
   then
     (c ;
      if b
      then
        (c ; while b do c done)
      else skip
     )
   else skip
  )
else skip
```

In tako naprej. Če bi lahko imeli neskončno programsko kodo, ne bi potrebovali zank!
:::

## Rekurzivni seznami

Rekurzivno lahko definiramo tudi razne druge strukture, ne samo funkcij. Na primer, neskončni seznam

```haskell
ℓ = [1, 2, 1, 2, 1, 2, ...]
```

lahko v Haskellu definiramo rekurzivno:

```haskell
ℓ = 1 : 2 : ℓ
```

:::{admonition} Primer

Še bolj zanimiv primer rekurzivno definiranega seznama:

```haskell
fibs = 0 : 1 : zipWith (+) fibs (drop 1 fibs)
```

Ugotovite, kaj počneta `zipWith` in `drop` in nato razložite, kakšen seznam je to.
:::


## Rekurzivni tipi

V tem razdelku bomo spet delali z OCamlom, kasneje pa v Haskellu. Do sedaj smo spoznali podatkovne tipe:

* produkt `a * b` in zapisi
* vsota `a + b`
* eksponent `a → b`

S temi konstrukcijami ne moremo dobro predstaviti bolj naprednih podatkovnih tipov, kot so
seznami in drevesa. Poglejmo na primer, kako se tvori sezname celih števil:

* prazen seznam: `[]` je seznam
* sestavljen seznam: če je `x` celo število in `ℓ` seznam, je tudi `x :: ℓ` seznam

Zapis `[1; 2; 3]` je okrajšava za `1 :: (2 :: (3 :: []))`.

Seznami so **rekurzivni podatkovni tip**, saj gradimo sezname iz seznamov. Brez uporabe
posebnih oznak `[]` in `::` bi zgornjo definicijo zapisali takole (oznaki `Nil` in `Cons` izhajata
iz programskega jezika LISP, kjer pišemo `nil` in `(cons x ℓ)`):

* prazen seznam: `Nil` je seznam
* sestavljen seznam: če je `x` celo število in `ℓ` seznam, je tudi `Cons (x, ℓ)` seznam

Seznam `[1; 2; 3]` je okrajšava za `Cons (1, Cons (2, Cons (3, Nil)))`.

V OCamlu se tako definicijo zapiše takole:

```ocaml
type seznam =
  | Nil
  | Cons of int * seznam
```

Spet imamo opravka z rekurzijo. Tipi, ki se sklicujejo sami nase v svoji definiciji, se imenujejo **rekurzivni tipi**.

In spet vidimo, da je rekurzija negibna točka. Podatkovni tipi `seznam` je negibna točka za preslikavo `T`, ki slika tipe v tipe:

```none
seznam = T (seznam)
```

kjer je `T` definiran kot

```none
T a = (Nil | Cons of int * a)
```

Z besedami: `T` je funkcija, ki sprejme poljuben tip `a` in vrne vsoto tipov
`Nil | Cons of int * a`.

### Induktivni tipi

Izhajamo iz definicije seznama:

```ocaml
type seznam = Nil | Cons of int * seznam
```

Vprašajmo se: ali ta definicija zajema neskončne sezname? Na primer:

```ocaml
Cons (1, Cons (2, Cons (3, Cons (4, Cons (5, ...)))))
```

Ali se mora to kdaj zaključiti z `Nil`? Možna sta dva odgovora. Če zahtevamo, da morajo
biti elementi rekurzivnega tipa končni, govorimo o *induktivnih* tipih. Če pa dovolimo
neskončne elemente, govorimo o *koinduktivnih* tipih.

Poglejmo najprej **induktivne podatkovne tipe**. To so rekurzivni tipi, v katerih
vrednosti sestavljamo začenši z osnovnimi s pomočjo konstruktorjev in neskončne vrednosti
niso dovoljene. Primeri:

1. naravna števila
2. končni seznami
3. končna drevesa
4. abstraktna sintaksa jezika:
   * programski jeziki
   * jeziki za označevanje podatkov
5. hierarhija elementov v uporabniškem vmesniku

#### Primer: naravna števila

Definicija naravnega števila:

* `0` je naravno število
* če je `n` naravno število, je tudi `n⁺` naravno število (ki mu rečemo »naslednik `n`«)

Definicija podatkovnega tipa:

```ocaml
type stevilo = Nic | Naslednik of stevilo
```

Ta definicija ni učinkovita, ker predstavi naravna števila z naslednikom, torej v »eniškem« sistemu.
Naravna števila bi lahko definirali tudi takole:

* `0` je naravno število
* če je `n` naravno število, je tudi `Shl0 n` naravno število
* če je `n` naravno število, je tudi `Shl1 n` naravno število

Oznaka `Shl` je okrajšava za »shift left«. S `Shl0 n` predstavimo število `2 · n + 0` in s `Shl1 n` število `2 · n + 1`. Na primer

```ocaml
Shl0 (Shl1 (Shl0 (Shl1 0)))
```

je število `10`. Kot podatkovni tip:

```ocaml
type stevilo = Zero | Shl0 of stevilo | Shl1 of stevilo
```

Vendar to še vedno ni optimalna rešitev, ker lahko število nič predstavimo na neskončno načinov:

```none
0 = Shl0 0 = Shl0 (Shl0 0) = Shl0 (Shl0 (Shl0 0)) = ⋯
```

:::{admonition} Vaja

Poiščite predstavitev dvojiških števil z induktivnimi tipi (lahko jih je več), da bo
imelo vsako nenegativno celo število natanko enega predstavnika.
:::

:::{admonition} Primer

[Standard za predstavitev podatkov JSON](http://json.org) se kot podatkovni tip glasi takole:

```ocaml
type json =
  | String of string
  | Number of int
  | Object of (string * json) list
  | Array of json array (* Ocaml ima vgrajen array *)
  | True
  | False
  | Null
```

:::

### Splošni rekurzivni tipi

Rekurzivni tipi so lahko zelo nenavadni:

```ocaml
type d = Foo of (d -> bool)
```

Vrednost tipa `d` je oblike `Foo f`, kjer je `f` funkcija iz `d` v `bool`. Ali znate zapisati kako tako vrednost?

### Strukturna rekurzija

Ker so induktivni podatkovni tipi definirani rekurzivno, jih običajno obdelujemo z
rekurzivnimi funkcijami. Kot primer si oglejmo, kako bi implementirali iskalna drevesa.

Obravnavajmo preprosta **iskalna drevesa**, v katerih hranimo cela števila. Iskalno drevo je

* bodisi **prazno**
* bodisi **sestavljeno** iz korena, ki je označen s številom `x`, ter dveh poddreves `l` in
  `r` pri čemer velja:
  * vsa števila v vozliščih `l` so manjša od `x`,
  * vsa števila v vozliščih `r` so večja od `x`

Primer:

```none
       5
      / \
     3   8
      \   \
       4  10
         /  \
        9   20
```

Podatkovni tip v OCaml se glasi:

```ocaml
type searchtree = Empty | Node of int * searchtree * searchtree
```

V tipu *nismo* shranili informacije o tem, da je iskalno drevo urejeno! Če bo programer
ustvaril iskalno drevo, ki ni pravilno urejeno, prevajalnik tega ne bo zaznal.


:::{admonition} Naloga

Sestavite funkcije za iskanje, vstavljanje in brisanje elementov v iskalnem drevesu.

:::

## Koinduktivni tipi

Poznamo še en pomembno vrsto rekurzivnih tipov, to so **koinduktivni tipi**. Pojavljajo se v
računskih postopkih, ki so po svoji naravi lahko neskončni.

Tipičen primer koinduktivnega tipa je **komunikacijski tok podatkov:**

* bodisi je tok podatkov prazen (komunikacije je konec)
* bodisi je na voljo sporočilo `x` in preostanek toka

Primere take komunikacije najdemo povsod, kjer program komunicira z okoljem ali
z drugim programom: odjemalec s strežnikom, dva programa med seboj, program z
uporabnikom ipd.

Če preberemo zgornjo definicijo kot induktivni tip, se ne razlikuje od
definicije seznamov. To bi pomenilo, da bi moral biti komunikacijski tok vedno
končen, kar je nespametna predpostavka. V praksi seveda komunikacija ni
*dejansko* neskončna, a je *potencialno* neskončna, kar pomeni, da lahko dva
procesa komunicirata v nedogled in brez vnaprej postavljene omejitve.

**Koinduktivni tipi** so rekurzivni tipi, ki dovoljujejo tudi neskončne vrednosti.
Vendar pozor, kadar imamo opravka z neskončno velikimi seznami, drevesi itd.,
moramo paziti, kako z njimi računamo. Izogniti se moramo temu, da bi neskončno
veliko drevo ali komunikacijski tok poskušali izračunati v celoti do konca.

Haskell ima koinduktivne podatkovne tipe.

### Tokovi

Poglejmo različico tokov, ki so vedno neskončni, ker pri njih koinduktivna narava pride
še bolj do izraza. Tok je:

* sestavljen iz sporočila in preostanka toka

Če to definicijo preberemo induktivno, dobimo *prazen* tip, saj ne moremo
začeti. Res, če zapišemo v OCaml

```ocaml
type 'a stream = Cons of 'a * 'a stream
```

dobimo podatkovni tip, ki nima nobene končne vrednosti. Vrednost bi bila nujno neskončna, na primer:

* `Cons (1, Cons (2, Cons (3, Cons (4, …))))`
* `Cons (1, Cons (1, Cons (1, Cons (1, …))))`

OCaml sicer dopušča *nekatere* take vrednosti z definicijo `let rec`:

```ocaml
# let rec s = Cons (1, Cons (2, s)) ;;
val s : int stream = Cons (1, Cons (2, <cycle>))
```

A te vrednosti le pokvarijo induktivno naravo tipov, hkrati pa ne dovoljujejo
poljubnih neskončnih vrednosti. Če bi imele v praksi uporabno vrednost, bi jih
morda tolerirali, ker pa jih redkokdaj uporabimo, smo lahko nekoliko razočarani
nad odločitvijo snovalcev OCamla, da jih dovolijo.


### Tokovi v Haskellu

Ista definicija v Haskellu deluje, ker ima Haskell koinduktivne tipe.

V Haskellu podatkovne tipe pišemo nekoliko drugače:

* imena tipov se piše z velikimi začetnicami: `Bool`, `Integer`, ...
* produkt tipov `a` in `b` zapišemo `(a,b)`, se pravi tako kot urejene pare. Na
  primer, elementi tipa `(Bool, Int)` so `(False, 0)`, `(False, 42)`, `(True,
  23)` itd.
* enotski tip pišemo `()`, torej tako kot njegovo edino vrednost.
* zapis `e :: t` pomeni »`e` ima tip `t`«, zapis `e : t` pa seznam z glavo `e`
  in repom `t` (ravno obratno, kot v OCamlu)
* podatkovni tip uvedemo z določilom `data` in parameter pišemo za ime tipa z
  malimi črkami. Torej namesto `'a stream` zapišemo `Stream a`.

A to so le podrobnosti konkretne sintakse.

Poglejmo definicijo tokov in njihovo uporavo na preprostih primerih:

:::{literalinclude} tok.hs
:language: haskell
:::

### Tokovi v OCamlu

V OCaml lahko *simuliramo* tokove z uporabo tehnike *zavlačevanja* (angl. »thunk«).

Denimo da imamo izraz `e` tipa `t`, ki ga zaenkrat še ne želimo izračunati. Tedaj ga lahko
predelamo v funkcijo `fun () -> e` (po angleško se imenuje taka funkcija *thunk*), ki je
tipa `unit -> t`. Ker je `e` znotraj telesa funkcije, se bo izračunal šele, ko funkcijo
uporabimo na `()`. Od tod dobimo idejo, kako bi predstavili t.i. lene vrednosti v OCaml:

```ocaml
type 'a stream = Cons of 'a * (unit -> 'a stream)
```

Primeri uporabe:

:::{literalinclude} stream.ml
:language: ocaml
:::

### Vhod/izhod kot koinduktivni tip

Še en primer koinduktivnega tipa je vhod/izhod (input/output). Tokrat s koinduktivnim tipom izrazimo strukturo programa, ki izvaja operaciji `Read` in `Write`:

:::{literalinclude} io.hs
:language: haskell
:::
