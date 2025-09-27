#import "/src/lib.typ" as meander

#let label(i) = text(size: 30pt)[#raw(str(i))]
#let img(width, height, fill, num) = {
  box(
    width: width,
    height: height,
    radius: 2mm,
    fill: fill.transparentize(70%)
  )[
    #align(center + horizon)[#label(num)]
  ]
}

#meander.reflow(debug: true, {
  import meander: *
  placed(top + left, img(5cm, 5cm, blue, 1), tags: <A>)
  container(invisible: <A>)
  container()

  content[#lorem(50)]
  colbreak()
  content[#lorem(50)]
})

#pagebreak()

/*
#meander.reflow(debug: true, {
  import meander: *
  container(tags: <A>)
  content(lorem(100))
  colbreak()

  placed((rel: <A>, at: bottom + left), anchor: top + left, dy: 1cm, box(width: 5cm, height: 5cm, fill: red))
  container()
  content(lorem(500))
})
