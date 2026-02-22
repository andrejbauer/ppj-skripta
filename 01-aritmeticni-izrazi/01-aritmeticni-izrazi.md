# O programskih jezikih in aritmetičnih izrazih

V prvi lekciji bomo spoznali osnovni ustroj programskega jezika na primeru aritmetičnih izrazov. Ti pravzaprav niso samostojen splošen programski jezik, a lahko kljub temu z njimi ponazorimo osnovni pristop. Še prej pa povejmo nekaj besed o namenu predmeta.

## O programskih jezikih

Programski jeziki so eno od glavnih orodij v računalništvu.
Poznamo jih na tisoče, a samo peščica je takih, ki jih uporablja veliko število programerjev.
Pri tem predmetu se bomo učili **osnovne principe**, ki so podlaga za načrtovanje, implementacijo in delovanje programskih jezikov. S tem nimamo v mislih prevajalnikov, strojne kode ipd. (to snov pokrivajo drugi predmeti), ampak **matematične koncepte**, ki jih srečamo v programskih jezikih.

Osnovno vodilo načrtovanja programskega jezika je:

:::{important}
**Osnovni princip**

Programski jezik je orodje, ki programerju omogoča, da na čim bolj neposreden
način poda natančna navodila, kako naj računalnik opravi neko nalogo.
:::

Človek bi si mislil, da bi do zdaj že lahko iznašli »najboljši programski jezik«, a v resnici jih je na tisoče. Zakaj?

1. Ker se programski jeziki sproti prilagajajo razvoju računalniške tehnologije in
   potrebam programerjev.

2. Ker se razvijajo novi programerski koncepti in tehnike.

3. Ker niso vsi stili programiranja enako primerni za reševanje vseh nalog.

4. Ker nekateri radi vsak mesec naredijo nov programski jezik.


## Anatomija programskega jezika

Programski jezik je zasnovan kot sistem, ki ima naslednje komponente:

* **sintaksa:** pravila, kako se piše kodo, na primer: »vsak oklepaj mora imeti svoj zaklepaj«

* **statična semantika:** preverjanje, ali je program smiseln, na primer: »spremenljivka `i` ni
  nikjer deklarirana«

* **dinamična semantika:** kako se program izvede

* **denotacijska semantika:** matematični pomen programa

Programski jezik nima nujno vseh teh komponent, čeprav vsaj sintakso in dinamično semantiko vedno imamo. Opis jezika je lahko:

* **neformalen** dokument, napisan v naravnem jeziku, običajno zelo obsežen ([C++](https://www.iso.org/standard/79358.html) (cena: CHF 198), [Java](https://docs.oracle.com/javase/specs/), [Racket](https://docs.racket-lang.org/reference/index.html), [OCaml](https://ocaml.org/manual/), [Python](https://docs.python.org/3/reference/index.html), [Haskell](https://www.haskell.org/onlinereport/haskell2010/)) ali

* **formalne**: podana je matematična definicija ([Definition of Standard ML](https://smlfamily.github.io/sml90-defn.pdf)).

Pogosto je definicija jezika kombinacija obeh pristopov. **Implementacija** jezika je program, ki preverja sintakso in statično semantiko jezika ter omogoča izvajanje programov. To je lahko tolmač (angl. interpreter), prevajalnik (angl. compiler), oboje, ali pa kombinacija (glej [just-in-time compilation](https://en.wikipedia.org/wiki/Just-in-time_compilation)).

Pomemben del programskega jezika so tudi metode za **analizo programov**, s katerimi ugotavljamo lastnosti programa, in za **dokazovanje pravilnosti**, s katerimi dokazujemo, da ima program želene lastnosti.

## Sintaksa aritmetičnih izrazov

Začeli bomo z zelo preprostim programskim jezikom, ki je tako preprost, da ga v praksi sploh ne obravnavamo kot samostojen programski jezik. Obravnavajmo **celoštevilske aritmetične izraze**: cela števila, operaciji `*` in `+` ter spremenljivkami. To bi lahko bil majhen košček resnega programskega jezika.

Sintaksa pove, kakšne izraze in programe lahko pišemo v programskem jeziku.

### Konkretna sintaksa aritmetičnih izrazov

Programer zapiše program kot niz znakov, na primer:

```
"y + (5 + 7 * x) * 8"
```

Ta oblika je primerna za človeka, a ni primerna za obdelavo z računalnikom, saj ne odraža
strukture izraza. Zgornji izraz predstavimo z drevesom takole:

```
      +
     / \
    y   *
       / \
      +   8
     / \
    5   *
       / \
      7   x
```

Na ta način se znebimo presledkov in oklepajev in jasno ponazorimo strukturo izraza. Tudi programsko kodo lahko
predstavimo z drevesi. Ali znate razbrati program, ki ga predstavlja naslednje drevo?

```
     ;
    / \
  :=   \
 /  \   \
i    0   \
        while
       /     \
      <       \
     / \       \
    i  10       ;
               / \
              /   \
             /     \
           :=       \
          /  \     print
         i    +      |
             / \     i
            i   1
```

### Abstraktna sintaksa aritmetičnih izrazov

Izraze lahko opišemo s podatkovno strukturo drevo. To je oblika, primerna za obdelavo, ni
pa primerna za človeka.

Prednosti:

1. Iz drevesa je takoj razvidna struktura programa ali izraza.

2. Drevo ne vsebuje nepomembnih komponent (na primer presledkov in oklepajev).

Kako implementiramo drevesa, je odvisno od programskega jezika, ki ga uporabimo. V Javi se to seveda naredi z razredi.
Kasneje bomo spoznali še druge načine.


### Pravila sintakse

Pravila, ki opisujejo, kako tvorimo izraze ali drevesa, se imenujejo **pravila sintakse** (angl. syntax rules). Poznamo več načinov, kako podamo pravila, mi si bomo ogledali poenostavljeno verzijo t.i. [oblike BNF](https://en.wikipedia.org/wiki/Backus–Naur_form), ki jo pogosto srečamo v praksi:

```
⟨izraz⟩ ::= ⟨aditivni-izraz⟩ EOF
⟨aditivni-izraz⟩ ::= ⟨multiplikativni-izraz⟩ | ⟨aditivni-izraz⟩ + ⟨multiplikativni-izraz⟩
⟨multiplikativni-izraz⟩ ::= ⟨osnovni-izraz⟩ | ⟨multiplikativni-izraz⟩ * ⟨osnovni-izraz⟩
⟨osnovni-izraz⟩ ::= ⟨spremenljivka⟩ | ⟨številka⟩ | ( ⟨aditivni-izraz⟩ )
⟨spremenljivka⟩ ::= [a-zA-Z]+
⟨številka⟩ ::= -?[0-9]+
```

V trikotnih oklepajih `⟨⋯⟩` so zapisani **neterminalni simboli**. Vsak od njih ima svoje pravilo, ki pove, kako ga razčlenimo. Ostali simboli (`+`, `*`, `(`, `)`, in regularni izrazi, ki opisujejo spremenljivke in številke) so **osnovni** ali **terminalni simboli** (v teoriji formalnih jezikov razlikujemo med tema dvema pojmoma, a se mi s tem be bomo obremenjevali).

Pri opisu spremenljivk in številke smo uporabili **regularne izraze**: v oglatih oklepajih navedemo, kateri znaki so dovoljeni, znak `+` pa pomeni »ena ali več ponovitev«.

Glede na pravila, je dani izraz veljaven ali ne. Primeri:

* izraz `x * (5 + 8)` je veljaven
* izraz `x * + 5` je neveljaven
* izraz `1 * 2 + x` je veljaven

Ali bi lahko `1 * 2 + x` razčlenili kot »enica pomnožena z vsoto dvojke in `x`, se pravi `1 * (2 + x)`, glede na zgornja pravila?

### Iz konkretne v abstraktno sintakso

Konkretno sintakso predelamo v abstraktno sintakso s postopkomaa leksikalne in sintaksne analize:

* **leksikalna analiza:** niz razbijemoo na zaporedje podnizov, ki jih imenujemo **leksikalne enote** (angl. **lexemes**). Posamezne podnize predstavimo z 

* **sintaksna analiza** (angl. parsing): niz osnovnih simbolov razčlenimo v sintaksno drevo

Leksikalna analiza odstrani nebistvene znake, kot so presledki in prehodi v novo vrsto, pogosto tudi komentarje.

Za aritmetične izraze so leksikalni elementi in pripadajoči osnovni simboli:

* niz `+` in simbol `PLUS`
* niz `*` in simbol `KRAT`
* spremenljivka, opisana z regularnim izrazom `[a-zA-Z]+` in simbol `SPREMENLJIVKA(x)`, kjer je `x` niz
* številka, opisana z regularnim izrazom `-?[0-9]+` in simbol `ŠTEVILKA(n)`, kjer je `n` število
* niz `(` in simbol `OKLEPAJ`
* niz `)` in simbol `ZAKLEPAJ`
* `EOF` poseben gradnik, ki pomeni »konec«

Primer: `foo * (5 + 42)` nam da leksikalnih elementov
```
"foo", "*", "(", "5", "+", "42", ")"
```
s pripadajočim nizom osnovnih simbolov
```
SPREMENLJIVKA("foo") KRAT OKLEPAJ ŠTEVILKA(5) PLUS ŠTEVILKA(42) ZAKLEPAJ EOF
```
Ta niz nam da ustrezno drevo.

Primer: `x * ((5 + 8` nam da niz leksikalnih elementov
```
"x", "*", "(", "(", "5", "+", "8"
```
s pripadajočim nizom osnovnih simbolov
```
SPREMENLJIVKA(x) KRAT OKLEPAJ OKLEPAJ ŠTEVILKA(5) PLUS ŠTEVILKA(8)
```
Ta niz ni veljaven in ne določa drevesa. Javimo sintaktično napako.

Zakaj ločimo med leksikalnim elementom in osnovnim simbolom? Na primer, zakaj je treba imeti `*` in `KRAT`? Iz vsaj dveh razlogov:

1. Morda želimo imeti več različnih znakov za množenje `*`, `×` in `·`, ki jih vse predstavimo z istim osnovnim simbolom, saj vsi predstavljajo isto enoto v abstraktni sintaksi
2. Osnovne simbole naštejemo (na primer kot algebraični tip, to bomo še spoznali) v kodi, da prevajalnik točno ve, kateri simboli se lahko pojavijo. Če bi uporabljali nize, nas prevajalnik ne more opozoriti na morebitne tipkarske napake v kodi. Konkretno, če preverjamo `if (simbol == KART) then ...`, bo prevajalnik javil napako, saj ne ve, kaj je `KART`. Če bi preverjali neposredno nize z `if (simbol = "**") then ...`, prevajalnik ne bi vedel, da smo se zatipkali in da bi moralo pisati `*`.

Na vajah boste spoznali **sitnaksni analizator** (angl. parser) za aritmetične izraze, implementiran v Javi. Običajno pa razčlenjevalnika ne implementiramo z golimi rokami, ker je to precej zamudno, ampak uporabimo **sintaksni generator** - program, ki sprejme slovnična pravila in iz njih naredi sintaksni analizator (primer takega opisa za [aritmetične izraze](https://github.com/andrejbauer/plzoo/blob/master/src/calc/parser.mly) v OCamlu).


### Iz abstraktne v konkretno sintakso

Pretvorba abstraktne sintakse v konkretno je preprosta, saj le obidemo sintaktično drevo in zgradimo ustrezni niz. Pojavi se vprašanje, kako vstaviti oklepaje, na katerega boste odgovorili na vajah.


## Operacijska semantika

Kakšen je postopek, s katerim izračunamo vrednost izraza? Podali bomo dva osnovna načina.

Ko računamo vrednost izraza, moramo poznati vrednosti spremenljivk. Preslikavi, ki spremenljivke slika v njihove vrednosti, pravimo **okolje** (angl. environment). Na primer, če ima `x` vrednost `3`, `y` vrednost `7` in `z` vrednost `10`, to predstavimo z okoljem

```
[x ↦ 3, y ↦ 7, z ↦ 10]
```

### Semantika velikih korakov

Semantika velikih korakov se imenuje tako, ker iz izraza (abstraktnega drevesa) dobimo njegovo vrednost (število) v enem »velikem« koraku. Predstavimo jo z relacijo

```
η | e ↪ n
```

kjer je `η` okolje, `e` je izraz in `n` celo število. Zgornji izraz preberemo takole:
»V okolju `η` se izraz `e` evalvira v število `n`.«

Na primer, pričakujemo, da velja

```
[x ↦ 3, y ↦ 2, z ↦ 5] | x + 2 * y ↪ 7
```

Pravila za računanje izrazov podamo kot **pravila sklepanja**. Pravilo sklepanja zapišemo takole:

```
P₁ P₂ ⋯ Pᵢ
----------
    S
```

To preberemo: Če smo že dokazali predpostavke `P₁, P₂, ⋯, Pᵢ` , potem sledi tudi sklep `S`.

Na primer:

```
x > 0      y < 0
----------------
    x · y < 0
```

Preberemo: »če je `x` pozitiven in `y` negativen, potem je `x · y` negativen.«

Lahko se zgodi, da pravilo nima predpostavk:

```
--------
   S
```

Takemu pravilu pravimo tudi **aksiom**, saj pove da `S` velja. Primer aksioma je
zakon refleksivnosti za enakost:

```
-----
x = x
```

Podajmo pravila za semantiko velikih korakov, pri čemer uporabimo oznake:

* `η` je okolje
* `n` je število
* `e`, `e₁`, ... so izrazi

Pravila:

```
η(x) = n
----------
 η | x ↪ n

---------
η | n ↪ n

 η | e₁ ↪ n₁     η | e₂ ↪ n₂    n₁ · n₂ = n
------------------------------------------
             η | e₁ * e₂ ↪ n

 η | e₁ ↪ n₁     η | e₂ ↪ n₂    n₁ + n₂ = n
------------------------------------------
             η | e₁ + e₂ ↪ n
```

Pozor, v pravilu za seštevanje znak `+` nad črto pomeni matematično operacijo seštevanje,
pod črto pa je to del sintakse aritmetičnih izrazov, se pravi `+` je samo simbol v izrazu. Pri pravilu za množenje te težave nismo imeli, ker smo matematično množenje označili z `·`, množenje kot simbol pa z `*`.


### Semantika malih korakov

Semantika velikih korakov deluje hierarhično: najprej izračunamo vrednosti podizrazov in nato vrednost celotnega izraza. V šoli pa otroke učimo, da se računa »po korakih«, se pravi, da opravimo eno operacijo naenkrat. Tak postopek se imenuje **semantika malih korakov**. Podamo jo z relacijo (pozor, puščico `↪` smo spremenili v puščico `↦`)

```
η | e ↦ e'
```

ki pove, kako naredimo en osnovni korak v računanju.
Pravila se glasijo:

```
 η(x) = n
----------
η | x ↦ n


      η | e₁ ↦ e₁'
----------------------
η | e₁ + e₂ ↦ e₁' + e₂


      η | e₂ ↦ e₂'
----------------------
η | n₁ + e₂ ↦ n₁ + e₂'


  n₁ + n₂ = n
---------------
 η | n₁ + n₂ ↦ n


      η | e₁ ↦ e₁'
----------------------
η | e₁ * e₂ ↦ e₁' * e₂


      η | e₂ ↦ e₂'
----------------------
η | n₁ * e₂ ↦ n₁ * e₂'


  n₁ · n₂ = n
-----------------
 η | n₁ * n₂ ↦ n
```

:::{tip}
**Primer**

V okolju `[x ↦ 3, y ↦ 2, z ↦ 5]` izračunamo `x + 2 * y`:

```
x + 2 * y  ↦
3 + 2 * y  ↦
3 + 2 * 2  ↦
3 + 4      ↦
7
```
:::

Pravila ne dopuščajo nobene svobode pri računanju. Na primer, če želimo izračunati

```
[] | 2 * 3 + 5 * 6
```

potem *moramo* naprej izračunati `2 * 3`, da dobimo `6 + 5 * 6` in šele nato `5 * 6`, da dobimo `6 + 30`. Ugotovite, zakaj je tako.

:::{tip}
**Primer**

Izvajanje se lahko tudi zatakne, na primer, če spremenljivka nima vrednosti:

```
[x ↦ 3]  |  x + 2 * y  ↦  3 + 2 * y
```

Naslednjega koraka ni, ker ne moremo uporabiti nobenega od pravil, ki so na voljo.
:::
