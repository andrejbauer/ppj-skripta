# Dokazovanje pravilnosti programov

Kako vemo, ali program deluje pravilno? Kako vemo, kakšen program želimo sestaviti?

Ločimo med **specifikacijo** in **implementacijo** programa:

* **Specifikacija** je opis, kaj naj želeni program počne.
* **Implementacija** je konkreten program, ki počne to, kar zahteva specifikacija.

Specifikacija je lahko podana bolj ali manj natančno, v človeškem jeziku ali
zapisana v formalnem matematičnem jeziku. Specifikacije imajo več namenov:

* da pridobimo opis programa, ki naj bi ga sestavili
* da lahko preverimo, ali je implementacija pravilna
* zagotovimo kompatibilnost med različnimi deli programske opreme

Danes bomo spoznali “specifikacije v malem”, s katerimi povemo, kaj naj počne konkreten košček izvorne kode.
Kasneje bomo govorili tudi o specifikaciji in implementaciji večjih programskih enot, ki zajemajo zbirko podatkovnih tipov in funkcij.


## Hoarova logika

Delovanje programa bomo opisali s t.i. Hoarovo logiko, v kateri pišemo **Hoarove trojice**

    { P } c { Q }

Tu sta `P`in `Q` logični formuli in `c` ukaz. Formuli `P` pravimo **predpogoj** (angl.
*precondition*), formuli `Q` pravimo **končni pogoj** (ang. *postcondition*).

Izkaže se, da je prikladno razdeliti preverjanje pravilnosti programov na dva dela:

1. Pod predpostavko, da se program ustavi (se ne zacikla), ali deluje pravilno?
2. Ali se program ustavi?

V ta namen uvedemo dve vrsti Hoarovih trojic:

:::{prf:definition} Delna pravilnost
:nonumber: true

`{ P } c { Q }` pomeni “*Če velja `P` in če bo ukaz `c` končal, potem bo veljal `Q`.*”
:::

:::{prf:definition} Popolna pravilnost
:nonumber: true

`[ P ] c [ Q ]` pomeni: “*Če velja `P`, potem se bo `c` končal in veljal bo `Q`.*”
:::

Zapomnimo si: delna pravilnost ne zagotavlja, da se bo `c` končal, popolna pravilnost to
zagotavlja.

Kaj lahko počnemo s specifikacijami?
Če imam dano specifikacijo, lahko poiščemo program, ki ji ustreza.

:::{prf:example}
:nonumber: true

Poiščite program `c` zamenja vrednosti spremenljivk `x` in `y`:

    { x = m ∧ y = n } c { x = n ∧ y = m }

Tu predpostavimo, da sta `m` in `n` **duhova** (angl. ghost variable), se pravi
spremenljivki, ki se ne pojavljata v `c`. 
:::

:::{prf:example}
:nonumber: true

Poiščite program `c`, ki uredi `x` in `y` po velikosti:

    { true } c { x ≤ y }

Ali zgornja specifikacija res pravi, da je treba urediti `x` in `y` po velikosti?
Ne, saj ji na primer zadošča program

    x := 0 ; y := 1

Verjetno smo hoteli v resnici tole, kjer sta `m` in `n` duhova:

    { x = m ∧ y = n } c { x = min(m, n) ∧ y = max(m, n) }

:::


Ko delamo s Hoarovo logiko, običajno pišemo pogoje in kodo navpično, da lahko med vrstice
vrivamo pogoje.

    { x = m ∧ y = n }
    c
    { x = min(m, n) ∧ y = max(m, n) }

Seveda potrebujemo nekakšna pravila sklepanja.

## Pravila sklepanja

Za Hoarovo logiko veljajo naslednja pravila sklepanja.

### Splošna pravila

Vedno smemo uporabiti veljavno logično in matematično sklepanje, na primer:

    P' ⇒ P    { P } c { Q }      Q ⇒ Q'
    ——————————————————————————————————–
              { P' } c { Q' }


    { P₁ } c { Q₁ }     { P₂ } c { Q₂ }
    ——————————————————————————————————–
         { P₁ ∧ P₂ } c { Q₁ ∧ Q₂ }

Naj bodo `FV(P)` vse spremenljivke, ki se pojavljajo v formuli `P` (free variables)
in `FA(c)` vse spremenljivke, ki jih `c` nastavlja (assigned variables). Na primer:

    FV(x ≤ y ∨ x > 0) = {x, y}

    FA(if x < y then x := y + 3 else skip end) = { x }

Velja pravilo:

    FV(P) ∩ FA(c) = ∅
    —————————————————
      { P } c { P }


To pravilo pove, da ukaz `c` ne vpliva na izjavo `P`, če nimata skupnih spremenljivk. Tako pravilo ne bi veljalo v programskem jeziku s kazalci, saj bo lahko `c` spreminjal vrednosti, ki so dosegljive iz `P`, čeprav jih `P` ne omenja.


#### Pravilo za `skip`

Ukaz `skip` nima nikakršnega učinka na veljavnost izjave:

    ———————————————–
    { P } skip { P }


#### Pravilo za pogojni stavek

Pri pogojnem stavku obravnavamo dva primera, enega za `then` in drugega za `else`.

    { P ∧ b } c₁ { Q }       { P ∧ ¬b } c₂ { Q }
    ———————————————————————————————————————————–
        { P } if b then c₁ else c₂ end { Q }


#### Pravilo za `c₁ ; c₂`

Pravilo za `;` veriži končni pogoj prvega ukaza s predpogojem drugega:


    { P } c₁ { Q }      { Q } c₂ { R }
    —————————————————————————————————–
           { P } c₁ ; c₂ { R }

#### Pravilo za zanko `while`

            { P ∧ b } c { P }
    —————————————————-————————————————–
    { P } while b do c done { ¬ b ∧ P }

Formuli `P` pravimo *invarianta* zanke `while`. Izmed vseh pravil, je tega najtežje uporabljati, ker je treba imeti nekaj izkušenj, da najdemo ustrezni `P`.

#### Pravilo za prirejanje

    ————————————————————————–
    { P[x ↦ e] } x := e { P }

Zapis `P[x ↦ e]` pomeni “v izjavi `P` zamenjaj `x` z `e`”.


### Popolna pravilnost

Vsa zgornja pravila, razen dveh, lahko predelamo v popolno pravilnost, na primer:

    [ P ∧ b ] c₁ [ Q ]       [ P ∧ ¬b ] c₂ [ Q ]
    ———————————————————————————————————————————–
        [ P ] if b then c₁ else c₂ end [ Q ]

Prva izjema je pravilo

    FV(P) ∩ FA(c) = ∅
    —————————————————
      { P } c { P }

ki ga predelamo takole

    FV(P) ∩ FA(c) = ∅    [ R ] c [ Q ]
    ——————————————————————————————————
          [ R ∧ P ] c [ Q ∧ P ]

(Opomba: pravilo

    FV(P) ∩ FA(c) = ∅
    —————————————————
      [ P ] c [ P ]

*ni* veljavno. Če bi bilo, bi lahko dokazali

    [ x > 0 ] while true do skip done [x > 0]

kar pa ne velja.)


Pri zanki `while` zagotovimo, da se bo končala, tako da poiščemo količino, ki se
zmanjšuje, a se ne more zmanjševati v nedogled. Na primer, to je lahko celoštevilska
pozitivna vrednost.

:::{warning}
Realna pozitivna vrednost se lahko zmanjšuje v nedogled:

    0.1 > 0.01 > 0.001 > 0.0001 > ...

Tudi celoštevilska vrednost se lahko zmanjšuje v nedogled:

    2 > 1 > 0 > -1 > -3 > -5 > -7 > ....
:::

Pravilo za popolno pravilnost `while` se glasi:

Naj bo `e` količina, ki se ne more v nedogled zmanjševati (na primer naravno število):

     [ P ∧ b ∧ e = z ] c [P ∧ e < z ]        z ∉ FV(c)
     ————————————————————————————————————————————————
          [ P ] while b do c done [ ¬ b ∧ P ]

V tem pravilu je `z` duh, kar formalno napišemo kot `z ∉ FV(c)`.
Kako pa ta pravila v praksi uporabljamo? Poglejmo nekaj primerov.


## Primeri

:::{prf:example}
:nonumber: true
Dokaži pravilnost programa:

    { x ≤ 7 }
    x := x + 3
    { x ≤ 10 }
:::


:::{prf:example}
:nonumber: true

Zapiši s Hoarovo logiko:

1. Program `c` se ne ustavi.

2. Program `c` se ustavi.
:::


:::{prf:example}
:nonumber: true
Dokaži pravilnost programa, kjer predpostavimo, da v spremenljivkah hranimo realna števila (da ni težav z deljenjem z 2):

    { x ≤ y }
    s := (x + y) / 2
    { x ≤ s ≤ y }
:::

:::{prf:example}
:nonumber: true

Dogovor: namesto `P ∧ Q` pišemo tudi `P, Q`

Dokaži pravilnost programa:

    [ b ≥ 0 ]
    i := 0 ;
    p := 1 ;
    while i < b do
       p := p * a ;
       i := i + 1
    done
    [ p = a ^ b ]

Rešitev:

    { b ≥ 0 }
    i := 0 ;
    { b ≥ 0, i = 0 }
    p := 1 ;
    { b ≥ 0, i = 0, p = 1 } # logično sklepamo, je zelo easy
    { p = a ^ i, i ≤ b }
    while i < b do
       { i < b, p = a ^ i, i ≤ b }
       # iz p = a^i sledi p·a = a^(i+1)
       # iz i < b sledi i+1 < b+1 sledi i+1 ≤ b (ker i, b celi števili)
       { p · a = a ^ (i + 1), (i + 1) ≤ b }
       p := p * a ;
       { p = a ^ (i + 1), (i + 1) ≤ b }
       i := i + 1
       { p = a ^ i, i ≤ b }
    done
    { i ≥ b, p = a ^ i, i ≤ b } # očitno
    { i = b, p = a ^ i } # očitno
    { p = a ^ b }

Popolna pravilnost: zmanjšuje se celoštevilska količina `e = b - i ≥ 0`.
Imamo invarianto `Q ≡ (p = a ^ i ∧ i ≤ b)`

    while i < b do
       [ Q, i < b, b - i = z ]
       [ i < b, b - i = z ]
       p := p * a ;
       [ i < b, b - i = z ]
       ⇒
       [ b - i = z ]
       ⇔
       [ b = z + i ]
       ⇒
       [ b < z + i + 1 ]
       ⇔ 
       [ b - i - 1 < z ]
       ⇔
       [ b - (i+1) < z ]
       i := i + 1
       [ b - i < z ]
    done
:::

:::{prf:example}
:nonumber: true
Dokaži pravilnost programa:

    [x = m ∧ y = n]
    if y < x then
       x := x + y ;
       y := x - y ;
       x := x - y
    else
       skip
    end
    [ x = min(m, n) ∧ y = max(m, n) ]

Rešitev:

    [x = m ∧ y = n]
    if y < x then
       [ y < x, x = m ∧ y = n]
       [ n < m, x = m ∧ y = n]
       [ y = n = min(m, n) ∧ x = m = max(m, n) ]
       [ (x+y)-((x+y)-y) = min(m, n) ∧ ((x+y)-y) = max(m, n) ]
       x := x + y ;
       [ x-(x-y) = min(m, n) ∧ (x-y) = max(m, n) ]
       y := x - y ;
       [ x-y = min(m, n) ∧ y = max(m, n) ]
       x := x - y
       [ x = min(m, n) ∧ y = max(m, n) ]
    else
       [x ≤ y, x = m ∧ y = n]
       [m ≤ n, x = m ∧ y = n]
       skip
       [ m ≤ n, x = m ∧ y = n ] # očitno sledi
       [ x = min(m, n) ∧ y = max(m, n) ]
    end
    [ x = min(m, n) ∧ y = max(m, n) ]
:::
