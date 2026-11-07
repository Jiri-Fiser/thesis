#import "thesis.typ": thesis, Gender, ThesisType, addchap

#show: thesis.with(
  gender: Gender.Masculinum,
  type: ThesisType.Bachelor,

  title-cs: [
    Jak napsat závěrečnou práci na katedře informatiky Přírodovědecké fakulty UJEP
  ],
  title-en: [
    How to Write a Thesis at the Department of Informatics, Faculty of Science, UJEP
  ],

  author: "Mgr. Jiří Fišer, Ph.D.",
  supervisor: "Mgr. Jiří Fišer, Ph.D.",
  programme: [Aplikovaná informatika] ,

  dedication: [
    Děkuji vedoucímu práce Jiřímu Fišerovi
    za neocenitelné rady a pomoc při tvorbě bakalářské práce.
  ],

  abstract-cs: [],
  keywords-cs: [
    závěrečná práce, typografie, odborný text
  ],

  abstract-en: [],
  keywords-en: [Thesis, Typography, Academic Writing],
)

#addchap[Úvod]

Úvod má obsahovat tyto části:

+ motivace
+ stručný úvod do současného stavu problematiky závěrečné práce
+ cíle práce (podle zadání ale s vlastní formulací)
+ stručný popis struktury práce

#include "teorie.typ"

= Základní formátování

= Komplexní typografie

== Tabulky

== Grafika

= Zdroje a citace

= Závěr

#bibliography(
  "thesis.bib", 
  style: "iso690-numeric-brackets-cs-ujep.csl",
  title: "Seznam zdrojů"

)



