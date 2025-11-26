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
#let my-img-2 = img(5cm, 3cm, blue, 2)
#let my-img-3 = img(8cm, 4cm, green, 3)
#let my-img-4 = img(5cm, 5cm, red, 4)
//@ <doc>
#meander.reflow({
  import meander: *

  placed(top + left, my-img-1)
  placed(bottom + right, my-img-2)
  container()

  pagebreak()

  placed(top + right, my-img-3)
  placed(bottom + left, my-img-4)
  container(width: 45%)
  container(align: right, width: 45%)

  content[#lorem(1000)]
})
