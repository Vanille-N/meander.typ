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
  opt.debug.pre-thread()
  placed(
    top + left,
    boundary:
      contour.margin(1cm),
    my-img-1,
  )
  placed(
    center + horizon,
    boundary:
      contour.margin(
        5mm,
        x: 1cm,
      ),
    my-img-2,
  )
  placed(
    bottom + right,
    boundary:
      contour.margin(
        top: 2cm,
        left: 2cm,
      ),
    my-img-3,
  )
})
