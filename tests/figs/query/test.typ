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
#set par(justify: true)
//@ <doc>
#meander.reflow({
  import meander: *
  placed(
    left + horizon,
    my-img-3,
    tags: <a>,
  )
  container(
    align: query.position(
      <a>, at: center),
    width: query.width(
      <a>, transform: 150%),
    height: query.height(
      <a>, transform: 150%),
    tags: <b>,
  )
  placed(
    query.position(
      <b>, at: bottom + left),
    anchor: top + left,
    dx: 5mm,
    my-img-2,
  )
  content[#lorem(100)]
})
