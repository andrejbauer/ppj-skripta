# Ukazni programski jezik

Spoznali smo aritmetične izraze s spremenljivkami. Spremenljivke smo obravnavali
po mačehovsko, saj se jim ni dalo nastavljati vrednosti in ni bilo možno definirati novih spremenljivk.

V tej lekciji bomo spoznali ukazni programski jezik, ki ima prave spremenljivke,
pogojne stavke in zanko `while`.

Po vrsti bomo obravnavali:

* sintakso jezika
* operacijsko semantiko: kako se jezik izvaja
* denotacijsko semantiko: kaj je matematični pomen jezika
* prevajalnik v poenostavljeno strojno kodo

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
primer, dodati bi morali še pravila za pisanje oklepajev in pojasniti, kako se naredi leksično analizo (kakšna so
pravila za presledke, nove vrste, komentarje ipd.)

:::{admonition} Primer
Program, ki sešteje števila od `1` do `100` in rezultat shrani v `s`:

```
s := 0;
i := 0;
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
omenimo [Wadlerjev zakon](https://wiki.haskell.org/Wadler's_Law).


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

:::{admonition} Primer
Če je `η = [x ↦ 10, y ↦ 5]`, potem je `η[x↦20]` enako `[x ↦ 20, y ↦ 5]`.
:::

### Semantika malih korakov

#### Operacijska semantika aritmetičnih in boolovih izrazov

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

:::{admonition} Vaja
Dodajte pravila za `=`, s katerim primerjamo dve celi števili in dobimo boolovo vrednost.
:::


:::{admonition} Vaja
Ko računamo boolove vrednosti, imamo pri računanju `b₁ and b₂` izbiro:

1. Izračunamo `b₁` *in* `b₂` in nato vrednost `b₁ and b₂`
2. Najprej izračunamo `b₁`. Če dobimo `false`, je vrednost `b₁ and b₂` enaka `false`
   ne glede na `b₂`, zato ga ne izračunamo.

Zgoraj smo uporabili drugo možnost. (Kako se to razbere iz pravil?) Podajte še pravila za prvo možnost.
:::

#### Operacijska semantika ukazov

Semantika malih korakov je podana z dvema relacijama:

* relacija `(η, c) ↦ η'` pomeni: v okolju `η` ukaz `c` v enem koraku konča v okolju `η'`.
* relacija `(η, c) ↦ (η', c')`: v okolju `η` ukaz `c` c enem koraku spremeni okolje v `η'`
  in se nadaljuje z ukazom `c'`.

Relaciji sta določeni z naslednjimi pravili:

```
—–————————————–
(η, skip)  ↦  η


       η | e ↪ n
————————————––—————————–
(η, (x := e))  ↦  η[x↦n]


       (η, c₁) ↦ (η', c₁')
—————————————––—————————–——————————
(η, (c₁ ; c₂))  ↦  (η', (c₁' ; c₂))


          (η, c₁) ↦ η'
—————————————––—————————–——————————
   (η, (c₁ ; c₂))  ↦  (η', c₂)


             η | b ↪ true
———————————————————————–—————————————————
(η, (if b then c₁ else c₂ end)) ↦ (η, c₁)


             η | b ↪ false
———————————————————————–—————————————————
(η, (if b then c₁ else c₂ end)) ↦ (η, c₂)


      η | b ↪ false
———————————––—————————–——————
(η, (while b do c done)) ↦ η


                      η | b ↪ true
—————————————––—————————–—————————–——————————————————————-
 (η, (while b do c done))  ↦ (η, (c ; while b do c done))
```



## Denotacijska semantika

Povejmo nekaj še o **denotacijski semantiki**, to je o matematičnem pomenu programov.

Kaj je matematični pomen posameznih komponent programa?

* pomen aritmetičnega izraza `e` je neko **celo število** `⟦ e ⟧ ∈ ℤ`
* pomen boolovega izraza `b` je neka **resničnostna vrednost** `⟦ b ⟧ ∈ {⊥, ⊤}`.
* pomen programa `c` je nekaj **preslikava** `⟦ c ⟧ : Env → Env` iz okolij v okolja.

Kot je v navadi v denotacijski semantiki, smo z dvojnimi oglatimi oklepaji označili matematični pomen.

Na primer, matematični pomen aritmetičnega izraza je celo število. Ko zapišemo

```
⟦ 42 ⟧ = 42
```

s tem povemo, da je pomen *niza znakov* `"42"` število, ki mu po slovensko rečemo
»dvainštirideset«. Podobno podamo pomen znaka `+` z enačbo:

```
⟦ e₁ + e₂ ⟧ = ⟦ e₁ ⟧ + ⟦ e₂ ⟧
```

To pomeni, da je pomen *izraza* oblike `e₁ + e₂` (plus v oklepajih) enak *vsoti* (plus
kot matematična operacija) pomenov podizrazov `e₁` in `e₂`.

### Pomen aritmetičnih in boolovih izrazov

Če smo povsem natančni, je pomen aritmetičnega izraza `e` neka preslikava `⟦ e ⟧ : Env → ℤ`, saj se lahko v izrazu `e` pojavljajo spremenljivke.

```
⟦ x ⟧(η) = η(x)
⟦ k ⟧(η) = k
⟦ e₁ + e₂ ⟧(η) = ⟦ e₁ ⟧(η) + ⟦ e₂ ⟧(η)
⟦ e₁ * e₂ ⟧(η) = ⟦ e₁ ⟧(η) · ⟦ e₂ ⟧(η)
```

Podobno je pomen boolovega izraza `b` preslikava `⟦ b ⟧ : Env → {⊥, ⊤}`:

```
⟦false⟧(η) = ⊥
⟦true⟧(η) = ⊤
⟦ b₁ and b₂ ⟧(η) = ⟦b₁⟧(η) ∧ ⟦b₂⟧(η)
⟦ b₁ or b₂ ⟧(η) = ⟦b₁⟧(η) ∨ ⟦b₂⟧(η)
⟦ not b ⟧(η) = ¬ ⟦b⟧(η)
⟦ e₁ = e₂ ⟧(η) = (⟦e₁](η) = ⟦e₂⟧(η)
⟦ e₁ < e₂ ⟧(η) = (⟦e₁](η) < ⟦e₂⟧(η)
```

Ali razumete zadnji dve vrstici definicije?

### Pomen programov

Pomen programa `e` v ukaznem jeziku funkcija, ki slika okolja v okolja:

```
⟦ e ⟧ : Env → Env
```

Tu je `Env` množica vseh okolij. Pomen definiramo takole, kjer smo predpostavili, da smo že definirali matematični pomen aritmetičnih in boolovih izrazov:

```
⟦ skip ⟧(η)                = η
⟦ x := e ⟧(η)              = η⟦x ↦ ⟦e⟧(η)⟧
⟦ c₁ ; c₂ ⟧(η)             = ⟦c₂⟧(⟦c₁⟧(η))
⟦ if b then c₁ else c₂⟧(η) = ⟦c₁⟧(η)        če ⟦b⟧(η) = ⊤
⟦ if b then c₁ else c₂⟧(η) = ⟦c₂⟧(η)        če ⟦b⟧(η) = ⊥
⟦ while b do c ⟧(η)        = ?
```

Pomen zanke `while` ni očiten in ga bomo na tem mestu preskočili. Bi znali predlagati definicijo?

## Ekvivalenca programov

Programa sta ekvivalenta, če se v vseh kontekstih obnašata enako. To pomeni, da lahko
vedno enega zamenjamo z drugim.

Natančneje, **evalvacijski kontekst** `C[ ]` je del programske kode `C`, ki ima »luknjo« `[ ]`.
Programska koda `A` je **ekvivalentna** programski kodi `B`, če za *vse* kontekste `C[ ]` velja,
da imata `C[A]` in `C[B]` enak rezultata in enako spreminjata okolje.

:::{admonition} Primer
Programa

```
x := x + 1 ;
x := x + 2
```

in

```
x := x + 3
```

sta ekvivalentna.
:::

:::{admonition} Primer
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

:::{admonition} Naloga
Ugotovite, ali je program, ki sešteje prvih 100 števil

```
i := 1 ;
s := 0 ;
while i < 101 do
  s := s + i ;
  i := i + 1
done
```

ekvivalentne programu

```
s := 5050
```

:::

(Odgovor: nista ekvivalentna, ker drugi program ne nastavi vrednosti `i`. Ekvivalentno bi bilo `i := 101 ; s := 5050`.)


## Prevajalnik

Implementiramo prevajalnik v strojno kodo. Ogledali si bomo implementacijo v
OCamlu, glej programski jezik [comm](http://plzoo.andrej.com/language/comm.html) v [Programming Languages Zoo](http://plzoo.andrej.com/).
Implementirana je razširjena različica jezika, ki ima še ukaz za izpisovanje na zaslon in lokalne spremenljivke.

Jezik `comm` vsebuje naslednje komponente:

* aritmetične in boolove izraze
* spremenljivke
   * deklaracija nove lokalne spremenljivke `let x := e in c`
   * nastavljanje vrednosti `x := e`
* pogojni stavek `if b then c₁ else c₂ done`
* zanka `while b do c done`
* ukaz `skip`
* sestavljani ukaz `c₁ ; c₂`
* ukaz `print e`

Ogledamo si sestavne dele implementacije:

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

