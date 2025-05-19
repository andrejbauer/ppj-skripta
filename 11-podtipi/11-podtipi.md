# Podtipi

Spoznali smo že *polimorfizem*, to je lastnost, da ima lahko izraz več kot en
tip. Na primer, v OCamlu ima preslikava

    fun (x, y) -> (y, x)

tip `α × β → β × α`, kjer sta `α` in `β` poljubna tipa. Danes bomo spoznali
**podtipe**, ki delujejo podobno: če ima izraz `e` tip `t`, ga lahko
uporabljamo, kot da bi imel tudi vse nadtipe tipa `t`.

Na primer, v nekaterih programskih jezikih lahko izraz `e` tipa `int` vedno
uporabimo, kot da bi ime tip `float`, saj bo jezik samo pretvoril `e`.

V Javi poznamo *podrazrede*, ki so tudi vrsta podtipov, a jih bomo obravnavali
prihodnjič.

## Relacija podtip `A ≤ B`

Najprej se dogovorimo za zapis relacije "podtip". Za tipa $A$ in $B$ zapis

$$
A \leq B
$$

preberemo »$A$ je podtip $B$« ali »$B$ je nadtip $A$«. Sledimo naslednjemu
osnovnemu načelu:

:::{important}
$A$ je podtip $B$, če lahko vrednosti tipa $A$ uporabljamo, kot da bi imele
tip $B$.
:::

Pravilo sklepanja, ki izraža zgornje načelo je

$$
\frac{e : A \qquad A \leq B}{e : B}
$$

in preberemo: »Če ima $e$ tip $A$ in je $A$ podtip $B$, potem ima $e$ tudi tip $B$.«

:::{warning}

Zmotno bi si bilo predstavljati, da je $A \leq B$ isto kot $A \subseteq B$, se
pravi, da je podtip ista reč kot podmnožica. V razdelku o podtipih zapisov bomo
namreč spoznali podtipe, ki se razlikujejo od relacije podmnožica.

:::

Zapišimo pravila, ki izražajo pričakovane lastnosti relacije $\leq$. Vsekakor je relacija *refleksivna* in *tranzitivna* (taki relaciji pravimo *šibka urejenost*):

$$
\frac{ }{A \leq A}
\qquad
\frac{A \leq B \quad B \leq C}{A \leq C}
$$

Kaj pa antisimetričnost: če $A \leq B$ in $B \leq A$, potem $A = B$? Ne, kasneje
bomo videli protiprimer, torej $\leq$ ni *delna urejenost*.

Nadalje zapišemo še pravila, ki opredeljujejo, kako se obnašajo podtipi za razne
operacije. Kartezični produkti delujejo po pričakovanjih:

$$
\frac{A_1 \leq B_1 \quad A_2 \leq B_2}{A_1 \times A_2 \leq B_1 \times B_2}
$$

Pravilo za funkcijske tipe je bolj zanimivo, pozorno ga preberite:

$$
\frac{B_1 \leq A_1 \quad A_2 \leq B_2}{A_1 \to A_2 \leq B_1 \to B_2}
$$

Obrnili smo vrsti red v domeni! Pravimo, da je $\to$ **kontravarianten** (obrača
smer) v prvem argumentu in **kovarianten** (ohranja smer) v drugem. Skupaj
premislimo, zakaj pričakujemo tako pravilo.

Kaj pa osnovni tipi? Ali je na primer $\mathtt{int} \leq \mathtt{float}$? To je odvisno od
programskega jezika: Java samodejno pretvori celo število v realno, zato bi
lahko rekli, da v javi velja $\mathtt{int} \leq \mathtt{float}$. V OCamlu to ne drži, saj mora
programer sam pretvoriti celoštevilsko vrednost v realno s funkcijo $\mathtt{float}$.

Lahko se celo zgodi, da v programskem jeziku velja $\mathtt{int} \leq \mathtt{float}$ *in hkrati*
$\mathtt{float} \leq \mathtt{int}$, na primer, če jezik samodejno zaokroži realno vrednost, kadar
potrebuje celoštevilsko. A takih jezikov ni veliko.


## Podtipi zapisov

Spoznali smo že zapise, to so nabori polj s poimenovanimi komponentami. Na
primer, točke v ravnini lahko predstavimo z vrednostmi tipa zapisov

```ocaml
{ x : float; y : float }
```

Primer vrednosti tega tipa je zapis `{x = 3.14; y = 2.78}`.

V splošnem je tip zapisa

```none
{ ℓ₁ : A₁; ℓ₂ : A₂; …; ℓ_n : A_n }
```

njegove vrednosti pa so oblike

```none
{ ℓ₁ = e₁; ℓ₂ = e₂; …; ℓ_n = e_n }
```

kjer mora veljati $e_i : A_i$ za vse $1 \leq i \leq n$ Zahtevamo še, da so imena polj `ℓ₁`, …, `ℓ_n` med
seboj paroma različna.

Če je `v` zapis tipa `{ ℓ₁ : A₁; ℓ₂ : A₂; …; ℓ_n : A_n }`, potem je `v.ℓᵢ`
vrednost njegove `i`-te komponente, ki ima tip `Aᵢ`.

V zapisu vrstni red polj ni pomemben, to je, `{x = 3.14; y = 2.78}` in `{y = 2.78; x = 3.14}` sta enaki vrednosti.

Zapisi so uporaben podatkovni tip, ne samo v programiranju, ampak tudi na drugih
področjih računalništva, kjer želimo predstviti strukturirane podatke. Na
primer, vrstica v tabeli podatkovne baze ni nič drugega kot zapis (in shema za
tabelo tip zapisa).

Tudi objekti nas nekoliko spominjajo na zapise, le da vsebujejo poleg polj
(atributov) še metode:

```java
    public class Point {
       float x;
       float y
       ...
    }
```

### Podtipi zapisov v širino

Zapisi tipov imajo zanimivo relacijo $\leq$. Obravnavajmo primer. Na primer, da imamo tipa zapisov

$$
A = \{ x : \mathtt{float}; y : \mathtt{float} \}
$$

in

$$
B = \{ x : \mathtt{float}; y : \mathtt{float} ; z : \mathtt{float} \}
$$

Ali morda velja $A \leq B$ in $B \leq A$?

Najprej, $A \leq B$ *ne* velja. Izraz $a = \{x = 3.14; y = 2.78\}$ ima tip $A$. Če bi
ga lahko uporabljali, kot da ima tip $B$, potem bi smeli pisati $a.z$, kar
seveda ne gre, saj $a$ nima polja $z$.

Velja pa $B \leq A$! Izraz $b = \{x = 3.14; y = 2.78; z = 1.0\}$ ima tip $B$ in res
ga lahko uporabimo, kot da bi imel tip $A$, saj smemo pisati $b.x$ in $b.y$.
Dejstvo, da `b` vsebuje še polje `z` nas pri tem nič ne moti.

Zapišimo pravilo za podtipe zapisov, ki izhaja iz zgornjega razmisleka:

$$
\frac{
\text{za vsaj $j \leq m$ obstaja $i \leq n$, da je $\ell_i = k_j$ in $A_i = B_j$}
}{
\{ \ell_1 : A_1; \ldots; \ell_n : A_n \} \leq \{ k_1 : B_1; \ldots; k_m : B_m \}
}
$$

Povedano z besedami, prvi tip zapisa je podtip drugega, če se vsako polje $k_j :
B_j$ iz drugega zapisa pojavi v prvem. Tej vrsti podtipov pravimo **podtip zapisa
po širini**, ker je podtip »širši« (ima več polj) kot njegov podtip.

Velja torej:

$$
\{ z : \mathtt{float}; x : \mathtt{float}; y : \mathtt{float} \} \leq \{ x : \mathtt{float}; y : \mathtt{float} \}
$$

:::{admonition} Vaja

Ali obstaja tip zapisa, ki je podtip vseh ostalih tipov zapisov? Kaj
pa tip zapisa, ki je nadtip vseh ostalih tipov zapisov?

:::

### Podtipi zapisov v globino

Poznamo še **podtipe zapisov v globino**. Spet poglejmo primer, pri čemer
predpostavimo, da velja $\mathtt{int} \leq \mathtt{float}$. Zapis

$$
v = \{ x = 3; y = 5 \}
$$

ima tip $\{x : \mathtt{int}; y : \mathtt{int}\}$. Ali ga lahko uporabljamo, kot da bi imel tudi tip
$\{x : \mathtt{float}; y : \mathtt{float}\}$? Da, saj lahko njegovi komponenti $v.x$ in $v.y$
uporabljamo, kot da bi imeli tip $\mathtt{float}$, zahvaljujoč $\mathtt{int} \leq \mathtt{float}$.

Pravilo, za podtipe zapisov v globino se glasi:

$$
\frac{
A_1 \leq B_1 \quad
A_2 \leq B_2 \quad
\cdots \quad
A_n \leq B_n
}{
\{ \ell_1 : A_1; \ldots; \ell_n : A_n \} \leq \{ \ell_1 : B_1; \ldots; \ell_n : B_n \}
}
$$

Obe pravili, za širino in globino, lahko združimo v eno kombinirano pravilo:

$$
\frac{
\text{za vsak $j \leq m$ obstaja $i \leq n$, da je $\ell_i = k_j$ in $A_i \leq B_j$}
}{
\{ \ell_1 : A_1; \ldots; \ell_n : A_n \} \leq \{ k_1 : B_1; …; k_m : B_m \}
}
$$


### Zapisi s spremenljivimi polji

Katera pravila za podtipe zapisov pridejo v poštev, je odvisno od tega, kako
lahko zapise uporabljamo. Denimo, če imamo zapise s *spremenljivimi* polji, se
pravi, da lahko zapisu spremenjamo vrednosti polj, potem podtipi v globino niso
več veljavni. Na primer, če imamo tipa

```ocaml
A = { mutable x : int; mutable y : int}
```

in

```ocaml
B = { mutable x : float; mutable y : float}
```

potem *ne* velja `A ≤ B`. Če bi to veljalo, bi lahko v zapis `v : A` vrednost
polja `x` nastavili na `3.14`. Zapišimo tip `A` še v OCamlu:

```ocaml
type a = { mutable x : int; mutable y : int}
```

Takole naredimo vrednost in ji nastavimo atribut:

```ocaml
# let p = {x = 10; y = 20} ;;
val p : a = {x = 10; y = 20}
# p.x <- 42 ;;
- : unit = ()
# p ;;
- : a = {x = 42; y = 20}
```

### Problem koherentnosti

Težave nastopijo, če lahko vrednosti tipa $A$ pretvorimo v nadtip $B$ na več načinov, se pravi, če imamo

\begin{align*}
  A \leq B \\
  A \leq C \\
  B \leq D \\
  C \leq D
\end{align*}

Zaradi tranzitivnosti sledi $A \leq D$, kar lahko izpeljemo na *dva* načina:

1. $A \leq B \leq D$
2. $A \leq C \leq D$

To pa lahko vpliva na implicitne pretvorbe. Če imamo $e : A$, ga lahko pretvorimo
v $D$ preko pretvorb $A \to B \to D$ ali preko $A \to C \to D$. Kako vemo, da bomo obakrat
dobili isto? Temu pravimo problem koherentnosti. Pojavi se vedno, ko imamo
implicitna (ali samodejne) pretvorbe vrednosti iz enega tipa v drugega.


## Podtipi na nivoju struktur

Strukture ali moduli so v resnici neke vrste zapisi na višjem nivoju. Zanje veljajo
pravila za podtipe, kar preizkusimo na primerih.

:::{literalinclude} strukture.ml
:language: ocaml
:::
