#import "/src/lib.typ" as meander

#let fakeimg(align, dx: 0pt, dy: 0pt, fill: white, width: 1cm, height: 1cm) = {
  placed(align, dx: dx, dy: dy,
    box(fill: fill.transparentize(70%), width: width, height: height, radius: 5mm)
  )
}

#meander.reflow(overflow: true,  debug: true, {
  import meander: *
  placed(
    top + left,
    boundary: contour.horiz(div: 25, y => (0,0)),
    box(width: 1cm, height: 100%),
  )
  container()
  content(hyphenate: false)[#set par(justify: true); #lorem(100)]
  content(hyphenate: true, lang: "la")[#set par(justify: true); #lorem(100)]
  content(hyphenate: true, lang: "en")[#set par(justify: true); #lorem(100)]
  content(size: 20pt)[#lorem(100)]
})

#pagebreak()

#meander.reflow({
  import meander: *
  container(align: left, width: 25%, style: (align: left))
  container(align: center, width: 45%, style: (align: center))
  container(align: right, width: 25%, style: (align: right))
  content(lang: "la")[#lorem(590)]
})

#pagebreak()

#meander.reflow(overflow: true, {
  import meander: *
  container(width: 48%, style: (align: center, text-fill: blue))
  container(align: right, width: 48%, style: (align: right, text-fill: red))
  content[#lorem(600)]
})

#pagebreak()

#meander.reflow(overflow: true,  debug: true, {
  import meander: *
  placed(
    top + left,
    boundary: contour.horiz(div: 25, y => (0,0)),
    box(width: 1cm, height: 100%),
  )
  container()
  content(leading: 1em, size: 8pt)[#lorem(100)]
  content(leading: 0.5em, size: 14pt)[#lorem(100)]
  content(leading: 0.5em + 10pt, size: 12pt)[#lorem(100)]
})

