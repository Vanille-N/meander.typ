#let my-img-1 = box(width: 7cm, height: 7cm, fill: orange)
#let my-img-2 = box(width: 5cm, height: 3cm, fill: blue)
#let my-img-3 = box(width: 8cm, height: 4cm, fill: green)

#import "/src/lib.typ" as meander

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
