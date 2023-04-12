# Učinki in prestrezniki

:::{important}
Tega poglavja v akademskem letu 2022/23 nismo obravnavali, kar pa ne pomeni,
da vam ne bo koristilo, če ga boste prebrali.
:::

Okoli leta 1985 je Eugenio Moggi iz Genove odkril, da lahko računske učinke
obravnavamo z monadami, ki se uporabljajo v Haskellu za računske učinke. V
začetku tega tisočletja sta Gordon Plotkin in John Power iz Edinburgha
ugotovila, da lahko večino računskih učinkov predstavita z *algebrajskimi
operacijami*. Kasneje sta Gordon Plotkin in njegov doktorski študent Matija
Pretnar odkrila še *prestreznike*. Nekaj let za tem sta Andrej Bauer in Matija
Pretnar iz Ljubljane ustvarila Eff, prvi programski jezik zasnovan na teoriji
algebrajskih učinkov in prestreznikov. Kmalu so se pojavile knjižnice za
prestreznike, nadgradnje programskih jezikov in novi jeziki, ki so uporabljali
prestreznike. Aprila 2018 smo bili na delovnem srečanju , kjer smo se s
predstavniki večjih podjetjih (Facebook, Google, Microsoft) pogovarjali o
vključitvi prestreznikov v njihove tehnološke rešitve, kot je na primer
[WebAssembly](https://webassembly.org) (naslednik Javascript).

Pa si poglejmo, zakaj so algebrajski učinki in prestrezniki tako zanimivi.

## Računski učinki so operacije

Računski učinki se v programskem jeziku pojavijo kot **operacije**, ki se jih
obravnava drugače kot običajno računanje, saj imajo **učinek**. Na primer:

* `print` je operacija, katere učinek je izpis na izhodno enoto (zaslon)
* `input` je operacija, katere učinek je branje s vhodne enote (tipkovnica)
* `exit` je operacija, ki prekine izvajanje programa
* `write` je operacija, ki spremeni stanje pomnilnika
* `read` je operacija, ki vrne trenutno stanje pomnilnika
* `toss` je operacija, ki vrne naključni bit
* `spawn` je operacija, ki sproži izvajanje novega vzporednega vlakna

Vsem operacijam je skupno to, da *začasno prekinejo* izvajanje programa,
opravijo svoj računski učinek, nato pa nadaljujejo z izvajanjem programa (ali pa
ne, na primer `exit`). Nekatere operacije nadaljevanju programa tudi vrneta
*rezultat* (`input` in `read`).

Poglejmo na primer naslednji program (napisan v kvazi-OCaml):

    1  print "Ime: " ;
    2  let ime = input () in
    3  print "Primek: " ;
    4  let priimek = input () in
    5  let s = ime ^ " " ^ priimek ^ " je bimbo." in
    6  print s

V programu je pet operacij (trikrat `print` in dvakrat `input`). Operacija
`print` v 3. vrstici ima za nadaljevanje vrstice 4–5, ki od `print` ne dobijo
rezultata (pravzaprav ga, le da je to enota `()`, ki jo ignoriramo).

Operacija `input` v 4. vrstici je bolj zanimiva. Za nadaljevanje ima

    4  let priimek = □ in
    5  let s = ime ^ " " ^ priimek ^ " je bimbo." in
    6  print s

kjer smo z `□` označili "luknjo", v katero je treba vstaviti rezultat, ki ga
vrne `read` (namreč niz, ki ga prebere s tipkovnice). Lahko si mislimo, da je
nadaljevanje neke vrste funkcija, ki sprejme rezultat operacije `read` in
nadaljuje izračun:

    fun x ->
       let priimek = x in
       let s = ime ^ " " ^ priimek ^ " je bimbo." in
       print s

Nadaljevanju izračuna pravimo tudi **kontinuacija** (angl. continuation).


## Drevo izračuna

Potek programa in njegove učinke lahko predstavimo z **drevesom izračuna**:

* listi drevesa so končni rezultati
* vozlišča so operacije
* poddrevesa so izračuni, ki jih dobimo, ko se operacija zaključi in se program nadaljuje.
  Za vsak rezultat, ki ga lahko vrne operacija, dobimo eno poddrevo.

Narišimo nekaj dreves izračuna.

:::{admonition} Primer
Narišimo računsko drevo programa

    print "Hello" ;
    let x = input () in
    print x ;
    print x ;
    length x

Drevo (pri `input` bi morali imeti po eno poddrevo za vsak niz, torej neskončno
poddreves, prikazana so samo tri):

                  print "Hello"
                       |
                       |
                    input ()
               /       |      \
         "foo"/   "bar"|       \"quux"
             /         |        \
       print "foo"  print "bar"  print "quux"
            |          |            |
            |          |            |
       print "foo"  print "bar"  print "quux"
            |          |            |
            |          |            |
            3          3            4
:::

:::{admonition} Primer
Denimo, da imamo operacijo `toss`, ki vrne naključni bit.

    if toss () then
      if toss () then
        3
      else
        4
    else
        5

Drevo:

                        toss ()
                        /    \
                   true/      \false
                      /        \
                   toss ()      5
                   /   \
              true/     \false
                 /       \
                3         4
:::

:::{admonition} Primer
Denimo, da imamo operacijo `exit`, ki prekine izvajanje programa:

    if toss () then
       exit ()
    else
       42

Drevo:

                      toss ()
                      /     \
                 true/       \false
                    /         \
                 exit ()      42
:::

Drevo izračuna nam da pregled nad *možnimi poteki izvajanja* programa. Dejansko
se bo izvedla le ena veja v drevesu, katera pa to bo, je odvisno od rezultatov,
ki jih vračajo operacije.

## Prestrezniki

**Prestrezniki** so nov programski konstrukt, ki sta ga iznašla Gordon Plotkin
in Matija Pretnar. So posplošitev prestreznikov izjem, ki jih poznajo standardni
programski jeziki.

Če na program gledamo kot na drevo izračuna, se nam porodi ideja, da bi lahko
tako drevo transformirali na zanimive načine. Na primer, vse pojavitve ene
operacije bi lahko zamenjali z drugo. Lahko bi tudi izvedli več kot eno vejo
drevesa, ali pa kar preiskali celotno drevo.

Seveda pa se moramo lotiti takih transformacij v izvajanju programa na
strukturiran in pregleden način, kar omogočajo prestrezniki.

S prestreznikom povemo, kako obdelamo drevo izračuna in sicer:

1. Kaj naredimo z listi (končnimi rezultati izračuna)
2. Kaj naredimo z operacijami

Pri tem se operacije obdelajo rekurzivno. Prestreznik je pravzaprav neke vrste
`fold` na drevesu izračuna.


## Eff

Programski jezik [Eff](https://www.eff-lang.org) sta ustvarila Andrej Bauer in
Matija Pretnar. Je eksperimentalni programski jezik, s katerim sta pokazala,
kako lahko uporabljamo operacije in prestreznike kot programske konstrukte.
Programski jezik je vplival na razvoj nekaterih drugih jezikov in knjižnic za
programiranje s programskimi učinki.

V Eff so operacije in prestrezniki prvovrstne vrednosti. Se pravi, da lahko
programer definira nove operacije in prestreznike, lahko pa seveda prestreza tudi
vgrajene operacije.

### Sintaksa Eff

Sintaksa Eff je zelo podobna sintaksi programskega jezika OCaml.


### Kako deklariramo nove operacije

Novo operacijo `Op` definiramo z določilom

    effect Op : a -> b

pri čemer je `a` tip *argumenta*, ki ga sprejme `Op` in `b` tip rezultata, ki ga
vrne `Op`. Primeri iz standardne knjižnice Eff:

    effect Print : string -> unit

    effect Read : unit -> string

    effect Raise : string -> empty

Operacija `Raise` vrača rezultat tipa `empty`, ki nima vrednosti. To pomeni, da
sploh ne more nadaljevati izvajanja programa, saj mu ne more podati rezultata.
Torej je to **izjema**.

Operacijo sprožimo s `perform`:

    perform (Print "Hello, world!")

    perform (Raise "file not found")


### Kako pišemo prestreznike

Prestreznik (angl. handler) definiramo takole:

    handler
    | res -> c
    | effect (Op₁ arg) k -> c₁
    | effect (Op₂ arg) k -> c₂
    | ...

kar preberemo takole:

* rezultat `res` se preslika v izračun `c` (ki se lahko sklicuje na `res`)
* operacija `Opᵢ` se preslika v izračun `cᵢ`, pri čemer je `arg` argument, ki ga
  je dobila operacija in `k` nadaljevanje (funkcija, ki ji podamo rezultat
  operacije).

Če definiramo prestreznik `h`

    let h = handler ...

ga lahko uporabimo takole:

    with h handle
      c

Prestreznik lahko zapišemo tudi neposredno in z njim nadzorujemo izračun `c` takole:

    handle
      c
    with
    | res -> c
    | effect (Op₁ arg) k -> c₁
    | effect (Op₂ arg) k -> c₂
    | ...

## Primeri prestreznikov

Ogledali si bomo primere s spletne strani, kjer lahko preizkusimo Eff. Ti
nakazujejo le nekaj preprostih možnosti, kaj vse lahko naredimo. Še več primerov
najdete [v izvorni kodi za Eff](https://github.com/matijapretnar/eff/tree/master/examples).
