#import "_preamble.typ": *

#let fakeimg(alignment, dx: 0pt, dy: 0pt, fill: white, width: 1cm, height: 1cm, label: none) = {
  meander.placed(
    alignment, dx: dx, dy: dy,
    boundary: meander.contour.margin(5pt),
  )[#box(fill: fill.transparentize(70%), width: width, height: height, radius: 2mm)[#align(center + horizon)[#label]]]
}

#let filler = [
  #set heading(outlined: false)
  = Lorem

  _#lorem(12)_

  #lorem(150)

  = Ipsum
  #lorem(350)
]

#meander.reflow(allow-overflow: true, {
  fakeimg(top + left, width: 5cm, height: 6cm, fill: green)
  fakeimg(bottom + left, width: 4cm, height: 4cm, fill: red)
  fakeimg(bottom + right, width: 2cm, height: 4cm, fill: blue)
  fakeimg(top + right, width: 4cm, height: 8cm, fill: orange)
  meander.container()
  meander.content[
    #set par(justify: true)
    #filler
  ]
})

