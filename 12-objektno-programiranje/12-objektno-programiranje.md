# Objektno programiranje

## Objekti

Objekti so podobni zapisom, le da imajo atribute in metode. Metode se lahko
sklicujejo na atribute, kakor tudi na druge metode (z uporabo `this` ali `self`).

Torej so objekti neke vrste **rekurzivni zapisi**. Rekurzivni, ker se lahko
objekt skliče sam nase.

### Objekti v OCamlu

V OCamlu in nekaterih drugih lahko objekte naredimo neposredno

```ocaml
object (this)
   val x = ...
   val y = ...
   method f = ...
   method g = ...
end
```

Funkcionalnost objekta (njegove metode) opišemo s tipom zapisa. S podtipi lahko
objekte umeščamo v hierarhijo.

Več primerov bomo obdelali na vajah, poglejmo primere:

:::{literalinclude} primeri.ml
:language: ocaml
:::

:::{seealso}

OCaml ima zelo bogat nabor konstrukcij za objektno programiranje, več o njih preberite
v dokumentaciji [Objects in OCaml](https://v2.ocaml.org/manual/objectexamples.html#).
:::

## Objektno programiranje z razredi

Mnogi objektni jeziki pa poznajo mehanizem **razredov** (Java, C++, C#).
Poglejmo še enkrat primer točke:

```ocaml
let p =
  object
    val mutable x = 10
    val mutable y = 20

    method get_x = x

    method get_y = y

    method move dx dy =
      x <- x + dx ;
      y <- y + dy
  end
```

Zgornja koda naredi le *eno* točko. Če želimo narediti več točk, lahko napišemo
funkcijo, ki sprejme začetno pozicijo in vrne objekt. Lahko pa definiramo razred, na
primer v Javi:

```java
public class Point {
    private int x ;
    private int y ;

    public Point(int x0, int y0) {
        this.x = x0;
        this.y = y0;
    }

    public int get_x() { return this.x; }

    public int get_y() { return this.y; }

    public void move(int dx, int dy) {
        this.x += dx;
        this.y += dy;
    }
}
```

Sedaj tvorimo nove točke s *konstruktorjem*: `new Point(10, 20)`.

Tudi v OCamlu lahko definiramo razred:

```ocaml
class point x0 y0 =
  object
    val mutable x = x0
    val mutable y = y0

    method get_x = x

    method get_y = y

    method move dx dy =
      x <- x + dx ;
      y <- y + dy
  end
```

In tvorimo novo točko s konstruktorjem: `new point 10 20`.

Razredi niso samo bližnjica za konstruktorje, ampak omogočajo še mnoge druge
mehanizme:

* enkapsulacija
* konstruktor
* dedovanje
* vmesniki
* prekrivanje metod
* preobteževanje metod
* generične metode in razredi
* abstrakne metode in razredi
* ⋯

Vsi ti mehanizmi lahko delo z razredi naredijo precej zapleteno. Verjetno je eden
od razlogov za kompleksnost ta, da programski jeziki kot so Java, C# in C++
*vse* mehanizme za organizacijo kode izražajo s pomočjo razredov. Tako Java ne
pozna modulov in funktorjev, algebrajskih podatkovnih tipov, ali parametričnega
polimorfizma – vse to nadomešča z razredi.

Naredimo kratek pregled osnovnih mehanizmov objektnega programiranja z razredi
in jih primerjajmo s koncepti, ki smo jih spoznali do sedaj.

### Enkapsulacija

Enkapsulacija je skrivanje stanja objekta, se pravi, da naredimo atribute (lahko
pa tudi metode) nedostopne zunaj razreda. V Javi to naredimo z določilom
`private`.

V OCamlu so atributi vedno privatni. Metodo naredimo privatno z določilom
`private`.

Pojem *enkapsulacija* včasih zajema tudi idejo, da objekt poleg stanja
(atributov) s seboj nosi tudi metode za delo z njimi.

Skrivanje definicij lahko implementiramo tudi z lokalnimi definicijami in
signaturami, ki zakrijejo implementacijo.

### Konstruktor

Konstruktor je del kode, ki nastavi začetne vrednosti atributov objekta.
Običajno konstruktor sprejme argumente, se pravi, da je to funkcija.

V Javi je ime konstruktorja enako imenu razreda, prav tako v C++ in OCamlu.

### Dedovanje

En razred lahko *deduje* od drugega:

```java
public class A extends B { ... }
```

To pomeni, da ima `A` vse, kar ima `B` (torej atribute in metode).

OCaml dopušča [večkratno dedovanje](https://v2.ocaml.org/manual/objectexamples.html#s%3Amultiple-inheritance),
ko en razred deduje hkrati od več nadrazredov.

### Vmesniki

Vmesniki predpisujejo funkcionalnost, ki jo mora imeti objekt. V Javi vmesnik
definiramo z

```java
interface I { ... }
```

in od razreda zahtevamo, da zadosti vmesniku `I` (lahko tudi več)

```
class C implements I { ... }
```

O vmesnikih smo že govorili.

### Prekrivanje

Razred lahko nekatere od podedovanih metod *prekrije* z lastnimi definicijami.

Tu se pojavi vprašanje, kako dostopati do prekritih metod, saj jih včasih
potrebujemo. V Javi to naredimo s `super.imeMetode(⋯)`. Podobno vprašanje se
pojavi pri konstruktorjih: kako iz konstruktorja pokličemo konstruktor iz
nadrazreda?

### Preobteževanje

Če imamo več metod z istim imenom `f`, pravimo, da smo `f` *preobtežili* (angl.
overload). Metode se morajo med seboj razlikovati po števili argumentov ali
njihovih tipih, sicer iz klice metode ne moremo razbrati, katero različico
želimo.

OCaml ne pozna preobteževanja. Lahko pa uporabimo module in jih odpremo lokalno
z `let open M in ⋯` ali `M.(⋯)`.

### Generične metode in razredi

Generične metode in razredi so parametrizirani z razredi ali vmesniki, takole:

```
public class A<B> {
  ⋯
}
```

Definicija razreda `A` je *parametrizirana* z razredom `B`.

V C++ v ta namen uporabljamo predloge (angl. templates).

V OCaml poznamo tri mehanizme za generično programiranje: parametrični
polimorfizem, moduli in [parametrizirani razredi](https://v2.ocaml.org/manual/objectexamples.html#s%3Aparameterized-classes).

### Abstraktne metode in razredi

*Abstraktne* (v C++ se imenujejo *virtualne*) so metode, ki jih ne
implementiramo, ampak samo deklariramo. Se pravi, povemo njihov tip ne pa tudi
implementacije.

Če razred vsebuje abstraktno metodo, mora biti tudi sam deklariran kot
abstrakten. Objektov abstraktnega razreda ne moremo ustvarjati z `new`, saj so
neke vrste "nedokončani" razredi.

Abstraktni razred je neke vrste mešanica implementacije in speficikacije
(specifikacija sestoji iz abstraktnih metod).

Razredi v OCamlu so lahko abstraktni, pravi se jim [virtualni razredi](https://v2.ocaml.org/manual/objectexamples.html#s%3Avirtual-methods).
