# Ukazni programski jezik

Spoznali smo aritmetične izraze s spremenljivkami. Spremenljivke smo obravnavali
po mačehovsko, saj se jim ni dalo nastavljati vrednosti in ni bilo možno definirati novih spremenljivk.

V tej lekciji bomo spoznali ukazni programski jezik, ki ima prave spremenljivke,
pogojne stavke in zanke.

Po vrsti bomo obravnavali:

* sintaksa jezika
* operacijska semantika – kako se jezik izvaja
* ekvivalenca programov – kaj pomeni, da sta dva programa ekvivalentna?
* denotacijska semantika - kaj je matematični pomen programa?
* prevajalnik v strojno kodo

## Sintaksa

V prejšnji lekciji smo spoznali aritmetične izraze. Dodali bomo še boolove izraze in
ukaze. Podajmo abstraktna sintaksa jezika:

```
⟨aritmetični-izraz⟩ ::=
  ⟨spremenljivka⟩ |
  ⟨številka⟩
  ⟨aritmetični-izraz⟩ + ⟨aritmetični-izraz⟩ |
  ⟨aritmetični-izraz⟩ * ⟨aritmetični-izraz⟩

⟨boolov-izraz⟩ ::=
   true | false |
   ⟨aritmetični-izraz⟩ = ⟨aritmetični-izraz⟩ |
   ⟨aritmetični-izraz⟩ < ⟨aritmetični-izraz⟩ |
   ⟨boolov-izraz⟩ and ⟨boolov-izraz⟩ |
   ⟨boolov-izraz⟩ or ⟨boolov-izraz⟩ |
   not ⟨boolov-izraz⟩

⟨ukaz⟩ ::=
   skip |
   ⟨spremenljivka⟩ := ⟨aritmetični-izraz⟩ |
   ⟨ukaz⟩ ; ⟨ukaz⟩ |
   while ⟨boolov-izraz⟩ do ⟨ukaz⟩ done |
   if ⟨boolov-izraz⟩ then ⟨ukaz⟩ else ⟨ukaz⟩ end
```

Da bi iz zgornjih pravil dobili konkretno sintakso, moramo podati še informacijo o prioriteti in asociativnosti operatorjev.
Naštejmo operatorje od nižje do višje prioritete:

* `;` (levo)
* `or` (levo)
* `and` (levo)
* `not`
* `<`, `=`
* `+` (levo)
* `*` (levo)

Na primer, `or` je levo asociativen in ima prednost pred `;`. To še vedno ni dovolj za povsem konkretno sintakso, na
primer, dodati bi morali še pravila za pisanje oklepajev in pojasniti, kako se naredi leksikalno analizo (kakšna so
pravila za presledke, nove vrste, komentarje ipd.)

:::{tip}
**Primer**

Program, ki sešteje števila od `1` do `100` in rezultat shrani v `s`:

```none
s := 0 ;
i := 0 ;
while i < 101 do
  s := s + i;
  i := i + 1
done
```

Zgornji program bi lahko zapisali v Javi takole:

```java
s = 0 ;
i = 0 ;
while (i < 101) {
  s = s + i ;
  i = i + 1 ;
}
```

Abstraktna sintaksa obeh programov je enaka (vaja: narišite drevo, ki
predstavlja ta program).

:::

Tu in v nadaljevanju se ne bomo preveč posvečali podrobnostim konkretne sintakse.
To *ne* pomeni, da je konkretna sintaksa nepomembna v praksi; navsezadnje so se
pripravljeni programerji skregati že zaradi zamikanja kode. V zvezi s tem
omenimo [Wadlerjev zakon](https://wiki.haskell.org/Wadler's_Law). Priporočamo tudi,
da si lahko ogleda implementacijo sintakse jezika [`comm`](https://plzoo.andrej.com/language/comm.html)
v [PL Zoo](https://plzoo.andrej.com).

## Operacijska semantika

Sedaj nadgradimo operacijsko semantiko izrazov še s pravili za boolove izraze in
ukaze. Še vedno imamo okolje `η`, ki spremenljivkam priredi njihove vrednosti,
na primer

```
η = [x ↦ 4, y ↦ 10, u ↦ 1]
```

V našem jeziku bomo spremenljivke vedno hranile samo cela števila. Ker jim bomo tudi nastavljali vrednosti, potrebujemo
ustrezno operacijo, s katero to naredimo. Če je `η` okolje, `x` spremenljivka in `n` celo število, potem zapis

```
η [x ↦ n]
```

pomeni okolje `η`, v katerem je vrednost `x` nastavljena na `n`.

:::{tip}
**Primer**

Če je `η = [x ↦ 10, y ↦ 5]`, potem je `η[x ↦ 20]` enako `[x ↦ 20, y ↦ 5]`.
:::

### Operacijska semantika aritmetičnih in boolovih izrazov

Pravila za aritmetične izraze smo že spoznali zapišimo jih še enkrat:

```
—————————-
η | n ↪ n


 η(x) = n
————————––
η | x ↪ n

η | e₁ ↪ n₁     η | e₂ ↪ n₂
———————————————————————–———
 η | e₁ + e₂ ↪ n₁ + n₂


η | e₁ ↪ n₁     η | e₂ ↪ n₂
———————————————————————–———
 η | e₁ - e₂ ↪ n₁ - n₂


η | e₁ ↪ n₁     η | e₂ ↪ n₂
———————————————————————–———
 η | e₁ * e₂ ↪ n₁ · n₂
```

Tudi Boolovi izrazi ne predstavljajo večje težave:

```
————————————————
 η | true ↪ true


————————————————–
η | false ↪ false


   η | b ↪ false
 ————————-––-—————
 η | not b ↪ true


    η | b ↪ true
 —————————————————–
 η | not b ↪ false


     η | b₁ ↪ false
———————————-–—————————–
 η | b₁ and b₂ ↪ false


 η | b₁ ↪ true     η | b₂ ↪ v₂
––———————————————————————————–
     η | b₁ and b₂ ↪ v₂


   η | b₁ ↪ true
————————————————————–
 η | b₁ or b₂ ↪ true


η | b₁ ↪ false     η | b₂ ↪ v₂
—————————————————————————————–
     η | b₁ or b₂ ↪ v₂


η | e₁ ↪ n₁    η | e₂ ↪ n₂     n₁ < n₂
————————————————————–—————————————————
        η | e₁ < e₂ ↪ true


η | e₁ ↪ n₁   η | e₂ ↪ n₂    n₁ ≥ n₂
————————————————————–———————————————
      η | e₁ < e₂ ↪ false
```

Ko računamo boolove vrednosti, imamo pri računanju `b₁ and b₂` izbiro:

1. **Polno vrednotenje:** (angl. complete evaluation): vedno izračunamo `b₁` *in* `b₂` in nato vrednost `b₁ and b₂`
2. **Kratkostično vrednotenje** (angl. short-circuit evaluation): najprej izračunamo samo `b₁`. Če dobimo `false`, je vrednost `b₁ and b₂` enaka `false`
   ne glede na `b₂`, zato ga ne izračunamo. Če je vrednost `b₁` enaka `true`, izračunamo še `b₂`.

Zgoraj smo uporabili kratkostično vrednotenje.

:::{attention}
**Naloga**

1. Kako se iz zgoraj podanih pravil vidi, da se `b₁ and b₂` vrednoti kratkostično?
2. Podajte pravilo za polno vrednotenje `b₁ and b₂`.
3. Ali ima tudi `b₁ or b₂` polno in kratkostično vrednotenje?
4. Podajte primer iz programerske prakse, kjer je pomembno, da vrednotimo boolove izraze kratkostično.
:::

:::{attention}
**Naloga**

Dodajte pravila za enakost celih števil `==`.
:::


### Operacijska semantika ukazov

Semantika malih korakov za ukaze je podana z relacijo
```
(η, c) ↦ (η', c')`
```
ki jo preberemo: »v okolju `η` ukaz `c` v enem koraku spremeni okolje v `η'` in se nadaljuje z ukazom `c'`«.

Relacija je določena z naslednjimi pravili:

```
       η | e ↪ n
————————————––—————————–––––––––
(η, (x := e))  ↦  (η[x↦n], skip)


       (η, c₁) ↦ (η', c₁')
—————————————––—————————–——————————
(η, (c₁ ; c₂))  ↦  (η', (c₁' ; c₂))


———————————————––—————————–——————————
   (η, (skip ; c₂))  ↦  (η, c₂)


             η | b ↪ true
———————————————————————–—————————————————
(η, (if b then c₁ else c₂ end)) ↦ (η, c₁)


             η | b ↪ false
———————————————————————–—————————————————
(η, (if b then c₁ else c₂ end)) ↦ (η, c₂)


      η | b ↪ false
———————————––—————————–—————————————
(η, (while b do c done)) ↦ (η, skip)


                      η | b ↪ true
—————————————––—————————–—————————–——————————————————————-
 (η, (while b do c done))  ↦ (η, (c ; while b do c done))
```

Pravila določajo, kako se ukaz `c₁` v okolju `η₁` izvaja kot zaporedje korakov
```
(η₁, c₁) ↦ (η₂, c₂) ↦ (η₃, c₃) ↦ ⋯
``` 
Zaporedje se lahko nadaljuje v nedogled ali pa se ustavi pri ukazu `skip`, saj je to edini ukaz, ki nima naslednjega koraka.

:::{tip}
**Primer**

V okolju `[x ↦ 3, y ↦ 10]` izvedemo ukaz
```
x := y + 2 ; if x < 8 then y := 0 else y := 1 end
```
takole:
```
( [x ↦  3, y ↦ 10],   x := y + 2 ; if x < 8 then y := 0 else y := 1 end ) ↦
( [x ↦ 12, y ↦ 10],   skip ; if x < 8 then y := 0 else y := 1 end       ) ↦
( [x ↦ 12, y ↦ 10],   if x < 8 then y := 0 else y := 1 end              ) ↦
( [x ↦ 12, y ↦ 10],   y := 1                                            ) ↦
( [x ↦ 12, y ↦  1],   skip)
```

:::


:::{attention}
**Naloga**

Podajte čim bolj preprost program, ki se izvaja v nedogled.

:::



## Ekvivalenca programov

Pravimo, dasta dva ukaza ekvivalentna, če se v vseh pogledih obnašata enako. To pomeni, da lahko vedno enega zamenjamo z drugim. Kako bi to razložili natančneje?

Najprej definiramo **evalvacijski kontekst**, to je del programske kode z »luknjo«, v katero lahko vstavimo kodo, označimo ga z  `C[ ]`, kjer `[ ]` predstavlja luknjo. Če v `C[ ]` vstavimo kodo `A`, dobimo kodo `C[A]`.

:::{tip}
**Primer**

Naj bo `C[ ]` evalvacijski kontekst:

```
while i < n do
  i := i + 1 ;
  [ ]
done
```
Tedaj je `C[s := s + i ; p := p * s]` koda
```
while i < n do
  i := i + 1 ;
  s := s + i ;
  p := p * s
done
```
:::

:::{important}
**Definicija**

Programska koda `A` je **ekvivalentna** programski kodi `B`, če za *vse* evalvacijske kontekste `C[ ]` velja, da imata `C[A]` in `C[B]` enak rezultata in enako spreminjata okolje.

:::

:::{tip}
**Primer**

Programa
```
x := x + 1 ;
x := x + 2
```
in
```
x := x + 3
```
sta ekvivalentna. Kako bi to dokazali?
:::

:::{tip}
**Primer**

Programa
```
x := x + 1 ;
x := x + 2
```
in
```
y := y + 3
```
*nista* ekvivalentna, saj ju lahko razločimo s kontekstom in okoljem `η = [x ↦ 0, y ↦ 0]`.
```
x := 0 ;
y := 0 ;
[ ]
```
Če vstavimo v luknjo prvi program, bo okolje spremenil v `[x ↦ 3, y ↦ 0]`, drugi pa v `[x ↦ 0, y ↦ 3]`.
:::

:::{attention}
**Naloga**

Ugotovite, ali je program, ki sešteje prvih 100 števil

```none
i := 1 ;
s := 0 ;
while i < 101 do
  s := s + i ;
  i := i + 1
done
```

ekvivalentne programu

```none
s := 5050
```

:::


## Prevajalnik

Implementirajmo prevajalnik za ukazni programski jezik. Zlgedovali se bomo po prevajalniku za
[comm](http://plzoo.andrej.com/language/comm.html) v [Programming Languages Zoo](http://plzoo.andrej.com/),
ki je razširitev ukaznega jezika, ki smo ga obravnavali do sedaj.

Jezik `comm` podpira:

* aritmetične in boolove izraze
* spremenljivke
   * deklaracija nove lokalne spremenljivke `let x := e in c`
   * nastavljanje vrednosti `x := e`
* pogojni stavek `if b then c₁ else c₂ done`
* zanka `while b do c done`
* ukaz `skip`
* sestavljeni ukaz `c₁ ; c₂`
* ukaz `print e`

Ukaz `print e` ni presenetljiv, saj le na zaslon izpiše vrednost izraza `e`.

Bolj zanimiv je ukaz `let x := e in c`, s katerim deklariramo spremenljivko `x` z začetno vrednostjo `e`, ki je veljavna v ukazu `c`.
Na primer, ukaz

```
let i := 1 in
let s := 0 in
  while i < 100 do
    let j := i * s in
    i := i + 1 ;
    s := s + j
  done
```

bi v Javi zapisali kot blok

```java
{
   int i = 1 ;
   int s = 0 ;
   while (i < 100) {
      int j = i * s ;
      i = i + 1 ;
      s = s + j
   }
}
```

:::{attention}
**Naloga**

Ukaz `let x := e in c` programernja prisili, da novo spremenjivko inicializira, kar pomeni, da mora podati njeno začetno vrednost.
Mnogi programski jeziki dopuščajo deklaracijo nove spremenljivke tako, da ni treba podati njene začetne vrednosti.

1. Kaj dopušča Java?
2. Kakšne prednosti ima jezik, ki programerja sili v inicializacijo spremenljivk?
3. Kakšne prednosti ima jezik, ki dopušča neinicializirane spremenljivke?

:::

### Strojni jezik

Ukaze bomo prevajali v strojni jezik za preprost procesor. Vsa aritmetična in logična obdelava podatkov poteka na **skladu**, trajnejše vrednosti so v **RAM-u**, potek izvajanja pa vodi **števec ukazov**. 

Arhitektura stroja sestoji iz:

*   **Program**: tabela ukazov, ki naj jih stroj izvaja (opisani so spodaj)
*   **Pomnilnik RAM**: tabela celih števil (`int`), dostop po indeksih
*   **Števec ukazov (`cp`)**: indeks trenutno izvajajočega se ukaza v programu.
*   **Kazalec na sklad (`sp`)**: sklad je shranjen v RAM in raste navzdol. Vrh sklada je na naslovu, na katerega kaže `sp`.
*   **Logične vrednosti**: `0` pomeni neresnica, vsak neničelni `int` pomeni resnica.
*   **Vhod/izhod**: ukaz `PRINT` izpiše celo število z vrha sklada.

Ob inicializaciji: RAM je zapolnjen z ničlami, `pc = 0`, `sp = ram_size - 1`. Sklad je torej sprva prazen.

Stroj izvaja program v zanki: prebere navodilo na naslovu `pc`, ga izvede, nato se `pc` običajno poveča za `1`. Izjema so skoki:

*   **relativni skoki** (`JMP k`, `JMPZ k`) popravijo `pc` z relatvnim odmikom `k`, nato glavni cikel `pc` še poveča za `1`. Efektivni cilj izvedenega skoka je zato `pc + k + 1` glede na začetni `pc` ukaza skoka.
*   `JMPZ` pred odločitvijo porabi (pop) vrh sklada in skoči le, če je ta vrednost `0`.

Vsi aritmetični in logični ukazi delujejo na vrhu sklada. Binarne operacije vedno vzamejo najprej `y = pop`, nato `x = pop`, izračunajo rezultat `x ∘ y` in ga potisnejo nazaj (`push`). Unarne operacije vzamejo en `pop` in vrnejo en `push`.

Ukazni nabor stroja:

*   `NOOP` — ne naredi ničesar (niti sklada niti `pc` ne spremeni).
*   `SET k` — vzemi `a = pop` in zapiši `a` v RAM na naslov `k`.
*   `GET k` — preberi RAM na naslovu `k` in prebrano potisni na sklad.
*   `PUSH c` — potisni celoštevilsko konstanto `c` na sklad.
*   `ADD` — `x + y`.
*   `SUB` — `x - y`.
*   `MUL` — `x * y`.
*   `DIV` — `x / y`; če je `y = 0`, sproži napako *division by zero*.
*   `MOD` — `x mod y`; če je `y = 0`, sproži napako *division by zero*.
*   `EQ` — vrne `1`, če `x = y`, sicer `0`.
*   `LT` — vrne `1`, če `x < y`, sicer `0`.
*   `AND` — logična konjunkcija: `1` iff (`x ≠ 0` in `y ≠ 0`), sicer `0`.
*   `OR` — logična disjunkcija: `1` iff (`x ≠ 0` ali `y ≠ 0`), sicer `0`.
*   `NOT` — logična negacija vrha sklada: neničelen → `0`, `0` → `1`.
*   `JMP k` — relativni skok z odmikom `k` (glej razdelek o skokih).
*   `JMPZ k` — relativni pogojni skok: vzemi `a = pop`; če je `a = 0`, skoči z odmikom `k`.
*   `PRINT` — `a = pop`; izpiši `a` na standardni izhod.

Stroj lahko med izvajanjem sproži izjemo:

*   **`Illegal_address`** — poskus branja ali pisanja izven meja RAM-a.
*   **`Zero_division`** — deljenje ali ostanek z ničelnim deliteljem (`DIV`, `MOD`).
*   **`Illegal_instruction`** — rezervirano za neveljavna navodila (v dani različici je definirano, a se ne sproža).

Opomba: model je namerno minimalen — ni preverjanja prepolnitve/podpraznjenja sklada (push/pop lahko trčita izven dovoljenega območja RAM-a, kar se izrazi kot `Illegal_address`).

### Implementacija v OCamlu

Podrobneje si oglejmo implementacijo `comm` v OCAmlu. Še posebej nas zanima, kako deluje prevajalnik.

* abstraktna sintaksa je definirana s podatkovnimi tipi v `syntax.ml`
* konkretna sintaksa je opisana v `lexer.mll` in `parser.mly`; uporabimo generator parserjev Menhir
* preprost simulator procesorja z RAM in skladom najdemo v `machine.ml`
* prevajalnik iz `comm` v strojni jezik je v `compile.ml`
* glavni program je v `comm.ml`

Prevajalnik neposredno pretvori program v strojno kodo, ker je `comm` zelo preprost jezik. Prevajanje pravih programskih jezikov poteka preko več stopenj, z vmesnimi jeziki. Vsak naslednji jezik je nekoliko bolj preprost in bližje strojni kodi.


### Primeri

Na primerih preizkusimo, kako se prevajajo programi in kako hitro delujejo.

`comm`:

:::{literalinclude} benchmark/bench.comm
:::

`Python`:

:::{literalinclude} benchmark/bench.py
:language: python
:::

`C`:

:::{literalinclude} benchmark/bench.c
:language: c
:::

Rezultati zelo nestrokovno izvedene meritve, ki ji ne moremo zaupati:

|Programski jezik|Čas (s)|
|---------------:|------:|
|C               |`0.22` |
|Python          |`16.73`|
|comm            |`44.88`|
