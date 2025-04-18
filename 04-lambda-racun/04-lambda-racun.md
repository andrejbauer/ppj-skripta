# λ-račun

V začetku 20. stoletja so se logiki spraševali, kako bi natančno opredelili pojem »računski postopek«. Leta 1936 je Alan
Turing podal pojem stroja, ki še danes velja za standard. A pred Turingom je Alonzo Church podal svojo razlago
računanja, ki jo je poimenoval **λ-račun**. Kasneje se je izkazalo, da sta oba pojma ekvivalentna, vsaj kar se tiče
računanja s števili.

Kasneje je $λ$-račun pomembno vplival na razvoj programskih jezikov, zato je prav da ga spoznamo bolj podrobno. Poleg tega je
programiranje v λ-računu dobra vaja iz razumevanja osnovnih principov funkcijskega programiranja. Seveda čistega λ-računa, ki ga bomo
uporabljati, nihče ne uporablja v praksi, tako kot tudi ne Turingovih strojev.

Danes bomo spoznali **λ-račun brez tipov**, v poglavju o deklarativnem programiranju pa še λ-račun s tipi.


## Funkcijski predpis

V matematiki poznamo zapis za **funkcijski predpis**:

    x ↦ e

To preberemo »`x` se slika v `e`«, pri čemer je `e` izraz, ki lahko vsebuje `x`. Primer:

    x ↦ x² + 3·x + 7

Funkcijske predpise včasih imenujemo tudi **anonimne funkcije**, ker se razlikujejo od običajnih definicij funkcij, ki
le-te poimenujejo:

    f(x) := x² + 3·x + 7

Hkrati smo podali funkcijo in jo poimenovali `f`. Če poimenovanje in podajanje predpisa razstavimo, lahko zgornjo definicijo podamo tudi takole:

    f := (x ↦ x² + 3·x + 7)

Torej so funkcijski predpisi *bolj splošni* kot imenovane funkcije.

Funkcijski predpis lahko **uporabimo** na argumentu. Na primer, zgornji `f` lahko uporabimo na `3`
in dobimo izraz `f(3)`, ki mu pravimo **aplikacija**.

Dejstvo, da je funkcija poimenovana `f`, nima nobene zveze z aplikacijo. Prav lahko bi pisali neposredno

    (x ↦ x² + 3·x + 7)(3)

To se morda zdi nenavadno, a je lahko koristno v programiranju (kot bomo videli kasneje).
Nekateri programski jeziki imajo funkcijske predpise:

* Python: `lambda x: x**2 + 3*x + 7`
* Haskell: `\x -> x**2 + 3*x + 7`
* OCaml: `fun x -> x*x + 3*x + 7`
* Racket: `(lambda (x) (+ (* x x) (* 3 x) 7))`
* Mathematica: `#² + 3*# + 7 &` ali `Function[x, x² + 3*x + 7]`

### Vezane in proste spremenljivke

V funkcijskem predpisu

    x ↦ x² + 3·x + 7

se `x` imenuje **vezana spremenljivka**. S tem želimo povedati, da je `x` veljavna samo
znotraj funkcijskega predpisa, je kot neke vrste lokalna spremenljivka. Če jo
preimenujemo, se funkcijski zapis ne spremeni:

    a ↦ a² + 3·a + 7

Poudarimo, da štejemo funkcijska predpisa za enaka, če se razlikujeta le po tem, kateri
simbol je uporabljen za vezano spremenljivko.

V funkcijskem predpisu lahko nastopa tudi kaka dodatna spremenljivka, ki ni vezana.
Pravimo ji **prosta spremenljivka**, na primer:

    x ↦ a·x² + b·x + c

Tu so `a`, `b` in `c` proste spremenljivke. Teh ne smemo preimenovati, ker bi se pomen
izraza spremenil, če bi to storili.
(Pravzaprav bi lahko rekli, da imamo še dodatne proste spremenljivke `·`, `+` in `²`.)

Vezane in proste spremenljivke se pojavljajo tudi drugje v matematiki in računalništvu:

* v integralu $\int x^2 + a \cdot x \, d x$ je $x$ vezana spremenljivka in $a$ prosta
* v vsoti $\sum_{i=1}^n i · (i + k)$ je $i$ vezana spremenljivka, $n$ in $k$ sta prosti
* v limiti $\lim_{x \to a} (x - a)/(x + a)$ je $x$ vezana spremenljivka, $a$ je prosta
* v formuli $\exists x \in \mathbb{R} \,.\, x^3 = y$ je $x$ vezana spremenljivka, $y$ je prosta
* v programu

        for (int i = 0; i < 10; i++) {
            s += i;
        }

  je `i` vezana spremenljivka, `s` je prosta.

* v programu

        if (false) {
           int s = 0 ;
           for (int i = 0; i < 10; i++) {
              s += i;
           }
        }

sta `s` in `i` vezani spremenljivki.

Proste in vezane spremenljivke je treba pravilno razumeti. Na primer, `y ↦ a + y` lahko preberemo »prištej `a`«, kar je
različno od `a ↦ a + y`, kar preberemo »prištej `y`«.


### Substitucija ali zamenjava

Operacija, ki v izrazu prosto spremenljivko zamenja z izrazom, se imenuje **zamenjava** ali **substitucija**.
Zapišemo jo

    e [e'/x]

in preberemo »v `e` zamenjaj `x` z `e'`«.

Primeri:

* `(x² + 3·x + 7)[3/x]` je enako `3² + 3·3 + 7`,
* `f(a + b)[(b + 1)/a]` je enako `f((b + 1) + b)`,
* `f(a + b)[(x ↦ x²)/f]` je enako `(x ↦ x²)(a + b)`.

Ko napravimo substitucijo, moramo paziti, da se prosta spremenljivka ne »ujame«. S tem želimo povedati, da bi prosto
spremenljivko vstavili v podizraz, v katerem je že veljavna enako poimenovana vezana spremenljivka, s čimer bi prišlo do
zmede med obema spremenljivkama. Na primer, če v integralu

$$\int_0^1 x^2 + b \, d x$$

prosto spremenljivo $b$ naivno zamenjamo z izrazom $x + a$, dobimo

$$\int_0^1 x^2 + x + a \, d x$$

To ni prav, saj je je $x$ iz $x + a$ ujel v integralu. Pravilen rezultat dobimo, če vezano spremenljivko v integralu
najprej preimenujemo,

$$\int_0^1 x^2 + b \, d x = \int_0^1 t^2 + b \, d t,$$

in šele nato za $b$ vstavimo $x + a$:

$$\int_0^1 t^2 + x + a \, d t.$$

### Računsko pravilo ali β-redukcija

Vsi znamo računati s funkcijskimi predpisi in aplikacijami, čeprav se tega morda ne
zavedamo. Računsko pravilo, ki se iz zgodovinski razlogov imenuje **β-redukcija**, pravi

    (x ↦ e₁)(e₂)  =  e₁[e₂/x]

in ga preberemo:

> *Če uporabimo funkcijski predpis `x ↦ e₁` na argumentu `e₂`, dobimo izraz `e₁`, v katerem `x` zamenjamo z `e₂`.*

Primer uporabe β-redukcije:

    (x ↦ x² + 3·x + 7)(3)  =  3² + 3·3 + 7

Pozor, pravilo za funkcijski zapis *ne* trdi `(x ↦ x² + 3·x + 7)(3) = 25`, ampak le, da lahko `x` zamenjamo s `3` in
dobimo `3² + 3·3 + 7`. Če želimo od `3² + 3·3 + 7` preiti na `25`, moramo uporabiti še dodatna računska pravila, za
aritmetične operacije.

### Gnezdeni funkcijski predpisi

Funkcijske predpise lahko gnezdimo, ali jih uporabljamo kot argumente. Primeri:

1. `(x ↦ (y ↦ x · x + y))(42)  =  (y ↦ 42 · 42 + y)`
2. `((x ↦ (y ↦ x · x + y))(42))(1)  =  (y ↦ 42 · 42 + y)(1) =  42 · 42 + 1`
3. `(f ↦ f (f (3))) (n ↦ n · n + 1)  =  (n ↦ n · n + 1) ((n ↦ n · n + 1) (3)) =
    (n ↦ n · n + 1) (3 · 3 + 1) = (3 · 3 + 1) · (3 · 3 + 1) + 1`

Podobno kot pri integralih, je treba pred vstavljanjem izraza v funkcijski predpis po potrebi preimenovati vezano
spremenljivko:

* pravilno: `(x ↦ (y ↦ x · y²)) (z + 1) = (y ↦ (z + 1) · y²)`
* narobe:   `(x ↦ (y ↦ x · y²)) (y + 1) = (y ↦ (y + 1) · y²)`
* pravilno: `(x ↦ (y ↦ x · y²)) (y + 1) = (x ↦ (a ↦ x · a²)) (y + 1) = (a ↦ (y + 1) · a²)`


## λ-račun

Zapis `x ↦ e` postane dolgovezen, ko funkcijske zapise gnezdimo, zato bomo uporabili starejši zapis

    λ x . e

To je prvotni zapis funkcijskih predpisov, kot ga je zapisal Alonzo Church, vaš akademski
praded! Temu zapisu pravimo **abstrakcija** izraza `e` glede na spremenljivko `x`.

Poleg tega bomo aplikacijo `f(x)` pisali brez oklepajev `f x`. Seveda pa oklepaje
dodamo, kadar bi lahko prišlo do zmede. Dogovorimo se, da je aplikacija *levo
asociativna*, torej

    e₁ e₂ e₃  =  (e₁ e₂) e₃

V abstrakciji `λ` vedno veže največ, kolikor lahko. Torej je `λ x . e₁ e₂ e₃` je enako `λ
x . (e₁ e₂ e₃)` in ni enako `(λ x . e₁) e₂ e₃`.

Abstraktna sintaksa λ-računa je nadvse preprosta:

    ⟨izraz⟩ ::= ⟨spremenljivka⟩
              | ⟨izraz⟩ ⟨izraz⟩
              | λ ⟨spremenljivka⟩ . ⟨izraz⟩

Kadar imamo gnezdene abstrakcije

    λ x . λ y . λ z . e

jih gnezdimo `λ x . (λ y . (λ z . e))`. Dogovorimo se še, da lahko tako gnezdeno abstrakcijo
krajše zapišemo

    λ x y z . e


### Evalvacijske strategije

Pravilo za računanje lahko uporabimo na različne načine. Primer:

    (λ x . (λ f . f x) (λ y . y)) ((λ z . g z) u)

je enak

    (λ x . (λ f . f x) (λ y . y)) (g u)

in prav tako

    (λ x . (λ y . y) x) ((λ z . g z) u)

Vendar pa je λ-račun **konfluenten**, kar pomeni, da vrstni red računanja ni pomemben.
Natančneje, če ima `e` dva možna računska koraka, `e ↦ e₁` in `e ↦ e₂`, potem lahko v `e₁`
in v `e₂` izvedemo take računske korake, da se bosta pretvorila v isti izraz.

V zgornjem primeru:

    (λ x . (λ f . f x) (λ y . y)) (g u) =
    (λ x . (λ y . y) x) (g u)  =
    (λ x . x) (g u) =
    g u

in

    (λ x . (λ y . y) x) ((λ z . g z) u) =
    (λ x . x) ((λ z . g z) u) =
    (λ z . g z) u =
    g u

Dobili smo izraz, v katerem ne moremo več narediti računskega koraka. Pravimo, da je tak izraz v **normalni obliki**.

Postavi se vprašanje, kako sistematično računati. Poznamo nekaj strategij:

* **Neučakana (eager evaluation):** v izrazu `e₁ e₂` najprej do konca izračunamo `e₁` da
  dobimo `λ x . e`, nato do konca izračunamo `e₂`, da dobimo `e₂'` in šele nato vstavimo
  `e₂'` v `e`.

* **Lena (lazy evaluation):** v izrazu `e₁ e₂` najprej izračunamo `e₁`, da dobimo `λ x .
  e`, nato pa takoj vstavimo `e₂` v `e`.

Poleg tega lahko računamo znotraj abstrakcij ali ne. Programski jeziki znotraj abstrakcij
ne računajo (to bi pomenilo, da se računa telo funkcije, še preden smo funkcijo
poklicali).

:::{admonition} Primer

Izračunajmo `(λ x . (λ y . x) z) ((λ t . t) u)` na različne načine.

**Neučakano** (argument izračunamo, preden ga vstavimo):

    (λ x . (λ y . x) z) ((λ t . t) u) =
    (λ x . (λ y . x) z) u =
    (λ y . u) z =
    u

**Leno** (argument vstavimo takoj):

    (λ x . (λ y . x) z) ((λ t . t) u) =
    (λ y . ((λ t . t) u)) z =
    (λ t . t) u =
    u

Računamo tudi znotraj λ-abstrakcij neučakano:

    (λ x . (λ y . x) z) ((λ t . t) u) =
    (λ x . x) u =
    u

:::

:::{note}

Obstajajo izrazi, ki nimajo normalne oblike. Takih izrazov ne moremo »izračunati do konca«. Tak izraz je `(λ x . x x) (λ x . x x)`, ki ima natanko en možen računski korak, a ta pripelje spet do istega izraza:

    (λ x . x x) (λ x . x x) =
    (λ x . x x) (λ x . x x) =
    (λ x . x x) (λ x . x x) =
    ⋯

:::


## Programiranje v λ-računu

λ-račun je splošen programski jezik, ki je po moči ekvivalenten Turingovim strojem.

Začnimo z osnovnimi preslikavami. **Identiteta** je preslikava `x ↦ x`, ki jo zapišemo tudi kot

    id := λ x . x

Bolj zanimiva je **kompozicija** preslikav:

    compose := λ f g x . f (g x)

Tudi konstantne funkcije ni težko definirati:

    const := λ c x . c

Izraz `const e` je funkcija, ki vedno vrne `e`.


### Boolove vrednosti in pogojni stavek

Kako pa lahko dobimo Boolove vrednosti in pogojni stavek? Iščemo λ-izraze `true`, `false`, in `if`, za katere velja

    if true a b = a
    if false a b = b

V λ-računu ustrezne izraze definiramo takole:

    true := λ x y . x
    false := λ x y . y
    if := λ b t e . b t e

Preverimo, da imajo ustrezne lastnosti:

    if true a b =
    (λ b t e . b t e) true a b =
    (λ t e . true t e) a b =
    (λ e . true a e) b =
    true a b =
    (λ x y . x) a b =
    (λ y . a) b =
    a

Sami preverite, da velja `if false a b = b`.

### Urejeni pari

Da bomo lahko programirali z večimi vrednostmi hkrati, potrebujemo urejene pare, ki jih lahko gnezdimo, da dobimo urejene trojice, četverice itd.
Potrebujemo izraze `pair`, `first`, in `second`, ki zadoščajo enačbam:

    first (pair a b) = a
    second (pair a b) = b

Naslednji programi delujejo:

    pair := λ x y . λ p . p x y
    first := λ p . p (λ x y . x)
    second := λ p . p (λ x y. y)

Preverimo, da velja druga enačba:

    second (pair a b) =
    second ((λ x y . λ p . p x y) a b) =
    second (λ p . p a b) =
    (λ q . q (λ x y. y)) (λ p . p a b) =
    (λ p . p a b) (λ x y. y) =
    (λ x y. y) a b =
    b

#### Churcheva števila

Tudi naravna števila lahko predstavimo z λ-izrazi: število `n` predstavimo z izrazom, ki sprejme funkcijo in jo `n`-krat gnezdi:

    0 := λ f x . x
    1 := λ f x . f x
    2 := λ f x . f (f x)
    3 := λ f x . f (f (f x))
    4 := λ f x . f (f (f (f x)))
    5 := λ f x . f (f (f (f (f x))))
    6 := λ f x . f (f (f (f (f (f x)))))
    7 := λ f x . f (f (f (f (f (f (f x))))))
    8 := λ f x . f (f (f (f (f (f (f (f x)))))))
    9 := λ f x . f (f (f (f (f (f (f (f (f x))))))))


Na primer `3 foo bar = foo (foo (foo bar))`.

S Churchevimi števili lahko računamo. Ali razumete, kako delujejo naslednik, vsota in množenje?

    succ := λ n f x . f (n f x)
    
    + := λ n m f x . (n f) ((m f) x)
    
    * := λ m n f x . m (n f) x

Kako izračunamo predhodnik števila `n`? Vse kar lahko naredimo z `n` je, da `n`-krat uporabimo neko funkcijo.
Poglejmo, kaj dobimo, če trikrat uporabimo `f (x, y) := (x + 1, x)` na paru `(0, 0)`:

    f (f (f (0, 0))) =
    f (f (1, 0)) =
    f (2, 1) =
    (3, 2)

Dobili smo število `3` in njegov predhodnik `2`, kar pripelje do programa

    pred := λ n . second (n (λ p. pair (succ (first p)) (first p)) (pair 0 0))

Še nekaj programov, s katerimi primerjamo števila:

    iszero := λ n . n (K false) true
    
    <= := λ m n . iszero (n pred m)
    
    >= := λ m n . iszero (m pred n)
    
    < := λ m n . <= (succ m) n
    
    > := λ m n . >= m (succ n)

Ročno računanje z λ-računom je mukotrpno. V [PL Zoo](http://plzoo.andrej.com/) najdete programski jezik `lambda`, ki olajša delo.
Na voljo je tudi [spletni vmesnik](http://www.andrej.com/zapiski/ISRM-PPJ-2022/lambda/) za `lambda`. (Kogar zanima, kako se
tak vmesnik naredi, si lahko ogleda [`repl-in-browser`](https://github.com/andrejbauer/repl-in-browser)).


Da ohranimo kompatibilnost z računalniki iz leta 1968, se izognemo simbolu `λ` in ga nadomestimo z `^`.

:::{literalinclude} primeri.lambda
:language: none
:::


