# Logično programiranje

Do sedaj smo spoznali *ukazno* in *deklarativno* programiranje:

* Pri ukaznem programiranju na izvajanje programa gledamo kot na zaporedje
akcij, ki spreminjajo stanje sistema (vrednosti spremenljivk).

* Pri deklarativnem programiranju je program izraz, ki se preračuna
v končno *vrednost*.

Logično programiranje izhaja iz ideje, da je izvajanje programa **iskanje
dokaza**. Da bomo to razumeli, najprej ponovimo nekaj osnov logike.

## Hornove formule

V logiki prvega reda lahko zapišemo formule sestavljene iz konstant $\bot$, $\top$,
veznikov $\land$, $\lor$, $\Rightarrow$, $\lnot$ in kvantifikatorjev $\forall$ (za vsak), $\exists$ (obstaja).
Take formule so lahko precej zapletene in niso primerne za logično
programiranje, zato se omejimo na tako imenovane **Hornove formule**, ki so
oblike

$$
\forall x_1, \ldots, x_m . (\phi_1 \land \phi_2 \land ⋯ \land \phi_n \Rightarrow \psi).
$$

Tu so $\phi_1, \ldots, \phi_n$ in $\psi$ **osnovne formule**, se pravi vsaka od njih je oblike

$$
p(t_1, \ldots, t_m)
$$

kjer je $p$ **relacijski simbol** in $t_1, \ldots, t_m$ **termi**. Nadalje je term
izraz, ki ga lahko sestavimo iz konstant, funkcijskih simbolov in spremenljivk.

:::{admonition} Primer

Denimo, da imamo relacijski simbol `less`, funkcijske simbole `plus`, `times`, `succ`, kostanto `zero` in spremenljivki `X` in `Y`.
Tedaj sta `plus(times(X,X), times(Y, Y))` in `times(succ(succ(zero)), times(X, Y))` terma in

```none
less(plus(times(X,X), times(Y, Y)), times(succ(succ(zero)), times(X, Y)))
```

osnovna formula. Običajno to formulo zapišemo $X \cdot X + Y \cdot Y < 2 \cdot X \cdot Y$.
:::

Poseben primer Hornove formule je **dejstvo**, ki ga dobimo pri $n = 0$:

$$
\forall x_1, \ldots, x_m . \psi.
$$

Drugi primer je formula brez kvantifikatorjev (v kateri ni spremenljivk, samo
konstante), ki ga dobimo pri $m = 0$:

$$
\phi_1 \land \phi_2 \land \cdots \land \phi_n \Rightarrow \psi.
$$

:::{admonition} Primer
Hornova formula

$$
\forall a . (\mathsf{pes}(a) \Rightarrow \mathsf{zival}(a))
$$

pove, da so psi živali: “za vsak $a$, če je $a$ pes, potem je $a$ žival”.
:::


:::{admonition} Primer
Hornova formula

$$
\forall x \, y \, z . (\mathsf{otrok}(x, y) \land \mathsf{otrok}(y, z) \land \mathsf{zenska}(z) \Rightarrow \mathsf{babica}(x, z))
$$

pravi: “za vse (osebe) $x$, $y$, $z$, če je $x$ otrok od $y$ in $y$ otrok od $z$
in je $z$ ženska, potem je $z$ babica od $x$”.
:::

:::{admonition} Vzgojen primer
Formula

$$
\forall x \, y \, z . \mathsf{otrok}(x, z) \land \mathsf{otrok}(y, z)
   \land \mathsf{zenska}(x) \land \mathsf{zenska}(y) \Rightarrow \mathsf{sestra}(x, y).
$$

*ne* pomeni “$x$ in $y$ sta sestri” ampak “$x$ in $y$ sta sestri ali polsestri, ali
pa sta enaka”.
:::


## Predstavitev funkcije z relacijo

S Hornovimi formulami lahko izrazimo tudi matematična dejstva. Peanova aksioma
za seštevanje se glasita

\begin{align*}
 \forall n . n + 0 &= n \\
 \forall k \, m . k + \mathsf{succ}(m) &= \mathsf{succ}(k + m) \\
\end{align*}

Pravzaprav v Prologu ni funkcij! Definirati moramo *relacijo*, ki predstavlja funkcijo:

:::{admonition} Definicija

Pravimo, da relacija $R$ **predstavlja** funkcijo $f$, če je $f(x) = y \Leftrightarrow R(x, y)$.
:::

Za funkcijo seštevanja: namesto operacije $+$ definiramo relacijo $\mathsf{vsota}$, da
velja:

$$
  x + y = z \Leftrightarrow \mathsf{vsota}(x, y, z).
$$

S Hornovima formulama ju zapišemo takole, pri čemer $\mathsf{vsota}(x,y,z)$ beremo “vsota
$x$ in $y$ je $z$":

\begin{align*}
  &\forall n . \mathsf{vsota}(n, 0, n) \\
  &\forall k \, m \, n . \mathsf{vsota}(k, m, n) \Rightarrow \mathsf{vsota}(k, \mathsf{succ}(m), \mathsf{succ}(n))
\end{align*}

Prva formula očitno ustreza prvemu aksiomu, druga pa je ekvivalentna

$$
  \forall k \, m \, n . k + m = n \Rightarrow k + \mathsf{succ}(m) = \mathsf{succ}(n),
$$

kar je ekvivalentno drugemu aksiomu (premisli!).

:::{admonition} Naloga

S Hornovimi formulami zapišite Peanova aksioma za množenje:

\begin{align*}
  &\forall n . n \cdot 0 = 0 \\
  &\forall k \, m . k \cdot \mathsf{succ}(m) = k + k \cdot m
\end{align*}

Uporabi relacijo $\mathsf{vsota}$ iz prejšnjega primera, ter relacijo $\mathsf{zmnozek}(x,y,z)$, ki ga
beremo “zmnožek $x$ in $y$ je $z$”.
:::


:::{admonition} Primer

Nekaterih dejstev s Hornovimi formulami ne moremo izraziti, na primer negacije $\lnot \phi$
in eksistenčnih formul $\exists x . \phi$.

:::

## Sistematično iskanje dokaza

Denimo, da imamo Hornove formule in želimo vedeti, ali iz njih sledi dana
izjava. Kako bi *sistematično* poiskali dokaz?

:::{admonition} Primer

Najprej poglejmo primer brez kvantifikatorjev. Ali iz Hornovih formul

1. $X \land Y \Rightarrow C$
2. $A \land B \Rightarrow C$
3. $X \Rightarrow B$
4. $A \Rightarrow B$
5. $A$

sledi $C$?

Iskanja dokaza se lotimo sistematično. Katera od formul bi lahko pripeljala do
dokaza izjave $C$? Prva ali druga. Poskusimo obe:

* če uporabimo $X \land Y \Rightarrow C$, $C$ prevedemo na *podnalogi* $X$ in $Y$. A tu se
  zatakne, ker o $X$ in $Y$ ne vemo nič pametnega.

* če uporabimo $A \land B \Rightarrow C$, $C$ prevedemo na *podnalogi* $A$ in $B$:

    * dokažimo $A$: to velja zaradi 5. formule
    * dokažimo $B$: uporabimo lahko 3. ali 4. formulo. Tretja ne deluje, četrta pa
      dokazovanje prevede na podnalogo $A$, ki velja.
:::


:::{admonition} Primer

Ali iz

1. $\forall x \, y . \mathsf{otrok}(x, y) \Rightarrow \mathsf{mlajsi}(x, y)$
2. $\mathsf{otrok}(\mathsf{miha}, \mathsf{mojca})$

sledi $\mathsf{mlajsi}(\mathsf{miha}, \mathsf{mojca})$? Če v prvi formuli vzamemo $x = \mathsf{miha}$ in $y =
\mathsf{mojca}$, lahko nalogo prevedemo na $\mathsf{otrok}(\mathsf{miha}, \mathsf{mojca})$. To pa velja zaradi druge
formule.
:::

:::{admonition} Primer

Ali iz

1. $\forall x . \mathsf{sodo}(x) \Rightarrow \mathsf{liho}(\mathsf{succ}(x))$
2. $\forall y . \mathsf{liho}(y) \Rightarrow \mathsf{sodo}(\mathsf{succ}(y))$
3. $\mathsf{sodo}(\mathsf{zero})$

sledi $\mathsf{sodo}(\mathsf{succ}(\mathsf{succ}(\mathsf{zero})))$? Tokrat zapišimo bolj sistematično postopek iskanja:

* dokaži $\mathsf{sodo}(\mathsf{succ}(\mathsf{succ}(\mathsf{zero})))$
* uporabimo drugo formulo, za $y$ vstavimo $\mathsf{succ}(\mathsf{zero})$ in dobimo nalogo
* dokaži $\mathsf{liho}(\mathsf{succ}(\mathsf{zero}))$
* uporabimo prvo formulo, za $x$ vstavimo $\mathsf{zero}$ in dobimo nalogo
* dokaži $\mathsf{sodo}(\mathsf{zero})$
* to velja zaradi tretje formule.

V splošnem bomo morali rešiti nalogo **združevanja**: poišči take vrednosti
spremenljivk, da sta dani formuli enaki*. Podobno nalogo smo že reševali, ko
smo obravnavali parametrični polimorfizem, kjer smo izenačevali tipe.
:::


## Logično programiranje

V logičnem programiranju je program podan s

* seznamom **pravil** $H_1, \ldots, H_k$, ki so Hornove formule
* **poizvedbo** $G$, ki je formula oblike $\exists y_1, \ldots, y_n . p(t_1, \ldots, t_m)$.

Zanima nas, ali poizvedba sledi iz pravil. Poizvedbo $G$ predelamo na poizvedbe
in **iščemo v globino**, takole:

V seznamu $H_1, \ldots, H_m$ poišči prvo formulo, ki je oblike

$$
\forall x_1, \ldots, x_n . \phi_1 \land \cdots \land \phi_m \Rightarrow \psi,
$$

katere sklep $\psi$ je **združljiv** z $p(t1, \ldots, t_m)$. To pomeni da lahko za
$y_1, \ldots, y_n$ vstavimo take vrednosti $u_1, \ldots, u_n$ in za
$x_1, \ldots, x_n$ take vrednosti $v_1, \ldots, v_m$, da sta formuli

$$
p(u_1, \ldots, u_n)
$$

in

$$
\psi(v_1, \ldots, v_m)
$$

enaki. Možno je, da izbira vrednosti $u_1, \ldots, u_n$ in $v_1, \ldots, v_m$ ni
enolična. V tem primeru izberemo *najbolj splošne vrednosti*, ki jih najdemo s
postopkom združevanja, ki smo ga spoznali v poglavju o izpeljavi tipov.

S tem smo poizvedbo smo predelali na poizvedbe $\phi_1(v_1, \ldots, v_m), \ldots, \phiᵣ(v_1, \ldots, v_m)$, ki jih
rešujemo po vrsti rekurzivno. (Če se v teh poizvedbah pojavljajo spremenljivke, jih obravnavamo, kot da smo jih
kvantificirali z $\exists$.)


:::{admonition} Primer

Poglejmo si še enkrat primer, ko imamo Hornove formule

1. $\mathsf{sodo}(\mathsf{zero})$
2. $\forall x . \mathsf{sodo}(x) \Rightarrow \mathsf{liho}(\mathsf{succ}(x))$
3. $\forall y . \mathsf{liho}(y) \Rightarrow \mathsf{sodo}(\mathsf{succ}(y))$

in poizvedbo $\exists z . \mathsf{liho}(z)$.

Ali lahko združimo $\mathsf{sodo}(\mathsf{zero})$ in $\mathsf{liho}(z)$? Ne.

Ali lahko združimo $\mathsf{liho}(\mathsf{succ}(x))$ in $\mathsf{liho}(z)$? Poskusimo s postopkom združevanja:
Enačbo

$$
\mathsf{liho}(\mathsf{succ}(x)) = \mathsf{liho}(z)
$$

prevedemo na enačbo

$$
\mathsf{succ}(x) = z
$$

Dobili smo rešitev za $z$ in ni več enačb, torej je $x$ poljuben. Torej uporabimo
drugo pravilo, ki prevede nalogo na

$$
\exists x . \mathsf{sodo}(x)
$$

Ali lahko to združimo s prvo formulo? Poskusimo rešiti

$$
\mathsf{sodo}(\mathsf{zero}) = \mathsf{sodo}(x)
$$

Rešitev je $x = \mathsf{zero}$. Ker je prva formula dejstvo, ni nove podnaloge.

Rešitev se glasi: $x = \mathsf{zero}$, $z = \mathsf{succ}(x)$. Končna rešitev je torej

$$
z = \mathsf{succ}(\mathsf{zero})
$$

Dokazali smo, da res obstaja liho število, namreč $\mathsf{succ}(\mathsf{zero})$.
:::

:::{admonition} Primer

Če v prejšnjem primeru zamenjamo vrstni red pravil,

1. $\forall x . \mathsf{sodo}(x) \Rightarrow \mathsf{liho}(\mathsf{succ}(x))$
2. $\forall y . \mathsf{liho}(y) \Rightarrow \mathsf{sodo}(\mathsf{succ}(y))$
3. $\mathsf{sodo}(\mathsf{zero})$

potem poizvedba $\exists z . \mathsf{liho}(z)$
privede do neskončne zanke (ker iščemo v globino in vedno uporabimo prvo
pravilo, ki deluje). Namreč, z uporabo prvega pravila dobimo poizvedbo

$$
\exists x . \mathsf{sodo}(x)
$$

nato z uporabo drugega pravila ($x = \mathsf{succ}(y)$)

$$
\exists y . \mathsf{liho}(y)
$$

nato z uporabo prvega pravila

$$
\exists u . \mathsf{sodo}(u)
$$

in tako naprej. Tretje pravilo nikoli ne pride na vrsto!
:::


## Prolog

Prolog je programski jezik, v katerem logično programiramo. Ima nekoliko
nenavadno sintakso:

* namesto $A \land B$ pišemo `A, B`
* namesto $A \lor B$ pišemo `A ; B`
* namesto $A \Rightarrow B$ pišemo `B :- A` (pozor, zamenjal se je vrstni red, $B \Leftarrow A$!)
* kvantifikatorjev $\forall$ in $\exists$ ne pišemo, ampak **kvantificirane spremenljivke pišemo z velikimi črkami**
* **konstante, predikate in funkcije pišemo z malimi črkami**.

Na koncu vsake formule zapišemo piko.

Predelajmo primer iz prejšnjega razdelka v Prolog. Najprej v datoteko `even_odd.pl` spravimo pravila (pri čemer pravila
za `sodo` zložimo skupaj, da se ne pritožuje):

:::{literalinclude} even_odd.pl
:language: prolog
:::

Datoteko naložimo v interaktivno zanko. Ta nam omogoča, da vpišemo poizvedbo in dobimo odgovor:

```prolog
?- liho(Z).
Z = succ(zero) ;
Z = succ(succ(succ(zero))) ;
Z = succ(succ(succ(succ(succ(zero))))) .
```

Ko nam prolog poda odgovor, lahko z znakom `;` zahtevamo, da išče še naprej. Z znakom `.` zaključimo iskanje.

:::{admonition} Naloga
Ali se prolog res spusti v neskončno zanko, če zamenjamo vrsti red pravil za `sodo`?
:::

:::{admonition} Naloga
Na svoj računalnik si namesti [SWI Prolog](https://www.swi-prolog.org) in poženi zgornji program.
:::

### Seznami

Kako bi v Prologu naredili sezname? V Ocamlu smo jih definirali kot induktivni tip:

```ocaml
type 'a list = Nil | Cons of 'a * 'a list
```

Na primer, `Cons(a, Cons(b, Cons(c, Nil)))` je seznam z elementi `a`, `b` in `c`.

V Prologu ni tipov, lahko pa uporabljamo poljubne konstante in konstruktorje, le
z malimi črkami jih je treba pisati. Torej lahko sezname še vedno predstavljamo
z `nil` in `cons`.

Seznamov ni treba v naprej definirati, se pravi, ni treba razlagati, kaj sta
`nil` in `cons`. Prolog ju obravnava kot simbola, s katerimi lahko tvorimo
izraze. Seznam `[a; b; c]` zapišemo `cons (a, cons (b, cons (c, nil)))`.

**Opomba:** Prolog ima tudi vgrajene sezname, glej spodaj.


### Relacija `elem`

Da bomo dobili občutek za moč logičnega programiranja, definirajmo nekaj funkcij
za delo s seznami.

Naš prvi program je relacija, ki ugotovi, ali je dani `X` pripada danemu seznamu `L`:

```prolog
elem(X, cons(X, _)).
elem(X, cons(_, L)) :- elem(X, L).
```

V datoteko `list.pl` zapišemo:

:::{literalinclude} list.pl
:language: prolog
:::

Poskusimo:

```prolog
?- elem(a, cons(b, cons(a, cons(c, cons(d, cons(a, nil)))))).
true ;
true ;
false.
```

Zakaj smo dvakrat dobili `true` in nato `false`?

Vprašamo lahko tudi, kateri so elementi danega seznama:

```prolog
?- elem(X, cons(a, cons(b, cons(a, cons(c, nil))))).
X = a ;
X = b ;
X = a ;
X = c ;
false.
```

In celo, kateri seznami vsebujejo dani element!

```prolog
?- elem(a, L).
L = cons(a, _3234) ;
L = cons(_3232, cons(a, _3240)) ;
L = cons(_3232, cons(_3238, cons(a, _3246))) ;
L = cons(_3232, cons(_3238, cons(_3244, cons(a, _3252)))) ;
L = cons(_3232, cons(_3238, cons(_3244, cons(_3250, cons(a, _3258))))) ;
L = cons(_3232, cons(_3238, cons(_3244, cons(_3250, cons(_3256, cons(a, _3264)))))) .
```

Prolog je ustvaril pomožne spremenljivke `_XYZW`, s katerimi označi poljubne terme.

### Relacija `join`

Funkcijo, ki stakne seznama predstavimo s trimestno relacijo `join`:

> `join(X, Y, Z)` pomeni, da je `Z` enak stiku seznamov `X` in `Y`.

Zapišimo pravila zanjo:

```prolog
join(nil, Y, Y).
join(cons(A, X), Y, cons(A, Z)) :- join(X, Y, Z).
```

To je podobno funkciji, ki bi jo definirali v OCamlu:

```ocaml
let rec join x y=
  match (x, y) with
  | (Nil, y) -> y
  | (Cons (a, x), y) ->
      let z = join x y in
      Cons (a, z)
```

Takole izračunamo stik seznamov `cons(a, cons(b, nil))` in `cons(x, cons(y, cons(z, nil)))`:

```prolog
?- join(cons(a, cons(b, nil)), cons(x, cons(y, cons(z, nil))), Z).
Z = cons(a, cons(b, cons(x, cons(y, cons(z, nil))))).
```

#### Vgrajeni seznami

Prolog že ima vgrajene sezname:

* `[e_1, e_2, …, e_m]` je seznam elementov `e_1`, `e_2, …, e_m`.
* `[e | ℓ]` je seznam z glavo `e` in repom `ℓ`
* `[e_1, e_2, …, e_m | ℓ]` je seznam, ki se začne z elementi `e_1`, `e_2, …, e_m` in ima rep `ℓ`.

Za delo s seznami je na voljo [knjižnica `lists`](https://www.swi-prolog.org/pldoc/man?section=lists), ki jo naložimo z ukazom

```prolog
:- use_module(library(lists)).
```

Ta že vsebuje relaciji `member` (ki smo jo zgoraj imenovali `elem`) in `append` (ki
smo jo zgoraj imenovali `join`). Preizkusimo:

```prolog
?- append([a,b,c], [d,e,f], Z).
Z = [a, b, c, d, e, f].
```

Lahko pa tudi vprašamo, kako razbiti seznam `[a,b,c,d,e,f]` na dva podseznama:

```prolog
?- append(X, Y, [a,b,c,d,e,f]).
X = [],
Y = [a, b, c, d, e, f] ;
X = [a],
Y = [b, c, d, e, f] ;
X = [a, b],
Y = [c, d, e, f] ;
X = [a, b, c],
Y = [d, e, f] ;
X = [a, b, c, d],
Y = [e, f] ;
X = [a, b, c, d, e],
Y = [f] ;
X = [a, b, c, d, e, f],
Y = [] ;
false.
```

### Enakost in neenakost

Včasih v Prologu potrebujemo enakost in neenakost. Enakost pišemo `s = t` in neenakost `s \= t`.

## Primer: ukazni programski jezik

Če bo čas, si bomo ogledali, kako v Prologu implementiramo tolmač za preprost
ukazni programski jezik:

:::{literalinclude} comm.pl
:language: prolog
:::
