#let title = "Typst pro programátory"

#set page(
  paper: "iso-b5",
  margin: (x: 1cm, top: 1cm, bottom: 1.5cm),
  numbering: "1"
)

#set document(
    title: title,
    author: "Jiří Fišer"
)

#set par(
    justify: true,
    spacing: 1em,
    leading: 0.7em,
    justification-limits: (
      tracking: (min: -0.01em, max: 0.012em),
      spacing: (min: 66%, max: 133%)
    )
)

#set text(
  lang: "cs",
  font: "Source Serif 4"
)

#show title: set text(
    font: "Inter"
)

#show heading: set text(
    font: "Inter"
)

#show heading.where(level: 1): set text(
  size: 20pt
)
#show heading.where(level: 1): set block(below: 1.5em)

#show heading.where(level: 2): set text(
  size: 16pt
)
#show heading.where(level: 2): set block(below: 0.9em)

#show heading.where(level: 3): set text(
  size: 14pt
)

#show heading.where(level: 4): set text(
  size: 12pt
)

#show heading.where(level: 4): set heading(
  numbering: none
)

#show heading.where(level: 1): it => {
  pagebreak(weak: true)
  it
}

#show raw: set text(
  font: "Source Code Pro",
  size: 11pt,
)

#set heading(numbering: "1.1.")

#set list(indent: 2em)
#set enum(indent: 2em)
#set terms(indent: 2em,   
           separator: linebreak())

#show link: set text(fill: rgb("0000BB"))

#show raw: it => {
  // Kontrola, zda se jedná o inline prvek (nikoliv víceřádkový blok)
  if not it.block {
    box(fill: rgb("f4e7c5"), outset: 2pt, radius: 2pt, it)
  } else {
    it // Víceřádkové bloky kódu zůstanou beze změny
  }
}

#show regex("\b([vksuozVKSUOZAI])\s+"): it => {
    it.text.slice(0, 1) + [~]
  }

#let show-and-run(source, crop: false) = {
  // Nejprve zdrojový text vypíše.
  if not crop {
    source
  }
  else {
   let lines = source.text.split("\n")
   let croplines = lines.slice(1, lines.len()-1)
   let newtext = croplines.join("\n")
   raw(newtext, block:true, lang:source.lang)
  }
  // Potom jeho obsah vyhodnotí jako značkovací jazyk Typstu.
  block(
    width: 100%,
    stroke: 0.5pt,
    inset: 8pt,
    radius: 3pt,
    eval(source.text, mode: "markup"),
  )
}

#page(numbering: none)[
#let color-typst = for (i, g) in array.enumerate(title.clusters()){
  text(str(g), fill: eastern.desaturate(4.5% * i))
}
#align(center)[
#v(2.5cm)  
#text(size: 32pt, weight: "bold")[#color-typst]
#v(2cm)
#text(size: 24pt, weight: "bold")[Jiří Fišer]
]
]

#outline(depth: 2)

= Úvod

#link("https://typst.app")[_Typst_] je nový nástroj pro vytvářená komplexních dokumentů se zaměřením nejen na kvalitní typografii, ale též sémantické strukturování textu. Stejně jako TeX využívá přístup, kdy je text vytvářen v běžném programátorském editoru nebo vývojovém prostředí a následně překládán do PDF (resp. dalších prozatím spíše okrajových formátů).

Oproti TeXu má však několik nesporných výhod, neboť vznikl na zelené louce o více než čtyřicet let později a nenese tudíž zátěž zpětné kompatibility:

- modernější programovací jazyk bližší současným skriptovacím jazykům (jako je _Python_ nebo _Javascript_)
- výrazně popisnější chybové hlášky
- čitelnější syntaxe (přehledné oddělení textu a řídicího kódu)
- přímá podpora komplexnějších požadavků na typografii (vkládání obrázků, hypertextové odkazy, barva, apod.) Ty jsou samozřejmě k dispozicí i v TeXu, ale jen prostřednictvím různých rozšíření a balíčků
- výrazně rychlejší překlad, který umožňuje i preview v reálném čase a synchronizací se zdrojovým kódem. Je to dáno použitím Rustu jako vývojové platformy, inkrementálního překladu a dokonce i podporu vícevláknového zpracování


Jsou zde však i jistá omezení:
- _Typst_ je relativně nový produkt s omezenou uživatelskou základnou
- _Typst_ stále zaostává za moderními TeXovskými rozšířeními (např. LaTeX s tisíci rozšiřujících balíčků) v některých oblastech 
- _Typst_ se stále rychle vyvíjí a nové verze občas přinášejí nekompatibilní změny (ačkoliv nikoliv v jádře jazyka a základních funkcích)

== Překladač a vývojová prostředí
Pro práci v _typstu_ je potřeba minimálně překladač. Ten je open-source a je k dispozici na adrese https://typst.app/open-source/. Praktičtější je však použití vývojového prostředí:

+ *Tynamist Typst* je rozšíření pro _Visual Studio Code_. Kromě zvýraznění syntaxe podporuje i inteligentní doplňování (s nápovědou) a synchronizované _preview_.

+ *Typst Web app* je prostředí zaměřené hlavně na spolupráci tvůrců obsahu (obdoba _Overleaf_). Je #link("https://typst.app/pricing/")[placené], avšak i neplacená úroveň nabízí rozumná omezení např. pro závěrečnou práci. 

= Základní formátování textu

Základní pravidla:

+ odstavce se oddělují prázdným řádkem
+ poznámky (neprojeví se ve výsledném PDF) se vkládají pomocí dvou lomítek (`//`) jako v C++
+ některé znaky mají speciální význam a používají se jako v odlehčených značkovacích jazycích (nikoliv však zcela shodně jako v nejznámějším _Markdown_)
+ při komplexnějších požadavcích je nutné přejít do příkazového režimu (pomocí znaku `#` ) a volat funkci, či provést komplexnější kód ve vestavěném programovacím jazyce
+ je nutné odlišovat vnitrořádkové (_inline_) prvky, které se řadí horizontálně (v evropských jazycích zleva doprava) a blokové prvky, které se řadí shora dolů


== Vnitrořádkové prvky<sec:inline>

Toto formátování se týká souvislých částí textu v odstavcích či jiných blocích textu. 

Pokud například potřebujeme vysázet část textu kurzívou lze jednoduše napsat.

#show-and-run(
  ```typ
  text v _kurzívě_ a opět bez kurzívy
  ```
)

To vypadá jako běžný _markdown_, ale je to jen zkratka ze explicitní volání funkce, které navíc může nabývat několika podob.

#show-and-run(
  ```typ
  text v #emph([kurzívě]) a opět bez kurzívy

  text v #emph()[kurzívě] a opět bez kurzívy

  text v #emph[kurzívě] a opět bez kurzívy
  ```
)

První volání je nejbližší syntaxi běžného programovacího jazyka. Znakem `#` přejdeme do příkazového režimu, v němž zavoláme funkci `emph`, která očekává jediný parametr, jímž je v tomto případě tzv. textový obsah (_contents_).

Textový obsah je běžný markup text v typstu, který může obsahovat formátování a zde (uvnitř příkazového režimu) a má podobu tzv. *textového bloku*.

Co se tedy přesně děje? Ukažme si to krok pro kroku:
+ na začátku přejdeme do *příkazového režimu* (režim, v níž se text chápe jako program)
+ je vyhodnocen jediný parametr funkce `emph`
+ uvnitř textového bloku (hranatých závorek) přejdeme zpět do běžného *markup režimu* (text je chápán jako odlehčený značkovací jazyk), V tomto režimu je vyhodnocen obsah textového bloku.
+ výsledný objekt typu `contents` (který může být značně komplexní, neboť kromě znaků obsahuje i informaci o formátování) je předán funkci `emph` (vracíme se tak do příkazového režimu)
+ ta na něj aplikuje své formátování a vrací nový textový obsah, který se vloží na místo volání funkce (po skončení jsme opět v původním mark-up režimu)

Ostatní dva zápisy jsou jen syntaktickým pozlátkem, jehož hlavním cílem je minimalizovat počet závorek (a především zjednodušit jejich seskupení, aby to nedopadlo jako v Lispu). 

- všechny povinné parametry funkce, které jsou textovým blokem (tj. jsou v hranatých závorkách) lze umisťovat až kulaté závorky ve volání funkce (nazval bych to _vymístěním_)
- pokud po vymístění nezbývají ve volání funkce žádné další parametry, lze prázdné kulaté závorky eliminovat (musí tam zůstat ty hranaté!)

Název funkce ukazuje, že její sémantikou není vynucení kurzívy, ale (jemné) zvýraznění textu (_emphasis_). To se projeví. pokud volání vnoříme do sebe.

#show-and-run(
  ```typ
  pozor: #emph[a uvnitř ještě něco _důležitějšího_ a pak pokračuje důležité].
  ```
)

Zdůraznění uvnitř zdůraznění přepíná z kurzívy opět na vzpřímený řez písma. Je také zřejmé, že pokud se `emp` a podobné zápisy vnořují, je nutné použít explicitní volání funkce, neboť podtržítka nejsou párovými znaky (lze to samozřejmě psát i obráceně).

Pro důraznější zdůraznění lze využít funkci `strong`, s mark-up zápisem dvojice hvězdiček (`*`).

#show-and-run(
  ```typ
  tohle *nepřehlédněte*

  tohle #strong[nepřehlédněte]
  ```
)

*Poznámka*: pokud potřebujete sázet řídicí znaky v textu (tj. `#`, `_` a `*` a pár dalších), tak je stačí uvádět pomocí únikové sekvence se zpětný lomítkem, např. ```typ \#``` se vysází jako \#.

Podporovány jsou samozřejmě i další funkce pro vnitrořádkové formátování. Nejdříve si uveďme ty, které mají obecnou sémantiku:

#show-and-run(
  ```typ
  #highlight[barevně zvýrazněný text]

  `syrový text`
  ```
)

Syrový text (lze v něm využít i speciální znaky a je vysázen strojopisem) se stejně jako v _Markdown_ uvádí v obrácených apostrofech (v případě potřeby však lze přímo volat funkci `raw`).

Další funkce přímo definují některý z typografických efektů (a nevyužívají se příliš často#footnote[indexy se vyskytují především v matematických vzorcích, kde pro ně existuje pohodlnější zápis]):

#show-and-run(
  ```typ
#underline[podtržený text]

#overline[text s čárou nad ním]

#strike[přeškrtnutý text]

#sub[dolní index]
#super[horní index]

#smallcaps[kapitálky] // musí být podporovány fontem
  ```
)

Pro další efekty je nutné využít obecnější funkci `text`, která sází řádkový text a umožňuje nastavit velké množství stylistických parametrů (odpovídá tak HTML elementu `span` s přímým nastavením stylů). Snadno tak lze měnit například barvu písma, jeho velikost i použitý font.

#show-and-run(
  ```typ
  a teď #text(red)[červeně] či explicitněji #text(fill: rgb("0088EE"))[azurově]

  a měníme velikost #text(16pt)[písma] a #text(font: "Inter")[rodinu] či obojí #text(8pt, font: "Inter")[zároveň].

  A #text(fill:green, size: 1.5em)[velké zelené] či stručněji #text(luma(80), 3mm)[malé šedé]
  ```
)

Většina stylových parametrů se u funkcí předává prostřednictvím tzv. pojmenovaných parametrů. Tyto parametry musí mít v _typst_ implicitní hodnoty (naopak ty poziční je mít nemohou), ale často mohou nabývat hodnoty `none` (nespecifikována) nebo `auto` (volí se podle kontextu automaticky). Písmo je například implicitně (automaticky) černé a jeho velikost a rodina odpovídá okolí.

U nemnoha vestavěných funkcí lze některé pojmenované parametry předat pozičně, přičemž ve skutečnosti na pozicích nezáleží (například barva se vždy použije jako parametr `fill` a rozměr jako `size`). Je to ale trochu magické chování (parametry nejsou řízené jménem ani pozicí, ale typem), které není v běžných funkcích přímo podporováno (a ani doporučováno).

Rozměry lze uvádět v běžných jednotkách (cm, mm), typografických (`1pt` = 1 typografický bod = 1/72\") resp. relativních (`1em` = stupeň písma).

Dále si všimněte, že uvnitř příkazového režimu (na místě argumentu) lze volat další funkce jako je `rgb` a `luma`). Protože jsou uvedeny v kontextu  příkazového režimu, uvádí se bez znaku mřížka (`#`).

=== Hypertextové odkazy

Odkazy na  URL zdroje lze vkládat pomocí funkce `link`:

#show-and-run(
  ```typ
  Domovské stránky aplikace _typst_ jsou 
  na adrese #link("https://typst.app"), projekt využívá úložiště
   #link("https://github.com/typst/typst")[Github]. 
   Přímo vložené odkazy jako např. tento: https://typst.app/universe (
   rozšíření třetích stran) se převedou na `link`.
  ```
)

Odkazy nejsou běžně nijak vyznačeny, ale lze to přirozeně změnit (jako zde, kde jsou tmavě modré).

Funkce `link` lze (spíše okrajově) využít i pro odkazy uvnitř dokumentu. Tomuto použití se budeme věnovat v @sec:refs[kapitole] na #ref(<sec:refs>, form:"page", supplement: "straně").

=== Boxy

Boxy jsou vnitrořádkové kontejnery, které mohou obsahovat libovolný tiskový materiál (včetně bloků, viz níže) a mají tyto vlastnosti:

- rozměry (šířku a výšku)
- případnou výplň (`fill`)
- případný okraj (s čarou `stroke` a kulatými rohy s poloměrem `radius`)

#show-and-run(
  ```typ
 výplň: #box(fill:red)[Ája] 
 resp. lépe #box(fill:red, inset:3pt)[Ája],
 okraj: #box(width:2cm, stroke:1pt, inset:3pt, radius:3pt)[text]
  ```
)

Výplň a okraje se kreslí mezi účařím (dotažnice, na níž spočívají písmena) a  horní dotažnice (ta je vedená na úrovni horních dotahů vysokých písmen jako je např.`d`). Vně tak zůstávají akcenty velkých písmen a dolní přetahy. Tomu lze zabránit vhodnou výplní (`inset`). 

#figure(
  image("pismova_osnova.png", width:75%),
  caption: [Písmová osnova (převzato z Wikipedie)]
)

Kromě vnitřní výplně existuje i výplň vnější (`outset`), která se chová podobně (je vyplněná a je uvnitř okrajů) avšak neovlivňuje vnější rozvržení (nemění např výšku řádku, vnějšího boxu, apod.).



#show-and-run(
  ```typ
  první řádek

 #box(fill:yellow, outset:12pt, stroke:1pt)[obsah]
  ```
)

Vertikální zarovnání s okolním textem řeší parametr `baseline`:

#show-and-run(
  ```typ
 ..#box(baseline: auto, fill:luma(200))[implicitně účaří s účařím] 
 ..#box(baseline: top, fill:luma(200))[s horní dotažnicí] 
 ..#box(baseline: horizon, fill:luma(200))[se střední dotažnicí]
  ```
)

Pomocí baseline lze provádět vertikální posun o fixní nebo relativní délku (vztaženou k výšce boxu bez `outset`):

#show-and-run(
  ```typ
 ..#box(baseline: 5pt, fill:luma(200))[dolů] 
 ..#box(baseline: -5pt, fill:luma(200))[nahoru] 
 ..#box(baseline: 100%, fill:luma(200))[dolů o 100%]
  ```
)

Jedním z využití boxů je i vkládání horizontální textové výplně. Zde se často využívá zlomková specifikace šířky:

#show-and-run(
  ```typ
 #box(baseline: 5pt, width: 1fr)[#line(length: 100%)]
 #box(width: 2fr, repeat(gap:2pt)[.])
  ```
)

Boxy si rozdělí šířku svého kontejneru (zde odstavce) v poměru ($1/3 = 1/(1+2)$) a $2/3$. První je vyplněn horizontální čarou (ta vyplňuje 100% jeho šířky) a druhý opakováním textu znaku tečka (s prokladem o šířce 2pt).


== Blokové prvky

Blokové prvky jsou segmenty textu, které se na rozdíl od vnitrořádkových (_inline_) elementů sází vertikálně od shora dolů.

=== Odstavce

Nejběžnější typem blokových prvků jsou odstavce. Ty nemusí být explicitně označeny funkcí a _typst_ je automaticky rozeznává podle kontextu (např. podle prázdných řádků, umístění v nadřazených segmentech). Explicitně se vytvářejí voláním funkce `par`. Ta se však používá jen v případě, že se odstavec špatně identifikuje a také v případech, kdy potřebujeme nastavit vzhled odstavce (nebo odstavců).

#show-and-run(
  ```typ
#par(first-line-indent: 2em, justify: false, leading:0.5em)[
  #lorem(50)]
#par(first-line-indent: 2em, justify: false, leading:0.5em)[
  #lorem(50)]
#par(justify: false, leading:0.5em)[
  #text(font: "Cambria", size:13pt)[
  ἄνδρα μοι ἔννεπε, μοῦσα, πολύτροπον, ὃς μάλα πολλὰ \
  πλάγχθη, ἐπεὶ Τροίης ἱερὸν πτολίεθρον ἔπερσεν:\
  πολλῶν δ᾽ ἀνθρώπων ἴδεν ἄστεα καὶ νόον ἔγνω,\
  πολλὰ δ᾽ ὅ γ᾽ ἐν πόντῳ πάθεν ἄλγεα ὃν κατὰ θυμόν,\
  ἀρνύμενος ἥν τε ψυχὴν καὶ νόστον ἑταίρων.\
]]
  ```
)

Povšimněte si, že odsazení prvního řádku se projeví jen tehdy, je-li odstavec předcházen jiným (tj. u druhého a dalšího v posloupnosti odstavců).

Funkce `lorem` generuje zadaný počet slov z pseudolatinského textu, který se používá jako maketa reálného textu (má typografické charakteristiky běžného textu a nepoutá pozornost na obsah).

=== Explicitní blok

Obecným blokovým (vertikálním) kontejnerem je explicitní `block`. Může zahrnovat libovolný blokový ale i vnitrořádkový obsah (tj. z vnitrořádkového obsahu vytváří blokový prvek). Funkčně se podobá HTML elementu `div`.

Většina parametrů je obdobou parametrů u boxů, včetně velikostí, výplně a okrajů.

#show-and-run(
  ```typ
  #block(fill:aqua, 
         inset:4pt,
         stroke: (paint:blue, thickness: 2pt, dash: "dashed"),
         breakable: true )[
    #lorem(30)

    #lorem(20)
  ]
  ```
)

Tak (_stroke_) může mít hodnotu barvy (`paint`) nebo rozměru (`thicknes`) resp. jejich součtu (`4pt + aqua`), který vytváří objekt typu `stroke`. Detailnější požadavky na tah lze uvést pomocí literálu slovníku, který je uzavřen v kulatých závorkách (nikoliv složených!) a obsahuje klíče (zde vlastnosti) a vlastní hodnoty oddělené dvojtečkou (jedná se formálně o stejný zápis jako volání funkce s pojmenovanými argumenty, ten však vždy následuje identifikátor funkce#footnote[to je jedním z důvodů nepřípustnosti mezerových znaky mezi jménem funkce a seznamem argumentů]).

Použití slovníků na místě komplexních objektů je jedním ze základních rysů návrhu rozhraní funkcí v _typstu_. Je to syntaktická zkratka za explicitní volání funkce `stroke` s pojmenovanými parametry (proto je nutno hledat dokumentaci této funkce). Důvod je zřejmý: slovo `stroke` nemusíte psát dvakrát. 

#show-and-run(
  ```typ
  #block(fill:aqua, 
         inset:4pt,
         stroke: stroke(paint:gradient.linear(red, blue), 
                        thickness: 2pt, 
                        dash: (5pt, 2pt, "dot", 2pt)),
         breakable: true )[
    #lorem(30)
  ]
  ```
)

Tato ukázka navíc uvádí na místě barvy barevný gradient a čerchování je specifikováno pomocí vzoru čar a mezer.

Navíc jsou zde použity dvě nové syntaktické konstrukce. Funkce `gradient.linear` je atributem typu `gradient`, tj. některé objekty mohou mít atributy (a těmito atributy mohou být funkce). 

Detaílní specifikace čerchování používá *pole* (_array_). Pole je uzavřeno v kulatých závorkách a obsahuje položky oddělené čárkou.

== Výčty 

Výčty se nejsnadněji vkládají pomocí mark-up syntaxe:

*Nečíslované seznamy* (`list`) pomocí spojovníku `-` na začátku řádku (resp. odsazeně pro vnořené výčty)

#show-and-run(
```typ
- šelma
  - kočka
    - Hebkosrtka 
    - Pitypačka
  - pes
    - Sultán
    - Fík
```)

*Číslované výčty* (`enum`) se vytvářejí pomocí znaku plus `+`:

#show-and-run(
```typ
+ Ústecký kraj
  + Děčín
  + Litoměřice
  + Teplice
+ Liberecký kraj
  + Liberec
  + Česká Lípa

a také moravské kraje:
3. Jihomoravský kraj  //explicitně zadané číslo
  + Brno
  + Znojmo
+ Olomoucký kraj  // číslování navazuje
```)

Výčet lze samozřejmě zapsat i prosřednictvím volání funkcí. V tomto případě lze detailně upravit i vzhled seznamu:

#show-and-run(
```typ
#enum(numbering: "I.", tight:false,
  [první položka], // položka musí být ohraničený blok
  [druhá položka // druhá položka
  #enum(numbering: "α)",
    [první vnořená],
    [druhá vnořená]
  )
  ],
  [třetí položka]
)
```)

Vnější výčet je číslován římskými číslicemi (to určuje vzor uvedený u argumentu `numbering`), vnořený pak malými písmeny řecké alfabety: #numbering("α, ", ..range(1, 6)) atd. Vnější výčet navíc není kompaktní (tj. mezi položkami jsou meziodstavcové mezery.) 

Existuje i alternativní  řešení kustomizace, neboť lze změnit chování u běžných (markup) výčtů. Tomu se budeme věnovat později, viz @chap-set[kapitola].

Jednotlivé položky výčtu mohou samozřejmě obsahovat odstavce či jiné blokové prvky. Stačí aby byly správně odsazeny (a odstavce odděleny prázdnou řádkou):

#show-and-run(
```typ
+ *Frodo*
   
  hobit
+ *Samvěd*

  hobit
+ *Gandalf*

  čaroděj
```)

Pro tento účel, kdy každá položka definuje nějaký pojem je vhodnější použít popisné výčty(`terms`), jejichž položky začínají znakem lomítko (`/`) a pojem je od popisu oddělen dvojtečkou (`:`)

#show-and-run(
```typ
/ Frodo: hobit
/ Samvěd: hobit
/ Gandalf: čaroděj
```)

== Obrázky 

Pro vkládání obrázků se využívá funkce `image`. V parametrech stačí uvést odkaz na soubor (podporovány jsou běžné bitmapové jako PNG, JPG, GIF a WEBP stejně jako vektorové PDF a SVG) 
a určit alespoň jeden rozměr (druhý se dopočítá při zachování poměru stran).

#show-and-run(
  ```typ
  #image("rotunda.jpg", width: 33%)
  ```)

Pro jiné zarovnání je potřeba obrázek předat do funkce `align`.

#show-and-run(
  ```typ
  #align(center)[#image("rotunda.jpg", width: 33%)]
  ```)

Funkci `align` lze aplikovat na jakýkoliv blokový obsah.

S vkládáním číslovaných a tím i odkazovatelných obrázků se seznámíme v @sec:refs[kapitole].

== Kapitoly

Pro členění rozsáhlejšího textu slouží kapitoly a to v několika úrovních. Každá kapitola začíná nadpisem, který ve stručné mark-up synta  znaky rovnítek na počátku řádku, kde počet rovnítek odpovídá relativní hloubce zanoření kapitoly:

```typ
= kapitola nejvyšší úrovně

== kapitola druhé úrovně

=== kapitola třetí úrovně
```

V praxi se nepoužívá více než sedm úrovní zanoření kapitol (a doporučit lze maximálně pět).

Příslušná funkce se jmenuje `heading` a používá se tehdy, pokud chceme nastavit nestandardní chování nadpisu.

```typ
#heading(depth:1)[kapitola nejvyšší úrovně]

#heading(depth:2)[kapitola druhé úrovně] 

#heading(depth:2, 
        outlined:false,
        numbering:none)[
  kapitola druhé úrovně nečíslovaná (`numbering`) 
  a nevložená (`outlined`) do obsahu]
```

Nadpis má kromě parametru (atributu) `depth` i  parametr `level`. Obecně by se měl nastavovat parametr `depth`, který je relativním zanořením. Absolutní úroveň (`level`) se počítá jako `depth + offset`, kde `offset` je typicky nula, ale lze ho nastavit na kladnou hodnotu, pokud například vkládáme dokument jako část jiného a potřebujeme posunout (typicky snížit) úroveň kapitol ve vložením dokumentu.


Pro titul celého dokumentu lze využít funkci `title`, který vysází titul v podobě elementu nejvyšší úrovně.

```typ
#title[O životě jepic]
```

Často se uvádí i volání této funkce bez parametru. V tomto případě se použije název uvedený elementu `document`, který primárně tvoří součást metadat připojených k PDF souboru (nemá smysl mít jiný titul v metadatech a jiný vysázený v dokumentu).

== Národní specifika

_Typst_ zvládá sazbu v různých jazycích. Stačí jen určit v jakém jazyce je daný text vytvořen.
Nastavení jazyka se promítá do dělení slov, použití tzv. chytrých uvozovek a také v překladu generovaných slov.

Jazyk je vlastností obsahu vytvářeného funkcí `text` a tak ho lze lokálně nastavit pomocí příslušného argumentu:

#show-and-run(
  ```typ
  #text(lang: "cs")[Toto je český text využívající "chytré uvozovky" a správné dělení slov.]

  #text(lang: "en")[This is an English text using “smart quotes” and correct word hyphenation.]

  #text(lang: "he")[זהו טקסט עברי המשתמש ב"מירכאות חכמות" ובשבירת שורות נכונה.]
  ```
)

Správným nastavení jazyka všakl nezajišťuje zcela správnou a dokonalou sazbu. Některá národní specifika _typst_ neřeší. V češtině mezi ně patří pravidlo o nezalamování řádků po jednopísmenných slovech (předložkách a spojkách) resp. mezi úzce svázanými slovy (například mezi číselnou kvantitou a fyzikální či jinou jednotkou). Zde je nutné vkládat nezalomitelné mezery pomocí znaku tilda/vlnka (`~`).

#show-and-run(
  ```typ
  V~lese byla teplota jen 30~°C (správněji s úzkou nezalomitelnou mezerou 30\u{202f}°C)
  ```
)

Pokud se podíváme na požadavky, které kladou výše uvedené požadavky, snadno zjistíme, že:
+ v českém dokumentu jsme nuceni každý souvislý text v každém odstavci označit jako český
+ ručně vkládat nezalomitelné mezery 
+ pamatovat si Unicode pozici každého užitečného znaku, který není na klávesnici ani nemá přiřazen nějaký náhradnní znak

Naštěstí typst nabízí řešení, která všechny tyto problémy řeší a navíc nám umožňují vytvářet dokumenty s jednotným vzhledem.

= Konfigurace a vlastní funkce

== Proměnné

_Typst_ jako hybrid mezi značkovacím a programovacím jazykem samozřejmě podporuje i proměnné, tj. pojmenované odkazy na hodnoty. Proměnné se definují a zároveň inicializují v příkazovém režimu uvozeném konstrukcí `#let`.  Pro vložení hodnoty (definované a inicializované) proměnné se děje zápisem `#identifikátor`.

#show-and-run(
  ```typ
  #let giga = calc.pow(2, 30)

  Gigabyte má #giga bytů.

  #let tsp = "\u{202f}" // tight nonbreaking space
  #let gC = tsp + "°C" // grade of Celsius

  V lese bylo 30#gC.

  ```
)

Všimněte si, že _typst_ podporuje i řetězce (v příkazovém režimu v uvozovkách). Ty se od textového obsahu (v hranatých závorkách) liší tím, že se jedná o posloupnost znaků, které neinterpretují jako  značkovací jazyk (tj. zůstáváme v příkazové režimu). V našem případě (kde řetězce neobsahují žádné řídicí znaky) by bylo možno použít i textový obsah tj. `[\u{202f}]` resp. `[°C]` (řetezce jsou micméně paměťově výrazně efektivnější).

Proměnné lze samozřejmě využívat i příkazovém režimu. Obecnou možností, jak vstoupit do rozsáhlejší příkazové sekce je použití programového bloku (ohraničeném složenými závorkami) za znakem `#`.

#show-and-run(
```typ
#{
  import "@preview/oxifmt:1.0.0": strfmt
  let giga = calc.pow(2, 30) // definice a inicializace
  let ratio = giga / 1e9
  ratio = 100 * ratio // toto není definice jen přiřazení
 
  box(image("important.png", width:14pt), baseline: 3pt)
  "  "
  [Gibibyte má #strfmt("{}", giga, fmt-thousands-separator: " ") bytů, což je cca o #calc.round(ratio - 100) %  více než dekadický gigabyte!]
}
```)

Blok zde nejen určuje rozsah příkazového režimu (končí uzavírací složenou závorkou), ale definuje oblast viditelnosti proměnné. Ty definované uvnitř bloku jsou viditelné jen v něm a na konci jeho provádění zanikají (popřípadě zastiňují stejnojmené proměnné v nadřazených blocích).

Specifickým rysem je programových bloků v _typstu_ je to, že produkují výstup. A ještě specifičtější je skutečnost, že *výstup produkují všechny příkazy v programovém bloku*. Ty musí produkovat buď prázdnou hodnotu `none` (pak je výstup ignorován) nebo hodnoty, které lze spojit do textového obsahu (typicky dílčí textové obsahy nebo řetězce).

V našem případě je nejdříve provede příkaz `import`, který naimportuje funkci `strfmt` z modulu třetí strany, který je k dispozici v repozitáři tzv. #link("https://typst.app/universe/")[univerzu].

Následují dvě definice a inicializace proměnných (jsme v příkazovém režimu tudíž bez `#`). Paje hodnota proměnné `ratio` změněná. Protože se jedná o přiřazení do existující proměnné není nutné uvádět `let`. Všechny tyto příkazy vrací hodnotu `none` a tak se neprojeví ve výstupu. 

To však už neplatí pro vložení vnitrořádkového obrázku (obrázek je běžně blokový, ale uzavřením do funkce `box` zajistíme, že bude zarovnám k účaří následujícho textu (resp. míeně posunut dolů díky argumentu `baseline`). K němu bude připojen řetezec obsahující dvě mezery (obě budou zobrazeny, což by u textového obsahu neplatilo).

Zbytek řádku pak tvoří dílčí textový obsah v hranatých závorkách (ty jsou zde povinné!). V něm se dostáváme opět do markup režimu, kde je nutné při volání funkce použít znak `#` (čímž se ocitáme znovu v příkazovém).

Programový blok (složené závorky) se tak podobá textovému obsahu (hranaté závorky). V některých případech lze volit jaké seskupení použijeme.

Následující příklad vkládá blok textového obsahu. Protože se hranatými závorkami vracíme do markup režimu, je nutné u funkcí a `let` psát `#` (u přiřazení navíc nelze `let` vynechat). Na druhou stranu ušetříme složené závorky při vkládání dílčího textového odkazu.

Mírně se komplikuje i vkládání více mezer (ty jsou v markup režimu ignorovány). Obecně je však lepší vkládat horizontální mezery funkcí `h` (vertikální meziblokové se vkládají pomocí `v`).

#show-and-run(
```typ
#[
  #import "@preview/oxifmt:1.0.0": strfmt
  #let giga = calc.pow(2, 30) // definice a inicializace
  #let ratio = giga / 1e9
  #let ratio = 100 * ratio // toto není definice jen přiřazení
 
  #box(image("important.png", width:14pt), baseline: 3pt)
  #h(0.5em) // lepší než ["  "]
  Gibibyte má #strfmt("{}", giga, fmt-thousands-separator: " ") 
  bytů, což je cca o #calc.round(ratio - 100) % 
  více než dekadický gigabyte!
]
```)

Podobnost obou konstrukcí jde ještě dále. I uzávorkovaný textový obsah  tvoří oblast viditelnosti tj. v něm definované proměnné jsou v něm lokální.

== Uživatelské funkce

_Typst_ umožňuje definovat vlastní funkce. Ty mohou zpracovávat libovolné typy hodnot. Nicméně my se – nikoliv překvapivě –#footnote[tento text není navzdory použití skutečné pomlčky generován AI chatbotem. Pomlčky jsem používal mnoho let před nástupem AI a dokonce je dokáži vložit pomocí klávesnice.#emoji.face (emoji bylo vloženo pomocí `#emoji.face`)] zaměříme na funkce, které formátují či alespoň vytvářejí textový obsah. Pro zpracování numerických dat či rozsáhlých řetězců jsou vhodnější jiné jazyky.

Funkce se definuje pomocí konstrukce `let`. 

#show-and-run(
```typ
#let important(body, level: 1) = {
  if level == 1 {
    emph(body)
  }
  else if level == 2 {
    strong(body)
  }
  else if level == 3 {
    highlight(body)
  }
  else if level > 3 {
    box(text(body, fill: white), fill: red, inset: 3pt)
  }
  else {
    panic("Level of importance must be positive!")
  }
}

A nyní použití: #important[méně důležité], #important(level: 2)[důležitější], #important(level:3)[opravdu důležité] a #important(level:4)[kriticky důležité].
```)

A co se stane, pokud použijeme zápornou hodnotu?

```typ
#important(level:0)[zcela bezvýznamné]
```

 Funkce `panic` přeruší překlad a vypíše chybu. Takto takto vypadá ve Visual Studiu:

 #figure(
  image("screenshot1.png"),
  caption: [Signalizace panického stavu ve VS Code]
 )

 Všimněte si zčervenalého počitadla slov vpravo na stavovém řádku a samozřejmě i chybové hlášky ve výstupu překladače vlevo dole (ti nejpozornější i lokace chyby jako červené tečky v pravém okraji editoru kódu).
 
 Definice funkce není překvapivá. Na rozdíl od proměnné je na levé straně inicializačního přiřazení identifikátor následovaný závorkami se skutečnými parametry. První je poziční a předává se v něm zvýrazňovaný textový obsah (ten bývá běžně vymístěn). Druhý je pojmenovaný, neboť má implicitní hodnotu. 

 Tělo funkce (programový blok) používá konstrukci `if/else if/else`, která vás jistě nepřekvapila. Jednotlivé větve musí být bloky (nejčastěji programovými ale i bloky textového obsahu). Jsou to zcela běžné bloky, tj. generují výstup a poskytují lokální prostředí (čehož zde není využito).

 Funkce (nad textovým) obsahem by měly být primárně využívány pro podporu sémantického prvků. Obecně totiž není vhodné přímo vkládat typografické specifikace, neboť:

 + požadavky na typografické prvky symbolizující danou sémantiku se mohou změnit (například nám přestane vyhovovat bílý text na rudem pozadí pro kriticky důležití texty) a je velmi obtížné je měnit u každého výskytu
 + kód dokumentu je přehlednější a snadněji se upravuje
 + sémantiku lze využít pro zvýšení přístupnosti textu pro nevidomé a slabozraké
 + sémantické prvky lze snadno vyhledávat a tak vytvářet různé rejstříky apod.

Pokud například chcete vizualizovat jméno (softwarových) produktů, lze vytvořit tuto funkci:

#show-and-run(
```typ
#let product(name, trademark: false, url:none) = {
  smallcaps[#name]
  if trademark [\u{00ae}] else []
  if url != none {
    h(0.2em)
    link("https://typst.app", 
          box(rect(width:4pt, height:4pt, fill:blue)))
  } else []
}

Pro vytvoření manuálu byl využit 
#product(url:"https://typst.app")[typst] 
a #product(trademark: true, url: "https://code.visualstudio.com")[Microsoft Visual Studio Code].
```)

Produkt je vysázen pomocí kapitálek (_small caps_), může k němu být připojen znak registrované známky (\u{00ae}) a nepovinně i modrý čtvereček sloužící jako odkaz na domovské stránky produktu (čtvereček neni optimální, ale nechtělo se mi hledat vhodnou ikonku).

Ve větveních je použito jak bloků programových tak s textovým obsahem (vždy ten co umožnňuje stručnější zápis, pro prázdný text se dává přednost zápisu `[]` před `{}` protože jednoznačnějši signalizují textový výstup). Funkce `box` je využita, aby z blokového `rect` učinila vnitrořádkový obsah (jinak by byl ukončen odstavec).

Pomocí vlastních funkcí lze program sémanticky strukturovat a lze pomocí nich nahradit vestavěné funkce, pokud vám nevyhovuje jejich výstup. Ve svém důsledku by však činili program nepřehlednější, neboť pro ně nelze předefinovat řídicí znaky, zjednodušenou syntaxi (například odstavce by nestačilo oddělovat prázdnými řádky) a vznikali by hluboce zanořené struktury bloků s textovým obsahem (výjimkou by nebyly celé dlouhé sekvence znaků `]`). Jinak řečeno text by se příliš nelišil od HTML.

_Typst_ proto nabízí dva nepříliš typické prostředky, které tento problém řeší. Začněme tím jednodušším.

== Konstrukce `set`<chap-set>

Konstrukce `set` umožní nastavit implicitní hodnoty atributů u objektů, které vznikají voláním funkcí v rámci aktuálního kontextu, tj. globálně v rámci celého dokumentu, či lokálně v těle programových a textových bloků. Ne všechny parametry předané ve volání konstrukčních funkcí jsou nastavitelné(v dokumentaci musí být označeny jako _settable_).

#show-and-run(
  ```typ
  #[
#set par(
    justify: true, // zarovnání do bloku
    spacing: 1.5em, // meziodstavcová mezera
    leading: 1em  //meziřádkový proklad
)
#lorem(20)

#lorem(56)
]
  ```, crop: true
)

Zda nastavujeme, že každý odstavec (vytvořený explicitně funkcí `par` nebo automaticky) bude mít nastaven atribut `justify` na `true` (budu zarovná do bloku), řádky budou mít větší proklad (řádkování 2) a odstavce budou odděleny větší vertikální mezeru. To se bude týkat všech odstavců od daného příkazu `set` do konce kontextu. Pokud tedy tento příkaz uvedeme na začátku dokumentu bude se týkat všech odstavů dokumentu.

Podobně lze nastavit velikost stránky. Ta se sází pomocí funkce `page`, která se ale běžně nevolá přímo, ale je automaticky volána po každém zalomení stránky. Tak lze nastavit velikost papíru, okrajů i číslování stránek.

```typ
#set page(
  paper: "iso-b5",
  margin: (x: 1cm, top: 1cm, bottom: 1.5cm),
  numbering: "1"
)
```

Většinou se toto nastavení děje na začátku dokumentů (před prvním textovým obsahem), ale lze ho provést kdekoliv. V tomto případě vede k nucenému odstránkování a od nové strany platí nové nastavení.

Velmi podobně lze nastavit i parametry funkce `document`. Ta se automaticky aplikuje na celý text a její hlavní funkcí je nastavení metadat.

```typ
#set document(
    title: "Typst pro programátory",
    author: "Jiří Fišer"
)
```

Podobně lze nastavit i chování výčtů, například číslování:

#show-and-run(
  ```typ
  #[
#set enum(numbering: "I.1.a.", 
          full:true, 
          body-indent:1em)
//první úroveň: římské číslice
//druhá úroveň: arabské číslice
//třetí úroveň: malá písmena
// na konci vždy tečka

+ #lorem(20)
  + dolor
  + amet
    + tema
    + meta

+ #lorem(21)
  + labore
  + dolore
]
  ```, crop: true
)

Dalším běžným příkladem je nastavení výčtů. Snadno lze změnit odrážky u nečíslovaných výčtů:

#[
#set list(marker: (text(size:14pt)[•], text(size:14pt)[◦]))

- první úroveň
  - druhá úroveň
    - třetí úroveň
      - čtvrtá úroveň
]

*Úkol:* Změňte číslování standardního výčtového seznamu tak, aby bylo složené s úrovněmi velká písmena, číslice a malá písmena.

Jak už bylo řečeno změny mohou být i  lokální. To se hodí, pokud vytváříme vlastní prostředí, které mění chování blokových prvků, typicky odstavců. 

Jako příklad uveďme prostředí pro sazbu poezie. U poezie se dlouhé verše zalamují s odsazením pokračovacích řádků (aby bylo možné snadno odlišit jednotlivé verše a sloky).

#show-and-run(
  ```typ
#[
#let verse(hanging-indent: 2em, body) = block[
#set par(
    hanging-indent: hanging-indent, // odsazení pokračovacích řádků
    leading: 0.8em, // proklad mezi řádky u pokračování 
    spacing: 0.8em  // proklad mezi verši (shodný s výše uvedeným)
)

#body // zde se vysází celá báseň
]
#let strofa = v(1em)

#verse[
// Ukázka sazby poezie (K. H. Mácha - Máj)
One’s-self I sing, a simple separate person,

Yet utter the word Democratic, the word En-Masse.

#strofa
Of physiology from top to toe I sing,

Not physiognomy alone nor brain alone is worthy for the Muse, I say
  the Form complete is worthier far,

The Female equally with the Male I sing.

#strofa
Of Life immense in passion, pulse, and power,

Cheerful, for freest action form’d under the laws divine,

The Modern Man I sing.]

#align(right)[Walt Whitman, LEAVES OF GRASS]
]
```, crop: true
)

Toto řešení není zcela dokonalé, neboť verše je nutné vkládat jako odstavce a sloky je nutné oddělovat explicitně pomocí proměnné `strofa` (rozvine se na vertikální mezeru). Existuje i dokonalejší řešení, ale vyžaduje mnohem více kódu (a verše myslím nesázíte příliš často).

Určitým nedostatkem je také definice proměnné `strofa`, která je viditelná i mimo prostředí básně (tj. mimo textový obsah předané básně), což není ideální (mimo prostředí básně ji nemá smysl používat). 

Funkci však nelze definovat uvnitř těla funkce, neboť pak je viditelná jen v tomto bloku a nikde jinde. Týká se to i argumentů tj. i předaného textu `body`.  Důvodem je skutečnost, že _typst_ (zcela správně) používá tzv. lexikální vazbu proměnných (_lexical scoping_) nikoliv dynamickou. Funkce resp.  blok tak vidí proměnné platné v místě, v němž jsou definovány (vytvořeny), nikoliv v místě svého zpracování tj. volání či rozvinutí. 

Použití konstrukce `set` má však své limity. Předpokládejme, že chceme změnit typ produkovaného funkcí `emph`.  

```typ
#set emph(font: "Cambria")
```
Přímočaré řešení ale nefunguje, protože funkce `emph` nemá parametr `font`. Podle dokumentace totiž nemá žádný jiný parametr než textový obsah.

#figure(
  image("doc-emph.png"),
  caption: [Dokumentace parametrů funkce `emph`]
)

Proto _typst_ nabízí ještě mocnější prostředek.

== Konstrukce `show`

Konstrukce `show` se na první pohled může jevit magická. Umožňuje totiž dynamicky vložit (injektovat) nastavení či dokonce kód do cizích funkcí (včetně vestavěných). Navíc se vyskytuje v několika různých podobách. Nejdříve se podívejme na tu nejjednodušší a také nejčastěji používanou.

=== `set` aplikované pomocí `show`

Tato verze konstrukce `show` umožní do těl existujících formátovacích funkcí vložit (přimíchat, injektovat) nastavení, které se následně projeví ve volání vnořených funkcí. 

Využijeme to v případě funkce `emph`. Ta totiž svého těla volá funkci `text` pro vlastní sazbu textu.

#show-and-run(
```typ  
#[
#show emph : set text(weight: 550)

A hned to vyzkoušíme _zvýrazněný text_.
]
```, crop: true)

Prvním parametrem konstrukce `show` je *selektor*. Ten určí, do jaké konstrukce se bude injektovat. Zde je to jméno funkce `emph` a tudíž se projeví při každém následném volání této funkce (navíc může být omezeno kontextem závorkového bloku).

Po dvojtečce je pak nastavení, které se bude injektovat. V tomto případě je to nastavení argumentu
u funkce `text` (to se však bude týkat jen volání `text` uvnitř `emph`).

Nastavení nastavuje tučnost jako na hodnotu 600. To lze u tzv. variabilních fontů#footnote[v omezené míře to bude fungovat i u fontů nabízejících více řezů tučnosti s názvy jako _SemiBold_, _ExtraBold_ apod, kde se využije nejbližší vhodný stupeň], které podporují osu tučnost (_weight_) a může nabývat hodnot 100 až 900. Hodnota 550 je méně tučná, než standardní tučný text (je bližší polotučné).

Podobně lze nastavit i písmo pro nadpisy. I ty používají pro vlastní sazbu funkci `text`.

```typ  
#show heading : set text(size: 28pt)

= Nadpis //první úroveň: bude mít velikost 28pt
== Nadpis //druhá úroveň: bude mít velikost též 28pt
```
Toto nastavení se však týká všech úrovní odstavců, což není příliš vhodné. Selektorem však může být i složitější výraz:

```typ 
#show heading.where(level: 1): set text(
  size: 20pt
)

#show heading.where(level: 2): set text(
  size: 16pt
)

= Nadpis //první úroveň: bude mít velikost 20pt
== Nadpis //druhá úroveň: bude mít velikost též 16pt
```

Funkce `heading.where` vrací selektor, jemuž odpovídají nadpisy s atributem `level` rovným jedna, tj. s fyzickou úrovní 1. Do nich pak bude přímíšeno nastavení textu.

Ale ani to nemusí stačit. Předpokládejmě, že chceme u běžného zvýrazněného textu barevné (třeba šedé pozadí). Pozadí se u vnitrořádkových prvků nastavuje  pomocí funkce `box`. Proto zkusíme přimísit nastavení pozadí do prvku `emph`.

```typ
#show emph: set box(fill: luma(200))
```

Toto nastavení se ale neprojeví. Důvod je jednoduchý, funkce `emph` interně nevolá `box`, protože to nepotřebuje. Nezbývá než přitvrdit.

=== `show` s transformační funkcí

V `show` lze uvést transformační funkci, která získává původní výstup funkce a  může jej modifikovat. Transformační funkce se nejčastěji zadává v podobě lambda výrazu (anonymní funkce). Transformační funkci lze tedy chápat jako jakýsi dekorátor.

#show-and-run(
```typ  
#[
#show emph: (it) => {
  box(fill: luma(220), outset: 3pt)[#it] 
  // vrací puvodní obsah v boxu
}

testování: _zvýrazněný text_ a _velmi dlouhý zvýrazněný text delší než by bylo zdrávo pro šířku řádku_.
]
```, crop: true)

Výsledkem je text v šedivém obdélníku, který navíc není kurzívní (původní funkce se vůbec nevolá).

Tělo funkce může být komplexnější. Umístění do boxu má jednu podstatnou nevýhodu, kterou lze vidět na příkladě: v boxu nemůže dojít k zalomení řádku. Jedním z mnoha (nepříliš dokonalých řešení) je odlišné vyznačování pro delší řetězce (zde bez šedého boxu):


#show-and-run(
```typ  
#[
#show emph: (it) => {
  if(it.body.text.len() < 20) { // je-li zvýrazněno méně než 10 zn
    box(fill: luma(220), outset: 3pt)[#it] 
  }
  else { it }
  // vrací puvodní obsah v boxu
}

testování: _zvýrazněný text_ a _velmi dlouhý zvýrazněný text delší než by bylo zdrávo pro šířku řádku_.
]
```, crop: true)

Řešení vychází z interní podopy objektů. Objekt vytvořený funkcí `emph` má atribut `body` (to je zároveň i jméno argumentu funkce). To je textový obsah, který umožňuje svůj obsah získat v podobě řetězce pomocí atributu `text`. A řetězec má metodu vracející jeho délku (nikoliv ve znacích ale tzv. glyphech, který odpovídá vizuálnímu prvku)

V případě použití transformační může být selektorem i řetězec či regulární výraz. 

#show-and-run(
```typ  
#[
#show "Typst": it => {
  text(fill: red, weight: "bold", it)
}
#show "typst": it => {
  text(fill: red, weight: "bold", it)
}


Typst je program pro digitální sazbu. Hlavním výstupním formátem typstu je PDF.
]
```, crop: true)

Tento zápis lze přirozeně zkrátit a zpřesnit pomocí regulárního výrazu. 


#show-and-run(
```typ  
#[
#show regex("\b[Tt]ypst(u|em)?\b"): it => {
  text(fill: red, weight: "bold", it)
}


Typst je program pro digitální sazbu. Hlavním výstupním formátem typstu je PDF.
]
```, crop: true)

Podporované regulární výrazy (viz https://docs.rs/regex/latest/regex/#syntax) podporují základní perlovskou a POSIX syntaxi.

Použití těchto substitucí není obecně příliš užitečné. Ve specifických případech tomu však může být jinak:

```typ
#show regex("\b([vksuozaiVKSUOZAI])\s+"): it => {
    it.text.slice(0, 1) + [~]
  }
```

Tato substituce vkládá po jednopísmených předložkách a spojkách nezalomitelnou mezeru (`~`) namísto běžné a řeší tak většinu problémů spojených s českými typografickými požadavky.

= Pokročilá sazba

== Výpisy kódu

Pro výpisy kódu lze použít funkci `raw`, se kterou jsme se seznámily v @sec:inline[kapitole]. Pokud ale dodáme informaci o použitém programovacím jazyce, bude použito zvýraznění syntaxe (je-li daný jazyk podporován).

V případě vnitrořádkového výpisu je proto nutno použít explicitní volání funkce (nestačí zpětné apostrofy). 

Pro běžnější výpis kódu do bloku slouží syntaxe známá i z jiných markdown jazyků:

#show-and-run(
````typ
Výpis řetězce provedeme funkcí např. takto #raw("print('Hello world')", lang: "python").

```python
def gcd(a: int, b: int) -> int:
    """Vrátí největšího společného dělitele čísel a a b."""
    a, b = abs(a), abs(b)

    while b != 0:
        a, b = b, a % b

    return a

```
````)

== Číslované sekce a odkazy<sec:refs> 

Pro mnohé typy dokumentů jsou typické číslované sekce opatřené popiskem, které jsou díky tomu 
snadno odkazovatelné (není nutné např. psát "obrázek nahoře na straně X", ale stačí obrázek X). Běžně se tak označují obrázky, tabulky a výpisy kódu ale lze si představit i další.

V _typst_ lze takové sekce vytvářet pomocí funkce `figure`. Nenechte se zmýlit názvem, neslouží jen pro obrázky, ačkoliv je to nejčastější použití.

#show-and-run(
```typ
#figure(
  image("rotunda.jpg", width: 50%), //standardní šířka je 100%
  caption: [Rotunda na Řípu] // popisek
)<fig:rotunda>

Na @fig:rotunda[obrázku] je kostel svatého Jiří na Řípu. Stručné (@fig:rotunda) není pro češtinu příliš vhodné. 
```
)

Odkazy jsou v PDF samozřejmě hypertextové (stačí kliknout a dojde k přesunu).

Vytváření odkazů na číslované sekce je snadné.
První fází je připojení návěští k odkazovanému (a odkazovatelnému) prvku. Návěští je uzavřeno v lomených závorkách (tj. mezi znaky menší a větší než). Může to být libovolný identifikátor tvořený písmeny a znaky `_-:.`, ale je praktické  užívat prefix podle typu objektu.

Vlastní odkaz se pak píše za zavináč (`@`). Teoreticky by měl stačit identifikátor návěští, neboť systém použije tzv. `supplement`, jenž je definován pro každý druh číslovaných sekcí a obsahuje název prvku. Pro češtinu je sice přeložen, ale s počátečním velkým písmenem a jen v prvním pádě (to stačí jen pro popisek). Je proto vhodné přidat správný tvar jako parametr (typicky v přidaném bloku).


Podovně fungují i odkazy na kapitoly (a také matematické vzorce, viz kapitola XXX).

```typ
== Odkazy<sec:refs>
```

#show-and-run(
  ```typ
  nacházíme se v @sec:refs[kapitole]
  ```
)

Jak už bylo řečeno i pro ostatní číslované sekce se používá funkce `figure`, do níž se ale nevloží obrázek (`image`) ale jiný prvek. Některé jsou automaticky rozpoznány a je vygenerován správný prefix popisku i nezávislé číslování. V ostatních případech lze vytvořit vlastní typ pomocí argumentů `kind` a `supplement`.

#show-and-run(
````typ 
#show figure.where(kind: raw): set align(left)

#figure( //automaticky bude typu výpis
```python
if world:
  print("Hello world")
```, caption: "Fragment programu v Pythonu",
)<code:ifworld>

Téměř filozofickou hloubku ukazuje @code:ifworld[výpis].

#figure( //vlastní typ číslovaných prvků
  [_Spojaři všech zemí, proletujte se!_],
  kind:"aphorism",
  supplement: "Aforismus",
  caption: [parafráze komunistického hesla]
)<aphorism:prolet>

Letování je nezbytnou součástí spojařova know-how viz @aphorism:prolet[aforismus] na #ref(<aphorism:prolet>, form: "page", supplement: "straně").
````)

Počáteční injektování slouží ke změně zarovnání obsahu uvnitř `figure`, které je běžně horizontálně vycentrováno, což není příliš vhodné pro výpisy (vedlejším efektem je i změna zarovnání popisku)

*Úkol*: Doplňte nastavení tak, aby obsah prostředí pro aforismy byl automaticky v kurzívě.

Konec poslední ukázky presentuje i druhou možnost, jak odkazovat části textu – pomocí čísla stránky.  Zde je však nutno použít volání funkce `ref` a kromě návěšti dodat i atribut `form` s hodnotou `"page"`a v češtině též i `supplement` (implicitní je "strana"). To je sice trochu dlouhé, ale lze to zkrátit pomocí uživatelské funkce:

#show-and-run(
  ```typ
#let pref(target, 
          supplement: "straně") = ref(target, supplement: supplement, form: "page")

<par:test>Tento odstavec začíná na #pref(<par:test>). 
//@par:test použít nelze
```)
 Všimnněte si také že návěští může být v tomto případě umístěno téměř kdekoliv (zde na začátku odstavce)

== Tabulky

Jako každý sazecí program, který si zaslouží toto označení, podporuje _typst_ i sazbu tabulek. Vytváření jednoduchých tabulek je snadné.

#show-and-run(
```typ  
#table(
  columns: 3,
  [*země*], [*obyvatelé*], [*umístění*],
  [Kraj], [hobiti], 
     [v Eriadoru na západ od řeky Brandyvíny a na východ od Dalekých vrchů.],
  [Gondor], [lidé], 
    [v jižní části severozápadního cípu Středozemě v Belfalaské zátoce při ústí řeky Anduiny.],
  [Lórien], [elfové], 
    [na soutoku Stříberky a Anduiny]
)```)

Základní pravidla jsou zřejmá. Stačí specifikovat počet sloupců (řádky se dopočítají podle obsahu) a jednotlivé buňky (v pořadí zleva doprava a shora dolů) se uváději jako textový obsah (zde v podobě bloků, ale může to být např. i funkce produkující textový obsah).

Pozitivní je to, že i bez formátování je tabulka relativně dobře naformátovaná (rozhodně nic nechybí a nic nepřetéká).

 Pro tisk ale není tabulka optimální. Vhodnější by bylo omezit oddělovací čáry (především svislé a zvýraznit záhlaví). Vhodné je také umět specifikovat zarovnání obsahu sloupců a jejich jejich šířku.

#show-and-run(
```typ 
#show table.cell.where(y: 0): strong //tučný obsah prvního řádku

#set table(
  fill: (_, y) => 
    if y == 0 {luma(230)} // první řádek
    else {if calc.odd(y) { blue.lighten(90%) }}, //střídavě
  stroke: (_, y) => ( y: if y == 0 {1pt}, x: none)  
)

#table(
  columns: (auto, 1fr, 3fr), /// specifikace šířky
  align: (left + horizon, center + horizon, left), // a zarovnání
  table.header[země][obyvatelé][umístění],
  [Kraj], [hobiti], 
     [v Eriadoru na západ od řeky Brandyvíny a na východ od Dalekých vrchů.],
  [Gondor], [lidé], 
    [v jižní části severozápadního cípu Středozemě v Belfalaské zátoce při ústí řeky Anduiny.],
  [Lórien], [elfové], 
    [na soutoku Stříberky a Anduiny]
)```)

Obsah buňky se nastavuje přes funkci `table.cell`, která očekává pozici buňky (počítá se od nuly). První řádek (y = 0) je záhlaví.

Globální vlastnosti tabulky se nastavují přímo v `set table`. V našem případě se nastavuje výplň `fill` a čáry `stroke` pomocí (anonymních funkcí) funkcí (ty přijímají pozici vykreslované buňky). Na základě pozice vyplňují první řádek (záhlaví) šedě a u ostatních střídají barvy (liché jsou světle modré). Čáry vykreslují jen u prvního řádku a to jen vodorovné (v ose _y_). 

Všechna tato nastavení se budou týkat všech tabulek (obecně je vhodné mít stejný formát u všech tabulek). 

U konkrétní tabulky tak stačí doplnit jen specifikaci šířky sloupců (namísto jejich počtu). V našem případě jsou to tři sloupce. První má automatickou šířku (podle obsahu) o zbytek šířky tabulky (implcitně přes celou šířku stránky) se zbývající sloupce podělí v poměru 1/4 a 3/4.

Podobně se v podobě pole (o stejné délce) specifikuje zarovnání. První sloupec je zarovnán vlevo a vertikálně doprostřed (_typst_ používá pro vertikální vystředění slovo `horizon`).

Pak už stačí jen specifikovat obsah buněk. Buňky záhlaví jsou vloženy funkcí `table.header`, což neovlivňuje formátování, ale:
- při zalomení tabulky se záhlaví opakuje
- ve čtečce pro nevidomé bude interpretováno jako záhlaví. 

U některých tabulek se používají buňky roztažené přes několik sloupců a řádků. Ty lze vložit explicitním voláním funkce `table.cell`s argumentem `colspan` resp. `rowspan`.

#show-and-run(
```typ  
#table(
  columns: 4,
  ..(4 * ([],)), //na tomto řádku začíná obsah tabulky
  [], table.cell([], colspan: 2, rowspan: 2, fill:blue), [],
  [],                                                    [],
  ..(4 * ([],)) 
)```)

Zápis `4 * ([],)` vrací 4× opakované jednoprvkové pole (to musí obsahovat nadbytečnu čárku, aby bylo zřejmé, že jde o pole). Tento zápis je obdobný Pythonu (kde se neměnná pole označují jako _tuple_ tj. n-tice). Toto pole se pak rozvine do (čtyř) argumentů, pomocí _spread_ operátoru (obdoba operátoru `*` v Pythonu, kde se označuje jako _unpacking_ operátor).

== Matematická sazba

_Typst_ podporuje sazbu matematiky a navenek používá stejný přístup jako _TeX_. Matematika se vkládá mezi znaky `$` a uvnitř platí jiný režim než v běžném (markup) textu. Přesto existují značné rozdíly v syntaxi, které lze shrnout takto:
- matematické proměnné (zapisované kurzívou) jsou jednoznaková slova (víceznakové proměnné lze zapsat pomocí řetězce)
- víceznaková slova označuji funkce nebo matematické symboly (symboly mají často složená jména)
- lomítko funguje jako zlomek (není nutné používat funkci `frac` )
- podvýrazy se seskupují pomocí kulatých závorek (systém sám pozná, kdy se mají zobrazovat a kdy nikoliv)
- vnitrořádkové a blokové vzorce se odlišují tím, že *blokové musí mít mezeru za počátečním znakem `$` a také mezeru před koncovým dolarem*.

#show-and-run(
```typ
#[
#set math.equation(numbering: "(1)")
// nutné pro zapnutí číslování blokových vzorců

$ x = sum_(i=1)^n 1/a_i $ <eq:sum>

Suma ve vztahu (@eq:sum[]) sčítá prvky posloupnosti
$1/a_1, 1/a_2, dots, 1/a_n$ tj.
$1/a_1 + 1/a_2 + dots.h.c + 1/a_n$
]```, crop: true)

Nastavení číslování pro vzorce je nutné jen v případě, kdy je chcete odkazovat. Zápisy se podobají LaTeXu jsou však o něco jednodušší. Pro srovnání (@eq:sum[]) by v LaTeXu měla tento tvar: 

```tex
$x=\sum_{i=1}^n \frac{1}{a_i}$
```

Přehled podporovaných symbolů najdete na https://typst.app/docs/reference/symbols/sym.

Podporovány jsou samozřejmě i další komplexnější zápisy:

#show-and-run(
```typ  
$ "e" = lim_(n -> infinity) (1 + 1/n)^n $```)

#show-and-run(
```typ 
$ det mat(1, dot(a); 0, 5) =  mat(1, a; 0, 5, delim: "|") = -5 $```)


#show-and-run(
```typ 
$ "sig"(x) := cases(
  -1 "if" x < 0,
  0 "if" x = 0,
  1 "if" x > 0
) $
```)

#show-and-run(
```typ 
$ f : X stretch(->, size: #150%)_"surjekce" Y $
```)

#show-and-run(
```typ 
$ NN_1 = NN_0 - {1} = sans(N) = cal(N) $```)

#show-and-run(
```typ 
$ overbrace(0 \, 1\, dots \, n, n + 1 "čísel!") $
// čárky je nutné escapovat (jinak se chápou jako oddělovače parametrů)
```)

=== Písma pro sazbu matematiky

Pro sazbu matematiky jsou vhodné jen některé OTF fonty (běžně se poznají podle přídomku _Math_ v názvu fontu). Pokud například chceme dosáhnout neformálnějšího vzhledu (např. v presentacích) lze využít font _ Pennstander Math_ či _Fira Math_.

#show-and-run(
```typ 
#[
#show math.equation: set text(font: "Pennstander Math")
$ x = sum_(i=1)^n 1/a_i $
]
```, crop: true)

#show-and-run(
```typ 
#[
#show math.equation: set text(font: "Fira Math")
$ x = sum_(i=1)^n 1/a_i $
]
```, crop: true)

= Šablony

V této kapitole si popíšeme proces vytvoření jednoduché šablony pro sazbu jednoduchého dokumentu. Dokumnr by měla být opatřen jednoduchým titulním listem, obsahem a seznamem použité literatury. Pro přehlednost by stránky měly být opatřeny záhlavím a číslováním.

== Šablonová funkce

Šablona je v _typstu_ nikoliv překvapivě funkce, která zajišťuje:
+ globální nastavení dokumentu
+ zobrazení fixní části dokumentu (v našem případě titulního listu)

Tato funkce by měla být jeden povinný poziční parametr, který přijme textový obsah celého dokumentu a může mít i parametry pojmenované (typicky údaje o titulu, autorech, apod.)

Pro snadnější použití se šablonová funkce umisťuje do zvláštního modulu v podobě běžného _typst_ souboru, který však na nejvyšší obsahuje jen (exportovatelné) funkce.

Náš modul se bude jmenovat _siminarka.typ_. Jeho základní strukturu ukazuje následující výpis.

```typ
// funkce importovatelné z modulu
// (a přímo viditelné v šablonové  funkci

#let template(doc, title: "Titul práce", author: "Autor") = {
 // funkce používané jen v šablonové funkci (nejsou vidět v dokumentu)

 // globální nastavení

 // sazba titulního listu (stránky)

// nastavení stránky zápatí a záhlaví

// sazba obsahu

  #doc

// sazba bibliografie 
}
```

Použití šablony je snadné. Na začátku dokumentu je nutné z modulu importovat funkce (včetně šablonové). A následně stačí šablonovou funkci zavolat na zbytek dokumentu. Většinou se tak děje pomocí speciální formy konstrukce `show`.

```typ
#import "mydoc.typ": * //importujeme všechny funkce

#show: template.with(
  title: "¨Proč jsem  (ještě) Pythonista?",
  author: "Jiří Fišer")
```

Tato forma nemající selektor zavolá funkci na zbytek dokumentu. Funkce proto musí mít očekávat jediný poziční parametr typu textový obsah. Šablonovou funkci by bylo možno použít přímo (má jediný povinný poziční parametr), ale pak by se použily implicitní (zde zcela zástupné) hodnoty. Metoda `with` volána na funkci tento problém řeší tím, že vrátí novou funkci, v níž jsou jsou určité pojmenované parametry navázány na fixní hodnoty. Zde jsou navázány všechny pojmenované parametry, tj. vrácená funkce má jen jediný parametr: dokument.


== Globální nastavení

```typc
set document(
    title: title,
    author: author,
  ) // metadata

  set page(
    paper: "a4",
    binding: left, //oboustranný tisk
    margin: (
      inside: 2.5cm,
      outside: 2cm,
      top: 2cm,
      bottom: 2cm,
    ),
  )

  set text( // nastavení hlavního textu
    lang: "cs",
    size: 12pt,
  )

  set par( // nastavení odstavců
    justify: true,
    leading: 0.65em,
  )

  // nastavení nadpisů kapitol
  set heading(numbering: "1.1")

  show heading: set text(
    font: "Roboto"
  )

  show heading.where(level: 1): it => {
    pagebreak(weak: true) //zalomení stránky před nadpisem
    it
  }

  show heading.where(level: 1): set text(
    size: 24pt,
  )

   show heading.where(level: 2): set text(
    size: 18pt,
   )

  show heading.where(level: 3): set text(
    size: 16pt,
  )

  // Česká jednopísmenná slova.
  show regex("\b([vksuozVKSUOZAI])\s+"): it => {
    it.text.slice(0, 1) + [~]
  }
```

== Titulní list

Titulní list je vysázen jako samostatná stránka bez záhlaví a zápatí (a číslování stránek).

```typc
page(
      header: none,
      footer: none,
      numbering: none,
    )[
      #align(center)[ // vycentrovaný obsah
        #set par(justify: false) // vypnutí zarovnání do bloku

        #text(size: 24pt, weight: "bold")[#title] //titul

        #v(0.6cm)

        #text(size: 20pt)[#smallcaps[#author]]

        #v(1fr) // odsune letopočet až na dolní konec stránky

        #let aktualni-rok = datetime.today().year()
        #text(size: 18pt, weight: "bold")[
          #numbering("I", aktualni-rok)]
      ]
    #pagebreak(to: "odd")
]
```

Příkaz `pagebreak` nejen, že zalamuje stránku, ale zajišťuje přesun na další lichou (tj. třetí). U oboustranného listu by měly všechny kapitoly nejvyšší úrovně (a jiný "čestný obsah" jako poděkování, apod.) začínat na liché tj. pravé stránce.

Jak vypadá výsledek je vidět na první dvojstraně dokumentu. Po titulním listě je vidět prrázdný list (označovaný jako vakát).

#grid(
  columns: (1fr, 1fr),
  [#block(stroke: 1pt)[#image("pythonist.pdf", width:100%, page: 1)]],
  [#block(stroke: 1pt)[#image("pythonist.pdf", width:100%, page: 2)]]
)

=== Obsah

Sazba obsahu je záležitostí volání jediné funkce a dokonce bez parametrů:

```typc
  outline()
```

#grid(
  columns: (1fr, 1fr),
  [#block(stroke: 1pt)[#image("pythonist.pdf", width:100%, page: 3)]],
  [#block(stroke: 1pt)[#image("pythonist.pdf", width:100%, page: 4)]]
)

Už z názvu funkce je slouží i k sazbě jiných přehledových seznamů. Pomocí argumentu `target` se selektorem lze určit jakýkoliv číslovaný prvek. Seznam číslovaných obrázků by tak měl tvar:

```typ
#outline(
  title: [List of Figures],
  target: figure.where(kind: image),
)
```
Dalším užitečným argumentem je `depth`, který u obsahu určuje do jaké hloubky zanoření budou zobrazovány nadpisy kapitol.

== Záhlaví a zápatí

Po sazbě titulního listu následuje nastavení stránky pro zbytek dokumentu. Zůstává velikost stránky okraje, je však nutno změnit formát záhlaví a zápatí. Počínaje obsahem je dole uprostřed vysázeno číslo strany (titulní list má číslo stránky 1, ale neuvádí se).

Součastí nastavení je i záhlaví. Toto záhlaví je kontextové tj. reflektuje své umístění v dokumentu a to ve dvou směrech:
+ zobrazuje název aktuální kapitoly nejvyšší úrovně
+ nezobrazuje se na první stránce kapitoly nejvyšší úrovně (neboť se v ní název kapitoly objevuje v nadpisu na začátku strány)

```typc
set page(
  numbering: "1",
  number-align: bottom + center,
  header: context {
    let current-page = here().page()
    let chapters = query(heading.where(level: 1))

    // Začíná na této stránce kapitola?
    let is-chapter-page = chapters.any(
      chapter => chapter.location().page() == current-page)

    //pokud to není první stránka kapitoly
    if not is-chapter-page {
      // Poslední kapitola začínající před aktuální stránkou.
      let previous-chapters = chapters.filter(
        chapter => chapter.location().page() < current-page)

      let chapter-title = if previous-chapters.len() > 0 {
        previous-chapters.last().body
      } else []

      set text(size: 11pt) //menší velikost písma

      grid(
        columns: (1fr, 1fr),
        column-gutter: 1em,

        align(left)[#title],
        align(right)[#chapter-title],
      )
    }
  },
)
```

Pokud by bylo záhlaví pevné, měl by atribut `header` podobu textového obsahu. Pro dynamické záhlaví je potřeba specifikace ve formě (bezparametrické funkce). Protože však výsledek závisí na aktuálním stavu dokumentu a místě jejího volání musíme využívat tzv. kontextový výraz.

Nutnost označování těchto funkcí vychází ze základní principy běhové běhové podpory. Běžná funkce v _typst_ je typicky tzv. čistá (_pure_), tj. pro stejné vstupy vrací vždy stejný výstup (návratovou hodnotu). To umožňuje provádět memoizaci (kešování výsledků) a výrazně usnadňuje paralelelní zpracování. Výjimkou jsou například funkce vracející čas, ale i ty lze v rámci překladu považovat za konstantní (podobně jako v databázové transakci).

Funkce, jež jsou závislé na kontextu, však nelze tak snadno optimalizovat. Tentýž výraz může na různých stránkách vytvořit různý výsledek. Všechny operace závislé na kontextových údajích proto musejí proběhnout uvnitř tohoto výrazu, neboť je mimo něj je výsledek nejednoznačný.

Platí to i tehdy, je-li je funkce volána jen jedenkrát. To souvisí souvisí s tím, že výsledná podoba dokumentu vzniká iterativně (ve více průchodech). V typickém případě první průchod první shromážduje údaje potřebné pro obsah a křížové odkazy, ve druhém je vysází, však může posunout stránkování a tím zneplatnit právě vysázené údaje. Typst proto sazbu opakuje až do stabilizace#footnote[na rozdíl od TeXu jsou tyto běhy interní a nevytvářejí pomocné soubory. Podobně jako v TeXu však může nastat situace, kdy ke stabilizaci nikdy nedojde tj. dokument nekonverguje. V takovém případě běh překladače skončí chybou po detekci takové situace, resp. varováním po překročení limitu počtu průchodů]. 

Z těchto důvodu je potřeba výrazy závislé na kontextu (okolním dokumentu) důsledně označovat slovem `context` (a naopak neoznačovat ty, které na kontextu závislé nejsou).

Vlastní kód využívá schopnosti prohledávání (`query`) paměťové representace dokumentu a nalezení všech prvků odpovídajících selektoru (viz konstrukce `show`, která však podporuje užší množinu selektorů). Tento mechanismus se podobá vyhledávání XPath vzorů v DOM representaci XML či HTML (vzory jsou jednodušší, ale vyhledávání je podstatně rychlejší).

Řešení vychází z možnosti získat fyzická čísla stránek aktuálně vytvářeného textu (v tomto případě záhlaví), tak i fyzické umístění kapitol (obecně libovolného prvku). Lze tak snadno identifikovat kapitolu, v níž se záhlaví nachází (poslední kapitola, jejíž nadpis se nachází před aktuální stránkou), tak i stránku s nadpisem (existuje nějaký [_any_] nadpis, jehož číslo fyzické stránky je rovné číslu aktuální stránky). Elegantně se přitom využívají funkcionální konstrukce (funkcionály = funkce, jež využívají funkce jako parametry) jako je `any` nebo `filter`. Řešení je navíc dostatečně robustní, neboť řeší i případy, kdy žádná taková kapitola nejvyšší úrovně neexistuje (v tomto případě je záhlaví prázdné).

Pro vlastní formátování záhlaví je použit `grid` o dvou sloupcích (a jediném řádku), kde oba sloupce si dělí šířku na půl a v každém je jiný údaj.

Na výsledek se můžete podívat. Všimněte si, že záhlaví je opravdu jen u stránek, kde nezačíná kapitola.

#grid(
  columns: (1fr, 1fr),
  [#block(stroke: 1pt)[#image("pythonist.pdf", width:100%, page: 5)]],
  [#block(stroke: 1pt)[#image("pythonist.pdf", width:100%, page: 6)]]
)

#grid(
  columns: (1fr, 1fr),
  [#block(stroke: 1pt)[#image("pythonist.pdf", width:100%, page: 7)]],
  [#block(stroke: 1pt)[#image("pythonist.pdf", width:100%, page: 8)]]
)

== Bibliografie

Vytváření seznamu zdrojů je _Typst_ snadné. Potřebujete jen dva soubory:

+ databázi bibliografických záznamů ve formátu pro BibLaTeX
+ styl pro formátování bibliografických záznamů (existují stovky různých stylů), _typst_ podporuje všeobecně rozšířený formát #link("https://citationstyles.org/")[CSL]. Některé běžné styly jsou dodávány přímo v _typstu_ (z nichž však žádný není český).

Databázi biblografických údajů je vhodné spravovat v citačním manažeru (jako je Zotero či Citace PRO) a z něho ji exportovat ve formátu BibLaTeX (pozor liší se od staršího BibTeXu, který je starší a má méně možností, nicméně je do značné míry kompatibilní s BibLaTeXem).

V ukázce je použit tento soubor s bibliografickými záznamy.

```bibtex
@book{beazley2002python,
  author    = {Beazley, David M.},
  title     = {Python},
  subtitle  = {Podrobná referenční příručka pro programovací jazyk Python},
  location  = {Praha},
  publisher = {Neocortex},
  year      = {2002},
  edition   = {1},
  pagetotal = {432},
  isbn      = {978-80-86330-05-1},
  langid    = {czech}
}

@online{peters2004zen,
  author       = {Peters, Tim},
  title        = {{PEP 20} -- The Zen of Python},
  organization = {Python Software Foundation},
  date         = {2004-08-19},
  url          = {https://peps.python.org/pep-0020/},
  urldate      = {2026-07-29},
  langid       = {english}
}

@article{vanrossum1991interactively,
  author       = {van Rossum, Guido and de Boer, Jelke},
  title        = {Interactively Testing Remote Servers Using the Python Programming Language},
  journaltitle = {CWI Quarterly},
  year         = {1991},
  volume       = {4},
  number       = {4},
  pages        = {283--304},
  date         = {1991-12},
  publisher    = {Stichting Mathematisch Centrum},
  location     = {Amsterdam},
  url          = {https://ir.cwi.nl/pub/18204},
  urldate      = {2026-07-29},
  langid       = {english}
}

@online{gruet_python_quick_reference,
  author  = {Gruet, Richard},
  title   = {Python Quick Reference},
  url     = {http://rgruet.free.fr/\#QuickRef},
  urldate = {2026-07-29},
  langid  = {english}
}

@book{proza_stredoveku_2019,
  title = {Próza českého středověku},
  translator = {Kolár, Jaroslav and Nedvědová, Milada},
  publisher = {Městská knihovna v Praze},
  location = {Praha},
  date = {2019-03-18},
  version = {1.0},
  note = {Vychází z původního vydání nakladatelství Odeon z roku 1983},
  url = {https://web2.mlp.cz/koweb/00/04/44/37/14/proza_ceskeho_stredoveku.pdf},
  urldate = {2026-07-29}
}
```

Vložení seznamu zdrojů (bibliografie) je už snadné. 

```typ
#bibliography(
  "source.bib",
  style: "iso690-numeric-brackets-cs.csl",
  title: "Zdroje" // nadpis

)```

#align(center)[#block(stroke: 1pt)[
#image("pythonist.pdf", width:50%, page: 9)
]]


= Typografický "tuning"

== Variabilní fonty

Již v dobách knihtisku se pro jednu rodinu písma (font) vytvářelo vice řezů v těchto dimenzích:
/ tučnost: od tenkého po tučné (často v několika úrovních)
/ kresba: kromě normální kresby se používala i kurzíva, kapitálky (pravé kapitálky nejsou jen vetrzálky zmenšené na velikost malých písmen)
/ šířka: od úzkého (_condensed_) po široké
/ stupeň (velikost): od chlebového (běžný tisk) po titulkové (ani v tomto případě nešlo o jen o geometrické zmenšení, menší ystupně jsou širší a tučnější, aby s lépe četly).

S příchodem digitální typografie atzv obrysových fontů (TTF, OTF) se u většiny fontů celý systém u běžných fontů zjednodušil na čtyři řezy písma (normální, tučné, kurzivní, tučné kurzovní). U profesionálnách fontů mohlo být řezů více, ale stále se jednalo o malé desítky (a každý ve zvláštním souboru).

V současnosti se však začínají prosazovat tzv. variabilní písma, která umožňují v jednom souboru definovat všechny dimenze řezů a většinu z nich jako téměř spojitý přechod z jedné koncové kresby do druhé (tj. např. od tenkého po tučné v několika stech dílčích kroků). Každá taková dimenze se označuje jako osa a font může mít větší počet os, které lze nezávisle kombinovat (třebaže ne všechny kombinace jsou použitelné).

Font _Source Pro 4_ použivaný při sazbě tohoto manuálu je variabilní v ose tučnosti:

#show-and-run(
```typ  
#for weight in range(
  100,
  1000,
  step: 50,
  inclusive: true,
) [#text(weight: weight)[Quercus ]]```)

Tato osa se nastavuje jako běžný argument `weight`, kde se namísto předdefinovaných řetězců použije číslo (běžně v rozsahu 200 až 900).

Některé fonty jako například _Roboto Flex_ však podporují os více.

=== Obvyklé osy

Existují čtyři standardní a široce používané osy.

==== tučnost

#show-and-run(
```typ 
#text(font: "Roboto Flex")[
#for weight in range(
  100,
  1000,
  step: 50,
  inclusive: true,
) [#text(weight: weight)[#weight:Quercus]]
]```)

==== šířka

#show-and-run(
```typ 
#text(font: "Roboto Flex")[
#for stretch in range(
  50,
  200,
  step: 10,
  inclusive: true,
) [#text(stretch: stretch * 1%)[#stretch: Quercus]]
]```, crop: true)

==== kurzíva

Další osou je kurzíva, která však není spojitá (existují jen hodnoty 0,1), protože kurzivní písmo má nejen modifikovanou kresbu, ale liší se i základní tvar některých znaků (např: "a" versus "_a_").

==== optická velikost
Čvrtou osou je tzv. optická velikost, 
tj. kresba písma měníci se s jeho velikostí. 
Ta se použije automticky při nastavení stupně (tj. velikosti) písma.


=== Méně obvyklé osy

Každý font si může přidat i vlastní osy. Některé z nich jsou ale sdíleny větším počtem fontů a jsou registrovány.

==== Gradace

Příkladem je gradace, tj. tučnost tahů, která ale nemění šířku znaků (tj. písmo jen zesvětlá či ztmavne bez vlivu na )

#show-and-run(
```typ 
#text(font: "Roboto Flex")[
#for grade in range(  
  -200,
  150,
  step: 50,
  inclusive: true,
) [#text(variations: (GRAD: grade))[#grade: Quercus]] 
]```, crop:true)

==== Tloušťka vodorovných tahů

Tloušťka vodorovných tahů může výrazněji změnit charakter písma.

#show-and-run(
```typ 
#text(font: "Roboto Flex")[
#for thin in range(
  25,
  100,
  step: 25,
  inclusive: true,
) [#text(variations: (YOPQ: thin))[#thin: Quercus]]
]```, crop: true)

Pokud si chcete vyzkoušet i další osy, můžete to učinit v prohlížeči písma v _Google Fonts_, pro font _Roboto Flex_ zde: https://fonts.google.com/specimen/Roboto+Flex) 

== Vyrovnání řádků do bloku

Vyrovnávání řádků do bloku není nic nového ani objevného; provádělo se již při ruční sazbě. To však neznamená, že jde o snadný úkol.

Jednoduchá implementace postupně přidává na řádek slova, dokud by přidáním dalšího slova nebyla překročena šířka tiskového zrcadla. Toto slovo se proto přesune na následující řádek a mezislovní mezery se roztáhnou tak, aby poslední slovo končilo přesně na hranici bloku.

Tento algoritmus sice vede k vyrovnání sazby, mohou při něm však vznikat příliš široké mezery. Ty se navíc mohou v sousedních řádcích spojovat do rozsáhlých bílých ploch, takzvaných řek. Takový postup se proto využívá především v jednodušších textových editorech.

Kvalitnější algoritmy používají globální přístup: optimalizují zalomení řádků v rámci celého odstavce a současně využívají dělení slov. Nejznámějším příkladem je Knuthův–Plassův algoritmus vytvořený pro TeX, který se v různých obměnách používá dodnes.

Moderní sázecí systémy nabízejí i další postupy, jejichž cílem je dosáhnout ještě vyrovnanějšího vzhledu sazby. Využívají drobné, téměř nepostřehnutelné úpravy, a proto se souhrnně označují jako *mikrotypografie*.

- *Změna šířky znaků* spočívá v jejich nepatrném vodorovném roztažení nebo zúžení, obvykle nejvýše o malé jednotky procent. *Typst* tuto techniku při automatickém vyrovnávání řádků prozatím nepoužívá.

- *Úprava mezipísmenných mezer*, označovaná také jako prostrkání, nepatrně zvětšuje nebo zmenšuje vzdálenosti mezi znaky. Také v tomto případě se změny pohybují pouze v řádu malých jednotek procent velikosti písma. _Typst_ tuto možnost podporuje, ve výchozím nastavení je však vypnuta.

- *Optické vyrovnání okrajů* kompenzuje rozdíl mezi geometrickým a vnímaným rozsahem znaků. Interpunkční znaménka a některé další znaky mohou mírně přesahovat sazební obrazec, aby okraj textu působil opticky rovně. *Typst* tuto techniku podporuje pouze omezeně, především na pravém okraji a jen u některých znaků; nejvýrazněji je patrná u spojovníku vloženého při dělení slova.

```typ
#set text(overhang: true) // výchozí hodnota

#set par(
  justify: true,
  justification-limits: (
    // Přísnější omezení mezislovních mezer
    // (výchozí hodnoty jsou přibližně 66,67–150 %).
    spacing: (min: 80%, max: 133%),

    // Úprava mezipísmenných mezer;
    // ve výchozím nastavení je vypnuta.
    tracking: (min: -0.01em, max: 0.02em),
  ),
)
```

== Slitky (ligatury)

Slitek (resp. ligatura) je spojení dvou či více písmen do jediného grafického objektu tzv. glyfu.

Slitky se (jak už český název napovídá) používali už v dobách, kdy se litery odlévaly z olova a to dokonce ve větší míře než dnes. V některých písmech (například indických) jsou povinné a často velmi komplexní.

V moderní sazbě se slitky používají nejčastěji jen tehdy, pokud se slitkem odstraní problematické napojení či překrývání sousedních znaků. Typickým případem je známe spojení znaků "f" a "i".

#show-and-run(
  ```typ
#grid(
  columns: 2,
  gutter: 10pt,
text(size:32pt)[fi],
text(size:32pt)[f\u{200c}i],
[slitek (jeden glyf)],
[dva glyfy]
)```)

Znak s Unicode pozicí `200C` je ZWNJ (_zero-width non-joiner_), jenž má nulovou šířku (tudíž je neviditelný), ale bezpečně ligaturu rozdělí.

Roztržení ligatur není vhodné jen na ukázku. Ve většině jazyků platí, že ligatura se nepoužívá v místě, kde se stýkají slova ve složeném tvaru. Důležité je to v němčině, například u slova Schiff#"\u{200c}"fahrt (ligatura nesmí spojit všechna "f", může být u prvních dvou, pak ale následuje slovo "fahrt")-.

Některé fonty jdou dále a podporují i méně běžné ligatury (ale stále moderní nikoliv historické). Ty je nutné zapnout pomocí vlastnosti `dlig` (_discretionary ligatures_). Pro příklad jsem zvolil font _EB Garamond_.

#show-and-run(
  ```typ
#grid(
  columns: 2,
  gutter: 10pt,
text(font: "EB Garamond", features: ("dlig",), size:32pt)[The],
text(font: "EB Garamond", features: ("dlig",), size:32pt)[T\u{200c}he],
[slitek (jeden glyf)],
[dva glyfy]
)```)

Všimněte si, že použití slitku vedlo k výrazně lepšímu vyrovnání meziznakových mezer a to ve spojení, které je v angličtině velmi časté.

Jedním z módních použití ligatur je nahrazování některých víceznakových tokenů programovacích jazyků přehlednějšími symboly převzatými z matematické notace. To sice může zpřehlednit zápis zkušenému programátorovi, pro začátečníka však může být matoucí, viz „Kde najdu na klávesnici znak `≥`?“

Pokud font tyto ligatury podporuje, bývají implicitně povoleny. Lze je však zakázat nastavením rysu `calt` (_context alternatives_) na hodnotu `0`.

#show-and-run(
````typ
#show raw: set text(font: "JetBrains Mono") //podporuje `calt`

```python
def f(y) -> int:
    if (x := get()) >= y:
        return x
```

#show raw: set text(features: (calt: 0))
```python
def f(y) -> int:
    if (x := get()) >= y:
        return x
```
````)

= Typst jako programovací jazyk

Navzdory některým netradičním konstrukcím, které souvisejí s přímou podporou textového obsahu, je *Typst* v zásadě běžný imperativní programovací jazyk s výraznými prvky funkcionálního programování a mainstreamovou syntaxí céčkovského typu.


== Typový systém 

 Typový systém je dynamický a typová kontrola relativně přísná. Rozlišení mezi překladem a během programu je však do značné míry setřeno, protože skript se vyhodnocuje při překladu dokumentu.

Mezi základními typy najdeme běžné číselné typy. Typ `int` představuje 64bitové celé číslo se znaménkem a `float` 64bitové číslo s pohyblivou řádovou čárkou, tedy číslo s dvojitou přesností. Typ `decimal` slouží k přesným výpočtům v desítkové soustavě a poskytuje 28 až 29 platných dekadických číslic. Podporuje běžné aritmetické operace, nikoli však všechny matematické funkce určené pro typ `float`; například před použitím goniometrických funkcí je nutné hodnotu převést na `float`.

Méně obvyklé jsou zvláštní číselné typy pro poměry, úhly, vzdálenosti nebo pružné rozměry. Typst dovoluje kombinovat tyto hodnoty s čísly pouze tehdy, má-li daná operace smysl. Vzdálenost nebo úhel lze například násobit a dělit číslem, zatímco sečtení vzdálenosti s úhlem je typovou chybou.

Instance složených typů lze vytvářet:
 - prostřednictvím "závorkových" literálů (seznamy, slovníky, textový obsah)
 - voláním funkcí (konstruktorů)
 - definováním funkce (funkce jsou v _typstu_ hodnoty)

V případě komplexních typů lze k dílčím hodnotám (polím) přistupovat pomocí tečkové (atributové) notace.

#show-and-run(
```typ
#[== Test].body, #[== Test].depth
```)

Tečkovou notaci lze využít i k přístupu k položkám slovníku (za tečkou je klíč), modulu (za tečkou je identifikátoru).

Tečková notace může být samozřejmě vnořená, což se využívá v modulech `symbol` a `emoji` pro vytváření složených identifikátorů pro Unicode symboly.

#show-and-run(
```typ 
#sym.arrow.l  // arrow left
#emoji.apple.green
#emoji.handholding.man.man 
// ale kupodivu chybí 
// emoji.handholding.small_furry_creature_from_Alpha_Centauri
//  .small_furry_creature_from_Alpha_Centauri
```)

Tečkovou notaci lze aplikovat i na identifikátory typů (tj. konstruktorů). To se využívá pro funkce svázané s typem (typ je de facto jmenný prostor) a pro obdobu volání metod (parametrem je instance typu). V druhém případě existuje stručnější zápis emulující běžnou OOP syntaxi volání metod:

#show-and-run(
```typ  
bytes:
#str.len("🇨🇿") = // délka řetězce v bytech (UTF8)
#"🇨🇿".len() // ekvivalentní zápis (pozlátko) 

glyphs:
#array.len(str.clusters("🇨🇿")) = // délka řetězce v glyfech
#"🇨🇿".clusters().len()
```
)

== Řídicí konstrukce
Řídicí konstrukce, které mění tok řízení, mají v _typstu_ relativně běžný zápis. Na rozdíl od většiny procedurálních jazyků to však jsou výrazy (tj. vracejí hodnoty). Zatímco u větvení to není tak překvapivé (_typst_ nerozeznává příkaz `if` od podmíněného operátoru), může být použití cyklů jako hodnot překvapivé)


#show-and-run(
  ```typ
#for (i, glyph) in array.enumerate("Frodo".clusters()) {
  if calc.odd(i) {strong(glyph)}
  else {glyph}
}

#let seq = for i in range(0, 10){
  text(str(i), fill: red.rotate(i*30deg))
}  
//cyklus na pravé straně přiřazení
#seq
```)

Výslednou hodnotou cyklu jsou spojené (_join_) hodnoty, které jsou generovány v těle cyklu (typicky text nebo řetězec).
 
Cyklus `for` iteruje přes:
/ řetězec: prochází logické znaky (glyfy)
/ pole: prochází položky pole (podle indexů)
/ slovník: dvojprvková pole (klíč, hodnota) v pořadí vložení

Všimněte si, že chybí iterátory. Typst nepodporuje (lenivé iterátory). Funkce `range` vrací 

Uvnitř cyklů lze používat příkazy skoku `break` a `continue`.

== Přiřazení

Přiřazení hraje v Typstu klíčovou roli. Základní roli hraje v tzv. vázání (binding), které vytváří (definuje) proměnou. Tu zahajuje příkaz `let`, jenž vytváří nový identifikátor a svazuje s přiřazovanou hodnotou. Pokud přiřazení chybí, bude svázána s hodonotou `none`. 

Proměnná je viditelná až do konce bloku (kódového či textového), v němž je definována.

Nově vytvořená proměná může být v svém oboru viditelnosti svázána s novou hodnotou dalším přiřazením (`let` se už v programovacím režimu neuvádí, v mark-up naopak ano).

#show-and-run(
  ```typ
#let x = 2 // vázání (definice)
#let x = 3 // přiřazení do existující proměnné
#x // vložení hodnoty odkazované proměnné
```)

Konstrukce `let` s přiřazením se používá i pro definici uživatelských funkcí (rozdíl je pouze v uvedení seznamu parametrů na levé straně přiřazení)

#show-and-run(
```typ
#[
#let sqr(x) = x * x

#sqr(decimal("1000000000000"))
]```, crop: true)

Identifikátory mohou obsahovat Unicode alfanumerické znaky, podtržítka a pomlčky (to není zcela běžné). Idenifikátor nesmí začínat číslicí ani pomlčkou.

Typst také podporuje agregovaná přiřazení známá (mimo jiné) z Pythonu, používaná pro dekonstrukce polí a slovníků. Základním rozdílem oproti Pythonu je nutnost použití (kulatých) závorek (tj. syntakticky polí).

#show-and-run(
```typ
#let (head, .., tail) = (1,  3) //..  

head = #head, tail = #tail
```)

V Typstu se využívá *lexikální vazba* tj. vazba platná v kontextu definice funkce (nikoliv v kontextu jejího volání). Zřejmá je v případě proměnných, které nejsou definovány v dané funkci resp. nejsou jejími parametry (tzv. volné proměnné).

Volné proměnné navíc nelze modifikovat (tj. změnit jejich vazbu). Ve funkci tak nelze například modifikovat globální proměnné (definovanou mimo funkce). To je běžný požadavek ve funkcionálních jazycích a v Typstu je nezbytný i proto, že pořadí vyhodnocování nemusí být (a běžně nebývá) shodné s pořadím prvků v toku textu. 

Typickým příkladem je číslování kapitol. Naivní implementace by mohla při každém nadpisu zvýšit globální čítač a jeho aktuální hodnotu použít jako číslo kapitoly. Takový postup však předpokládá, že se jednotlivé nadpisy vyhodnocují ve stejném pořadí, v jakém se nakonec objeví v dokumentu. To obecně neplatí: při sazbě, introspekci a opakovaném vyhodnocování částí dokumentu může být pořadí vyhodnocování jiné. 

Předokládejme například tento (neplatný) dokument v Typstu.

```typ
#let chapter-number = 0

#let chapter(title) = {
  chapter-number += 1
  heading[Chapter #chapter-number: #title]
}

#let preface(preface, body) = {
  chapter[Preface]
  preface
  body
}

#preface([Text of preface], [
  #chapter[First chapter]
])
```

Intuitivně bychom očekávali, že výsledkem by bylo:

```
Chapter 1: Preface
Text of preface
Chapter 2: First chapter
```

Protože se ale parametr `body` vyhodnotí dříve než tělo funkce `preface` (jak je tomu v běžně používaných jazycích#footnote[přesněji v jazycích se striktním vyhodnocováním. Jazyky s tzv. líným vyhodnocováním mohou vyhodnocení argumentu odložit až do okamžiku jeho použití, tento přístup je však podstatně méně obvyklý a přináší vlastní komplikace při řízení výkonu a vedlejších efektů.]), získal by číslo 1. Kapitola `Preface` je vložena v těle a tak se vyhodnotí až poté, a proto získá číslo 2. Výsledek by tudíž byl evidentně chybný:

```
Chapter 2: Preface
Text of preface
Chapter : First chapter
```

Tento kód se ale naštěstí vůbec nepřeloží, neboť kód na začátku funkce `chapter`
```
chapter-number += 1
```

modifikuje volnou proměnnou (tj.proměnou definovanou ve vnějším kontextu), čemuž odpovídá i chybová hláška: “Variables from outside the function are read-only and cannot be modified.”.

*Poznámka*: Alternativou k modifikaci samotné proměnné je změna hodnoty modifikovatelného objektu, například položky pole nebo slovníku, případně použití mutující metody, jako je `array.push`. Takové řešení však vede ke stejnému problému: změna se uskuteční v pořadí vyhodnocování programu, nikoliv nutně v pořadí, v němž se výsledný obsah objeví v dokumentu. Na rozdíl od přímé modifikace volné proměnné přitom nemusí být takový kód odmítnut překladačem.

Jak tedy univerzálně řešit postupné číslování či obecně požadavek existence modifikovatelných globálních stavů?

Jediným řešením je použití specializovaného objektu vytvářeného funkcí `state`, který se označuje jako _manažer stavu_ (či jen _stav_ pokud je význam jasný z kontextu).

Tento objekt má dvě základní metody: 
/ get: vrací aktuální stav objektu (musí být uvedena v kontextovém bloku, neboť závisí na okolním kontextu)
/ update: modifikuje stav objektu. Může to nová hodnota, nebo funkce, která převádí starou hodnotu na novou (obecně nemusí být v kontextovém bloku). 

Chování modelu si lze předstat následovně. Na místě, v němž je volána metoda `update`, se vloží záznam, že v tomto místě má být modifikována hodnota stavu a to buď přímým nastavením nebo voláním updatovací metody. 
Nastavení resp. volání updatovací metody se však v tomto okamžiku ještě neděje.

Při vyhodnocení metody `get`, ke kterému může dojít až tehdy, když je znám kontext jejího volání, se hodnota určí z počáteční hodnoty stavu a všech předcházejících záznamů operací `update` v pořadí jejich umístění v dokumentu. Výsledná hodnota je poté metodou get vrácena.

Skutečná implementace přirozeně využívá různé optimalizační techniky, například kešování již vypočtených hodnot, což však nemění základní sémantiku tohoto mechanismu. 

TODO: příklad

Poznámka: Celý mechanismus manažera stavů může i přes optimalizace výrazně zpomalovat generování dokumentu, zejména pokud jeho použití vyvolává další průchody při sazbě. Pro běžné použití (např. globální číslování) a běžné velikosti dokumentů to nepředstavuje problém. Typst však v žádném případě není nástroj určený ke zpracování big data ani matematický řešič s lenivým vyhodnocováním.

Použití manažera stavů je navíc zbytečné, pokud není potřeba změnu stavu propagovat mimo funkci, případně ji svázat s pořadím prvků ve výsledném dokumentu. Uvnitř jedné funkce lze běžně používat lokální proměnné i modifikovatelné objekty. Příkladem může být například číslování řádků tabulky nebo vytváření glosáře, který je pouze množinou termínů a jejich definic a nezávisí na pořadí jejich výskytu v dokumentu (a dokonce ani kontextu).