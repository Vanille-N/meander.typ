#import "/src/lib.typ" as meander

#set page(width: 4in, height: auto, margin: 0.25in)
#set text(lang: "fr", hyphenate: false)

#let sample = [Aller s'épanouir dans n'importe quel monde.]

*Plain Typst*
#block(width: 32pt, stroke: 0.3pt + gray, sample)

*meander:*
#meander.reflow({
  import meander: *
  placed(top + right, boundary: contour.margin(0pt), box(
    width: 200pt,
    height: 14pt,
    fill: blue,
  ))
  container(height: 40pt)
  content(sample)
})


*meander:*
#meander.reflow({
  import meander: *
  placed(top + right, boundary: contour.margin(0pt), box(
    width: 220pt,
    height: 14pt,
    fill: blue,
  ))
  container(height: 40pt)
  content(sample)
})
