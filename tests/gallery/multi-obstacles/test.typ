#let my-img-1 = box(width: 7cm, height: 7cm, fill: orange)
#let my-img-2 = box(width: 5cm, height: 3cm, fill: blue)
#let my-img-3 = box(width: 8cm, height: 4cm, fill: green)
#let my-img-4 = box(width: 5cm, height: 5cm, fill: red)
#let my-img-5 = box(width: 4cm, height: 3cm, fill: yellow)

#import "/src/lib.typ" as meander

#meander.reflow({
  import meander: *

  // As many obstacles as you want
  placed(top + left, my-img-1)
  placed(top + right, my-img-2)
  placed(horizon + right, my-img-3)
  placed(bottom + left, my-img-4)
  placed(bottom + left, dx: 32%, my-img-5)

  // The container wraps around all
  container()
  content[
    #set par(justify: true)
    #lorem(430)
  ]
})
