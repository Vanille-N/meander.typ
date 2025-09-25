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

#meander.reflow(debug: true, {
  import meander: *
  placed(
    top + left,
    boundary: contour.ascii-art(
      ```
      #
      ##
      ```
    ),
    img(50pt, 50pt, blue, 1),
    tags: <A>,
  )
  container(tags: <B>)
  content[#lorem(50)] 
})
