# Monade in računski učinki

Monade so matematični pojem, ki posplošuje algebrajske strukture, kot so grupa, kolobar in vektorski prostor. Hkrati pa se monade uporablja tudi v teoretičnem računalništvu in deklarativnem programiranju za opisovanje *računskih učinkov*. V tej lekciji bomo spoznali osnovno uporabo monad v programiranju.

Haskell je čist programski jezik in vse računske učinke predstavi z monadami. Programer lahko v Haskellu definira nove monade in z njimi simulira razne računske učinke. Tudi drugi programski jeziki imajo monade, le da niso neposredno dostopne programerju. Jeziki kot so OCaml, Java, C++ uporabljajo le eno monado, ki predstavlja vse računske učinke, podprte v jeziku (I/O, izjeme, stanje).

## Računski učinki

**Računski učinki** so širok pojem, ki ga je težko povsem opredeliti. Lahko rečemo, da je računski učinek vsak pojav v programu, ki ni le preprosto procesiranje informacije. Med računske učinke štejemo:

* **manjkajoča vrednost**: program lahko ugotovi, da rezultat ne more izračunati, na primer, ker ena od vmesnih operacij ni definirana
* **izjeme**: program lahko nenadoma prekine izvajanje in javi napako ali vrže izjemo (`throw`, `catch`)
* **vhod/izhod**: program lahko komunicira z zunanjim svetom preko vhodnega in izhodnega kanala (`input`, `print`)
* **stanje**: program ima trenutno stanje, ki se spreminja, ko program teče (`set`, `get`)
* **nedeterminizem**: program lahko izbira med več možnostmi
* **verjetnostno računanje**: program lahko izbira med več možnostmi z verjetnostno porazdelitvijo
* **timeout**: izvajanje se lahko prekine, če traja predolgo

Poznamo pa še veliko drugih računskih učinkov.

## Monade

Zgoraj našteti računski učinki so zelo raznoliki, a kljub temu imajo skupno strukturo, ki jo zajema pojem monade. Razložimo ga iz stališča programerja, ki želi *simulirati* računske učinke v »na roko«, se pravi v čistem jeziku.

Najprej ločimo med:

* **(čista) vrednost** (pure value): že izračunan podatek, ki je »inerten«, ga ne izvajamo.

* **izračunom** (computation): koda, ki jo moramo izvesti, da dobimo rezultat, med izvajanjem pa se lahko pojavljajo računski učinki.

:::{admonition} Primer

V programskem jeziku OCaml, je

```ocaml
print_endling "hello" ; let x = 14 in (3 * x, ["cow"; "rabbit"])
```

izračun. Ko ga poženemo, sproži učinek (izpis na zaslon) in vrne vrednost `(42, ["cow"; "rabbit"])`.

:::

Ker bomo izračune *simulirali*, jih bomo predstavili z ustreznimi podatkovnimi tipi, ki izražajo računske učinke. Vsak računski učinek ali kombinacija učinkov ima svoj podatkovni tip.


:::{admonition} Primer

Izračun, v katerem se lahko zgodi učinek »manjkajoča vrednost«, predstavimo s tipom `Maybe a`:

* če izračun uspešno izračuna končno vrednost `v`, to predstavimo z `Just v`
* če naleti na manjkajočo vrednost, to predstavimo z `Nothing`

:::

:::{admonition} Primer

Izračun, ki lahko izpisuje na standardni izhod, predstavimo s tipom `(String, a)`:

* izračun, ki na zaslon izpiše `Kdor to bere, je osel` in vrne vrednost `42`, predstavimo
  z urejenim parom `("Kdor to bere, je osel", 42)`.
:::

:::{admonition} Primer

Izračun, ki prebere niz s standardnega vhoda in vrne rezultat, predstavimo s tipom `String -> a`, ker je rezultat lahko
odvisen od vhodnega podatka, ki ga je dobil izračun.

:::

:::{admonition} Primer

Izračun, ki ima stanje tipa `s` in rezultat tipa `a`, prestavimo s tipom `s -> (s, a)`, kar preberemo takole: izračun sprejme stanje in vrne spremenjeno stanje in rezultat.
:::

Ni nujno, da vsak izračun povzroči računske učinke. Taki, ki samo vrnejo vrednost, se imenujejo **čisti izračuni**.
Poleg tega lahko izračune **komponiramo**, podobno kot funkcije, da se zgodijo eden za drugim. Struktura, ki opisuje čiste izračune in komponiranje, je **monada**.

## Monada

V funkcijskem programiranju monada predstavlja enega ali kombinacijo večih učinkov. Njene sestavine so:

1. Preslikava `T : Type → Type`, ki vsak tip `a` preslika v `T a`. Lahko si mislimo, da so elementi `T a` izračuni, ki
   izračunajo vrednost tipa `a` in sprožajo učinke, ki jih zajema `T`. To *ne* pomeni, da je element `c : T a` neke
   vrste »vrednost tipa `a`, zapakiran v računske učinke `T`.
2. Preslikava `return : a → T a`, ki vrednost tipa `a` predstavi kot čisti izračun.
3. Operacija `>>= : T a → (a → T b) → T b`, ki kombinira izračune. Če je `c` izračun, ki izračuna vrednost tipa `a` in
   je `f : a → T b` funkcija, ki vrednosti tipa `a` preslika v izračune `T b`, potem je `e >>= f` izračun, ki ju združi.

:::{admonition} Primer

Učinski računek **nedeterminizem** dobimo v primeru, da lahko program vrne več rezultatov, oziroma da v teku računanja izbira med več možnostmi. Ustrezna monada je:

1. `T a = [a]`, se pravi, izračun vrednosti tipa `a` predstavimo s seznamov vseh rezultatov, ki bi jih lahko dobili.
2. `return v = [v]`, ker je čista vrednost `v` enakovredna seznamu `[v]`, torej izračunu, ki vrne natančno `v`.
3. `>>=` je `concat`, funkcija, ki združuje sezname.

:::

Monada mora zadoščati se naslednjim zakonom:

1. `(return x) >>= f = f x`
2. `(c >>= return) = c`
3. `(c >>= f >>= g) = c >>= (\x -> f x >>= g)`

Zakaj ravno ti zakoni? Poleg globljih matematičnih razlogov, se izkaže, da jim razni računski učinki zadoščajo.

Več o monadah lahko preberete na strani [Monad](https://wiki.haskell.org/Monad) v Haskell wiki.

## Monade v Haskellu

Vse do sedaj našteto je v Haskellu predstavljeno z razredi tipov:

* [`Functor`](https://hackage.haskell.org/package/base-4.14.0.0/docs/Data-Functor.html)
* [`Applicative`](https://hackage.haskell.org/package/base-4.14.0.0/docs/Control-Applicative.html)
* [`Monad`](https://hackage.haskell.org/package/base-4.12.0.0/docs/Control-Monad.html)

Spoznali jih bomo na primerih in si ogledali v živo, kako delujejo.
