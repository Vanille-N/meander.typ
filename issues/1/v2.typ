#import "/src/lib.typ" as meander

#let cutout-offset = 5cm
#let cutout-width = 10cm

#let norm(x,y) = calc.pow(2 * x - 1, 2) + calc.pow(2 * y - 1, 2)

#meander.reflow({
  import meander: *
  placed(
    center, dy: cutout-offset,
    boundary: contour.grid(div: 20, (x,y) => norm(x,y) <= 1),
    box(width: cutout-width, height: cutout-width),
    tags: (<interior>,),
  )
  placed(
    center, dy: cutout-offset,
    boundary: contour.grid(div: 20, (x,y) => norm(x,y) >= 0.7),
    box(width: cutout-width, height: cutout-width),
    tags: (<exterior>,),
  )
  container(
    width: 50% - 3mm,
    margin: 6mm,
    ignore-labels: (<exterior>,),
  )
  container(
    align: center, dy: cutout-offset,
    width: cutout-width, height: cutout-width,
    ignore-labels: (<interior>,),
  )
  container(
    ignore-labels: (<exterior>,),
  )
  content[
    #set par(justify: true)
    #lorem(570)
  ]
})
