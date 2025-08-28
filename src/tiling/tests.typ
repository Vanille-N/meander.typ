#import "default.typ": *

#let tile(ct) = layout(size => {
  let (flow, placed, free) = separate(ct)
  let forbidden = forbidden-rectangles(placed, margin: 5pt, size: size)
  forbidden.debug
  forbidden.display

  let allowed = tolerable-rectangles(free, avoid: forbidden.rects, size: size)
  allowed.debug
})

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

// TODO: count previous allowed boxes when splitting new ones
// TODO: allow controling the alignment inside boxes
// TODO: forbid stretching the boxes beyond major containers
// TODO: handle pagebreaks
// TODO: hyphenation
