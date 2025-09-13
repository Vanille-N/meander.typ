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
