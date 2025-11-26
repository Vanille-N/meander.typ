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
//@ <doc>
#meander.reflow({
  import meander: *
  placed(bottom + right, my-img-1)
  placed(center + horizon, my-img-2)
  placed(top + right, my-img-3)

  // With two containers we can
  // emulate two columns.

  // The first container takes 60%
  // of the page width.
  container(width: 60%, margin: 5mm)
  // The second container automatically
  // fills the remaining space.
  container()

  content[#lorem(470)]
})
