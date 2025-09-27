#import "/src/lib.typ" as meander

#let img(width, height, fill) = {
  box(
    width: width,
    height: height,
    radius: 2mm,
    fill: fill.transparentize(70%)
  )
}

#meander.reflow({
  import meander: *

  placed(top + left, img(5cm, 7cm, red))
  container()

  pagebreak()

  placed(top + right, img(5cm, 7cm, blue))
  container()

  content[#lorem(900)]
})

#pagebreak()

#meander.reflow(overflow: pagebreak, {
  import meander: *
  placed(top + left, {})
  container()
  content[#lorem(1000)]
})
// Regular text can continue afterwards
#lorem(5)

#pagebreak()

#meander.reflow(debug: true, {
  import meander: *
  container()
  content[#lorem(1000)]
})

#pagebreak()

#meander.reflow(
  debug: true,
  overflow: tt => [
    #colbreak()
    *The following content overflows:* #text(fill: red)[_#{tt.styled}_]
  ], {
  import meander: *
  container()
  content[#lorem(1000)]
})

#pagebreak()

#meander.reflow(debug: true, overflow: panic, placement: box, {
  import meander: *
  container()
  pagebreak()
  container()
  content[#lorem(1000)]
})
#lorem(50)

#pagebreak()

#let overflow = state("overflow")
#meander.reflow(debug: true, overflow: overflow, placement: box, {
  import meander: *
  container(width: 50% - 3mm, margin: 6mm)
  container()
  content[#lorem(1000)]
})
#set page(columns: 2)
#context overflow.get().styled

