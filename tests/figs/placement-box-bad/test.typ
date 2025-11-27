#import "/src/lib.typ" as meander
#let label(i) = text(size: 30pt)[#raw(str(i))]
#let img(width, height, fill, num) = {
  box(
    width: width,
    height: height,
    radius: 2mm,
    fill: fill.darken(-70%)
  )[
    #align(center + horizon)[#label(num)]
  ]
}

#let my-img-1 = img(7cm, 7cm, orange, 1)
//@ <doc>
#lorem(100)

#meander.reflow({
  import meander: *
  opt.placement.phantom()

  placed(top + left, dy: 1cm,
          my-img-1)
  container()
  content[
    #set text(fill: red)
    #lorem(100)

    #lorem(100)
  ]
})

#lorem(100)
