#import "/src/lib.typ" as meander
#import "@preview/hy-dro-gen:0.1.2" as hy

#set page(width: 4.5cm, height: 6cm, margin: 1mm)
#set par(justify: true)
#set text(size: 11pt, lang: "fr")

// physique{non-breaking space}:
#hy.syllables("physique :", lang: "fr")

#v(1em)

#let paragraph = [un deux trois quatr e physique~:]
//#let paragraph = [un deux trois quatr e physique :]

#meander.reflow({
  import meander: *
  opt.debug.post-thread()
  placed(
    top + left,
    boundary: contour.ascii-art(```
    #
    #
    #
    ```) + contour.margin(5mm),
    rect(
      width: 3em,
      height: 3em,
    )
  )
  container()
  content(paragraph)
})

#pad(
  left: 3em + 5mm,
  paragraph
)
