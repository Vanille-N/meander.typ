#let grid-paper(filter: _ => true, content) = {
  let grid-color = rgb("#CCCCCC")
  let grid-spacing = 5mm
  
  set page(
    paper: "a4",
    margin: (x: 2cm, y: 2cm),
    background: {
      context if filter(here().page()) {  // n'affiche la grille que sur les pages paires
        // Lignes verticales
        for x in range(int(page.width / grid-spacing)) {
          place(
            line(
              start: (x * grid-spacing, 0pt),
              end: (x * grid-spacing, page.height),
              stroke: (paint: grid-color, thickness: 0.2pt)
            )
          )
        }
        // Lignes horizontales
        for y in range(int(page.height / grid-spacing)) {
          place(
            line(
              start: (0pt, y * grid-spacing),
              end: (page.width, y * grid-spacing),
              stroke: (paint: grid-color, thickness: 0.2pt)
            )
          )
        }
      }
    }
  )
  content
}

#let print-every-other-page(ct) = {
  import "@preview/meander:0.2.3"
  let print-one-skip-one(ct) = {
    meander.reflow(
      // If the content overflows, recursively call the same
      // function again.
      // Beware of the recursion limit though... 
      overflow: print-one-skip-one,
      {
        import meander: *
        container()
        pagebreak()
        pagebreak() // skip a whole page
        ct.structured
      }
    )
  }
  print-one-skip-one((structured: meander.content(ct)))
}

#show: grid-paper.with(filter: pg => pg >= 2 and calc.odd(pg))

= Page de garde

#pagebreak()

#set page(numbering: "1")
#show: print-every-other-page

= Section

#lorem(20000)
