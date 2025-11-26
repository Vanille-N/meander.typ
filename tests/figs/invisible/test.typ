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
#set par(justify: true)
//@ <doc>
#meander.reflow({
  import meander: *
  placed(
    top + center,
    my-img-1,
    tags: <x>,
  )
  container(width: 50% - 3mm)
  container(
    align: right,
    width: 50% - 3mm,
    invisible: <x>,
  )
  content[#lorem(600)]
})
