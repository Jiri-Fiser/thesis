
#import "@preview/based:0.2.0": base64

#let nonempty(value) = value != none and value != []

#let ThesisType = (
  Bachelor: "bc",
  Diploma: "ing",
)

#let addchap(body) = heading(
  level: 1,
  numbering: none,
  body,
)


#let ThesisLanguage = (
  "Cs" : "cs",
  "En" : "en",
)

#let Gender = (
  "Feminum" : 0,
  "Masculinum" : 1
)

#let month-name(month, lang)= {
  let months = (
    ThesisLanguage.Cs: (
      "ledna", "února", "března", "dubna", "května", "června",
       "července", "srpna", "září", "října", "listopadu", "prosince"),
    ThesisLanguage.En: (
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"),
    )

  if month < 1 or month > 12 {
    panic("Month number has to be in range 1 .. 12.")
  }

   return months.at(lang).at(month - 1)
  }
}g

#let format_date(date, lang) = {
  if (lang == ThesisLanguage.Cs) {
    return str(date.day()) + ". " +  month-name(date.month(), lang)+ " " + str(date.year())
  }
}

#let thesis-title(type, lang) = {
    let titles = (
      ThesisType.Bachelor:
      (ThesisLanguage.Cs: "bakalářská práce", ThesisLanguage.En: "bachelor thesis"),
      ThesisType.Diploma:
      (ThesisLanguage.Cs: "diplomová práce", ThesisLanguage.En: "diploma thesis"),
   )

   return titles.at(type).at(lang)
}

#let thesis-title-accusative(type, lang) = {
   let titles = (
      ThesisType.Bachelor:
      (ThesisLanguage.Cs: "bakalářskou práci", ThesisLanguage.En: "bachelor thesis"),
      ThesisType.Diploma:
      (ThesisLanguage.Cs: "diplomovou práci", ThesisLanguage.En: "diploma thesis"),
   )

      return titles.at(type).at(lang)
}

#let gender-ending(gender) = {
  if (gender == Gender.Feminum) [a] else []
}

// Jedna strana vloženého zadání.
#let assignment-page(path, number) = {
  page(
    margin: 0pt,
    header: none,
    footer: none,
    numbering: none,
  )[
    #image(
      path,
      page: number,
      width: 100%,
      height: 100%,
      fit: "contain",
      alt: "Zadání kvalifikační práce",
    )
  ]
}

// Kontrolní stránka použitá, pokud zadání není vloženo.
#let assignment-placeholder(number) = {
  page(
    fill: yellow.lighten(65%),
    header: none,
    footer: none,
    numbering: none,
  )[
    #align(center + horizon)[
      #block(width: 75%)[
        #set text(size: 18pt)

        *Strana #number zadání kvalifikační práce*

        #v(1cm)

        Namísto této žluté stránky vložte digitálně podepsané
        zadání kvalifikační práce poskytnuté vedoucím katedry.

        #v(0.5cm)

        Zadání musí zaujímat právě dvě strany.
      ]
    ]
  ]
}

#let title-page(
  university,
  faculty,
  title-cs,
  title-en,
  author,
  supervisor,
  programme,
  logo,
  type,
  language,
  finish-date,
  gender
) = {
  page(
    header: none,
    footer: none,
    numbering: none,
  )[
    #align(center)[
      #set par(justify: false)

      #text(size: 24pt)[
        #university
        #linebreak()
        #v(16pt)
      ]

      #text(size: 22pt)[
        #v(16pt)
        #faculty
      ]

      #v(2cm)

      #if nonempty(logo) {
       image(
        logo,
        width: 8.42cm,
        alt: "Logo fakulty",
      )
      }

      #v(2cm)

      #text(
        size: 24pt,
        weight: "bold",
      )[
        #title-cs
      ]

      #v(0.6cm)

      #text(
        size: 18pt,
        font: "Libertinus Serif",
      )[
        #upper(thesis-title(type, language))
      ]
    ]

    #v(1fr)

    #set text(size: 14pt)

    #grid(
      columns: (auto, 1fr),
      column-gutter: 0.6em,
       inset: (y: 0.5em)
       ,
      row-gutter: 0.35em,

      [*Vypracoval#gender-ending(gender):*],
      author,

      [*Vedoucí práce:*],
      supervisor,

      [*Studijní program:*],
      programme,
    )

    #v(1.5cm)

    #align(center)[
      #text(size: 16pt)[
        #smallcaps[Ústí nad Labem\ #numbering("I", finish-date.year())]
      ]
    ]
  ]
}

#let declaration-page(
  language,
  gender,
  finish-date,
  type
) = {
  page(
    header: none,
    footer: none,
    numbering: none,
  )[
    *Prohlášení*

    #v(0.5cm)

    Prohlašuji, že jsem tuto
    #thesis-title-accusative(type,ThesisLanguage.Cs)
    vypracoval#gender-ending(gender)
    samostatně a použil#gender-ending(gender)
    jen pramenů, které cituji a uvádím v přiloženém seznamu
    literatury.

    #v(0.5em)

    Byl#gender-ending(gender)
    jsem seznámen#gender-ending(gender)
    s tím, že se na moji práci vztahují práva a povinnosti
    vyplývající ze zákona č. 121/2000 Sb., ve znění zákona
    č. 81/2005 Sb., autorský zákon, zejména se skutečností,
    že Univerzita Jana Evangelisty Purkyně v Ústí nad Labem
    má právo na uzavření licenční smlouvy o užití této práce
    jako školního díla podle § 60 odst. 1 autorského zákona,
    a s tím, že pokud dojde k užití této práce mnou nebo bude
    poskytnuta licence o užití jinému subjektu, je Univerzita
    Jana Evangelisty Purkyně v Ústí nad Labem oprávněna ode
    mne požadovat přiměřený příspěvek na úhradu nákladů, které
    na vytvoření díla vynaložily, a to podle okolností až do
    jejich skutečné výše.

    #v(2em)

    #grid(
      columns: (1fr, auto),
      gutter: 1cm,

      [V Ústí nad Labem dne #format_date(finish-date, language)],
      [
        Podpis:
        #box(
          width: 4cm,
          inset: (bottom: 2pt),
          stroke: (bottom: 0.5pt),
        )
      ],
    )
  ]
}

#let dedication-page(dedication) = {
  page(
    header: none,
    footer: none,
    numbering: none,
  )[
    #v(1fr)

    #align(right)[
      #block(width: 65%)[
        #dedication
      ]
    ]
  ]
}

#let abstracts-page(
  title-cs,
  title-en,
  abstract-cs,
  abstract-en,
  keywords-cs,
  keywords-en,
) = {
  page(
    header: none,
    footer: none,
    numbering: none,
  )[
    #set par(spacing: 0.75em)

    #smallcaps(title-cs)

    #v(0.8em)

    *Abstrakt:*

    #abstract-cs

    *Klíčová slova:* #keywords-cs

    #v(1.5em)

    #smallcaps(title-en)

    #v(0.8em)

    *Abstract:*

    #abstract-en

    *Keywords:* #keywords-en
  ]
}

#let placeholder(body) = {
  highlight(
    fill: yellow,
    text(fill: red, body),
  )
}

#let thesis(
  doc,
  title-cs: none,
  title-en: none,
  author: none,
  supervisor: none,
  programme: none,
  // Původní LaTeXová makra:
  university : [Univerzita Jana Evangelisty Purkyně \ v Ústí nad Labem],
  faculty: "Přírodovědecká fakulta",
  finish-date: datetime.today(),

  // Přepínače:
  type: ThesisType.Bachelor,
  gender: none,
  language: ThesisLanguage.Cs,

  // Soubory:
  logo-cs: "LOGO_PRF_CZ_RGB_standard.jpg",
  logo-en: "LOGO_PRF_EN_RGB_standard.jpg",

  // Úvodní části:
  dedication: none,
  abstract-cs: none,
  abstract-en: none,
  keywords-cs: none,
  keywords-en: none,

  // Hlavní obsah dokumentu:
) = {
  // Metadata PDF.
  set document(
    title: title-cs,
    author: author,
  )

  set page(
    paper: "a4",
    binding: left,
    margin: (
      inside: 2.5cm,
      outside: 2cm,
      top: 2cm,
      bottom: 2cm,
    ),
  )

  set text(
    lang: language,
    size: 12pt,
  )

  set par(
    justify: true,
    leading: 0.65em,
  )

  set heading(numbering: "1.1")

  show heading: set text(
    font: "Roboto"
  )

  show heading.where(level: 1): it => {
    pagebreak(weak: true)
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

  let logo = if language == "cs" {
    logo-cs
  } else {
    logo-en
  }

  // Titulní strana.
  title-page(
    university,
    faculty,
    title-cs,
    title-en,
    author,
    supervisor,
    programme,
    logo,
    type,
    language,
    finish-date,
    gender
  )

  // Explicitní zlom na lichou stranu.
  pagebreak(to: "odd")

  // Dvě strany zadání.
  assignment-placeholder(1)
  assignment-placeholder(2)
  

  // Prohlášení.
  pagebreak(to: "odd")

  declaration-page(
    language,
    gender,
    finish-date,
    type
  )

  // Poděkování je nepovinné.
  if nonempty(dedication) {
    pagebreak(to: "odd")
    dedication-page(dedication)
  }

  // Abstrakty.
  if (
    nonempty(abstract-cs)
    or nonempty(abstract-en)
    or nonempty(keywords-cs)
    or nonempty(keywords-en)
  ) {
    pagebreak(to: "odd")

    abstracts-page(
      title-cs,
      title-en,
      abstract-cs,
      abstract-en,
      keywords-cs,
      keywords-en,
    )
  }

  // Obsah.
  pagebreak(to: "odd")

  outline(
    title: [Obsah],
    depth: 3,
  )

  // Hlavní text.type,
  pagebreak(to: "odd")
  //counter(page).update(1)

  set page(
    numbering: "1",
    number-align: bottom + center,
    header: context {
    let current-page = here().page()
    let chapters = query(heading.where(level: 1))

    // Začíná na této stránce kapitola?
    let is-chapter-page = chapters.any(
      chapter => chapter.location().page() == current-page
    )

    if not is-chapter-page {
      // Poslední kapitola začínající před aktuální stránkou.
      let previous-chapters = chapters.filter(
        chapter => chapter.location().page() < current-page
      )

      let chapter-title = if previous-chapters.len() > 0 {
        previous-chapters.last().body
      } else {
        []
      }

      set text(size: 11pt)

      grid(
        columns: (1fr, 1fr),
        column-gutter: 1em,

        align(left)[#title-cs],
        align(right)[#chapter-title],
      )
    }
  },

  )

  doc
}