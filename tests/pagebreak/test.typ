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
