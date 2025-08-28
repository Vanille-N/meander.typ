#import "default.typ": *

#let fakeimg(align, dx: 0pt, dy: 0pt, fill: white, width: 1cm, height: 1cm) = {
  place(align, dx: dx, dy: dy)[#box(fill: fill.transparentize(70%), width: width, height: height, radius: 5mm)]
}

#let filler = lorem(1000)
//#let filler = range(1000).map(str).join(" ")

#set par(justify: false)
#context tile[
  #fakeimg(top + left, width: 5cm, height: 3cm, fill: green)
  #fakeimg(bottom + left, width: 3cm, height: 6cm, fill: red)
  #fakeimg(bottom + right, width: 2cm, height: 5cm, fill: blue)
  #fakeimg(top + right, width: 5cm, height: 8cm, fill: orange)
  #box(place({}))
  #filler
]
#pagebreak()
#context tile[
  #fakeimg(top + right, width: 8cm, height: 2cm, fill: orange)
  #fakeimg(top + left, dy: 5cm, height: 3cm, width: 3cm, fill: blue)
  #fakeimg(left + horizon, height: 1cm, width: 6cm, fill: green)
  #fakeimg(bottom + right, height: 6cm, width: 5cm, fill: red)
  #box(place({}))
  #filler
]
#pagebreak()
#context tile[
  #fakeimg(center + horizon, dx: 5%, dy: 10%, width: 7cm, height: 5cm, fill: green)
  #fakeimg(top + left, fill: blue, width: 6cm, height: 6cm)
  #fakeimg(bottom + right, fill: orange, width: 5cm, height: 3cm)
  #box(width: 47%, place({}))
  #box(width: 47%, place(top + right, {}))
  #filler
]
#pagebreak()
#context tile[
  #fakeimg(top + left, width: 7cm, height: 7cm, fill: green)
  #fakeimg(top + left, dx: 5cm, dy: 5cm, width: 6cm, height: 6cm, fill: orange)
  #box(width: 40%, place({}))
  #box(width: 55%, place(top + right, {}))
  #filler
]
#pagebreak()
#context tile[
  #fakeimg(top + center, width: 8cm, height: 2cm, fill: orange)
  #fakeimg(top + center, dy: 5cm, height: 3cm, width: 3cm, fill: blue)
  #fakeimg(center + horizon, height: 1cm, width: 6cm, fill: green)
  #fakeimg(bottom, height: 6cm, width: 5cm, fill: red)
  #box(width: 47%, place({}))
  #box(width: 47%, place(top + right, {}))
  #filler
]
#pagebreak()
#context tile[
  #{for i in range(11) {
    fakeimg(top + left, dy: i * 2.2cm, width: i * 1cm, height: 2cm, fill: orange)
    if i <= 8 {
      fakeimg(top + right, dy: i * 2.2cm, width: (8 - i) * 1cm, height: 2cm, fill: orange)
    }
  }}
  #box(place({}))
  #filler
]
#pagebreak()
#context tile[
  #let vradius = 12.2cm
  #let vcount = 50
  #let hradius = 5cm
  #{for i in range(vcount) {
    let frac = (2 * (i + 0.5) / vcount) - 1
    let width = calc.sqrt(1 - frac * frac) * 10cm
    fakeimg(top + left, dy: i * (2 * vradius / vcount), width: width, height: 2 * vradius / vcount, fill: red)
  }}
  #box(place(top + left, {}))
  #filler
]
#pagebreak()
#context tile[
  #{for i in range(30) {
    fakeimg(top + left, dy: -i * 4mm + 14cm, width: i * 3mm, height: 3mm, fill: blue)
    fakeimg(top + right, dy: -i * 4mm + 14cm, width: i * 3mm, height: 3mm, fill: blue)
    fakeimg(bottom + left, dy: i * 4mm - 14cm, width: i * 3mm, height: 3mm, fill: blue)
    fakeimg(bottom + right, dy: i * 4mm - 14cm, width: i * 3mm, height: 3mm, fill: blue)
  }}
  #box(place(top + left, {}))
  #filler
]

/*
#let test-content = [
  #lorem(50)
  - #lorem(30)
  - #lorem(12)
  - #lorem(20)
  - #lorem(20)

  #lorem(30)
  *#lorem(50)*
  #lorem(30)

  - #lorem(30)
  - #lorem(20)
  - #lorem(20)
  - #lorem(20)
  #align(center)[#rect(width: 50%, height: 3cm, fill: orange.transparentize(30%), radius: 5mm)]

  - #lorem(20)
    - #lorem(20)
    - #lorem(20)
    - #lorem(20)
    - #lorem(30)
  - #lorem(10)
  - #lorem(30)
  - #lorem(20)
]

#let test-boxes = (
  (width: 5cm, height: 3cm),
  (width: 7cm, height: 6cm),
  (width: 3cm, height: 8cm),
  (width: 6cm, height: 4cm),
  (width: 7cm, height: 3cm),
  (width: 5cm, height: 5cm),
  (width: 10cm, height: 4.5cm),
)

= Threading test (upfront, absolute boxes, no stretching)

#context for (container, content) in fill-boxes(
  test-content,
  ..test-boxes,
) {
  box(..container, stroke: black)[#content]
}

= Threading test (upfront, absolute boxes, auto stretching)

#context for (container, content) in fill-boxes(
  test-content,
  ..test-boxes,
) {
  box(..container, stroke: black)[#auto-stretch(container)[#content]]
}

= Alignment test (upfront, absolute boxes, auto stretching)

#let test-case(ct) = {
  table(
    columns: (1fr, 1fr, 1fr, 1fr, 1fr),
    ..for height in (4.6cm, 4.7cm, 4.8cm, 4.9cm, 5cm,) {
      let dims = (height: height, width: 3cm)
      (box(height: 10cm)[#{
        context {
          let boxes = ()
          for (container, content) in fill-boxes(ct, dims, dims) {
            boxes.push(box(..container, stroke: red)[#text(fill: red)[#auto-stretch(container)[#content]]])
            boxes.push([\ ])
          }
          place(top + left)[#table(..boxes, inset: 0pt, stroke: none)]
          place(top + left)[#box(width: dims.width, height: dims.height * 2, stroke: black)[#ct]]
        }
      }],)
    }
  )
}

#test-case[#lorem(35)]

= Alignment test (upfront, absolute boxes, truncation)

#let test-case(ct) = {
  table(
    columns: (1fr, 1fr, 1fr, 1fr, 1fr),
    ..for height in (4.6cm, 4.7cm, 4.8cm, 4.9cm, 5cm,) {
      let dims = (height: height, width: 3cm)
      (box(height: 10cm)[#{
        context {
          let boxes = ()
          for (container, content) in fill-boxes(ct, dims, dims) {
            boxes.push(box(width: container.width, stroke: red)[#text(fill: red)[#content]])
            boxes.push([\ ])
          }
          place(top + left)[#table(..boxes, inset: 0pt, stroke: none)]
          place(top + left)[#box(width: dims.width, height: dims.height * 2, stroke: black)[#ct]]
        }
      }],)
    }
  )
}

#test-case[#lorem(35)]

// Caveat: remember to put the #layout(_ => {}) call at the right location...
= Alignment test (upfront, relative boxes, truncation)

#let test-case(ct) = {
  table(
    columns: (1fr, 1fr, 1fr, 1fr, 1fr),
    ..{
      for height in (50%, 52%, 54%, 56%, 58%,) {
        let dims = (height: height, width: 100%)
        (box(height: 10cm)[#layout(size => {
          let boxes = ()
          for (container, content) in fill-boxes(ct, dims, dims, size: size) {
            boxes.push(box(width: container.width, stroke: red)[#text(fill: red)[#content]])
            boxes.push([\ ])
          }
          place(top + left)[#for box in boxes { box }]
          place(top + left)[#box(width: dims.width, height: 100%, stroke: black)[#ct]]
        })],)
      }
    }
  )
}

//#layout(size => panic(measure(box(width: 100%), ..size)))

#test-case[#lorem(35)]
*/

// TODO: count previous allowed boxes when splitting new ones
// TODO: allow controling the alignment inside boxes
// TODO: forbid stretching the boxes beyond major containers
// TODO: handle pagebreaks
// TODO: hyphenation
