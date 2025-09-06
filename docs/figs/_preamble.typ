#import "/src/lib.typ" as meander

#let fakeimg(alignment, dx: 0pt, dy: 0pt, fill: white, width: 1cm, height: 1cm, label: none) = {
  meander.placed(
    alignment, dx: dx, dy: dy,
    boundary: meander.contour.margin(5pt),
  )[#box(fill: fill.transparentize(70%), width: width, height: height, radius: 2mm)[#align(center + horizon)[#label]]]
}

#let my-img-1 = box(width: 7cm, height: 7cm, fill: orange.transparentize(70%), radius: 2mm)[#align(center + horizon)[#text(size: 30pt)[`1`]]]
#let my-img-2 = box(width: 5cm, height: 3cm, fill: blue.transparentize(70%), radius: 2mm)[#align(center + horizon)[#text(size: 30pt)[`2`]]]
#let my-img-3 = box(width: 8cm, height: 4cm, fill: green.transparentize(70%), radius: 2mm)[#align(center + horizon)[#text(size: 30pt)[`3`]]]
#let my-img-4 = box(width: 5cm, height: 5cm, fill: red.transparentize(70%), radius: 2mm)[#align(center + horizon)[#text(size: 30pt)[`4`]]]
#let my-img-5 = box(width: 4cm, height: 3cm, fill: yellow.transparentize(70%), radius: 2mm)[#align(center + horizon)[#text(size: 30pt)[`5`]]]

