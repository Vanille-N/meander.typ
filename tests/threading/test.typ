#import "/src/threading.typ": *
#import "/src/tiling.typ": container, placed, content, regions
#import "/src/contour.typ"

#let fakeimg(align, dx: 0pt, dy: 0pt, fill: white, width: 1cm, height: 1cm) = {
  placed(align, dx: dx, dy: dy,
    box(fill: fill.transparentize(70%), width: width, height: height, radius: 5mm)
  )
}

#let filler = lorem(1000)
//#let filler = range(1000).map(str).join(" ")

#set par(justify: false)

#reflow(overflow: true, {
  fakeimg(top + left, width: 5cm, height: 3cm, fill: green)
  fakeimg(bottom + left, width: 3cm, height: 6cm, fill: red)
  fakeimg(bottom + right, width: 2cm, height: 5cm, fill: blue)
  fakeimg(top + right, width: 5cm, height: 8cm, fill: orange)
  container()
  content(filler)
})

#pagebreak()

#reflow(overflow: true, {
  fakeimg(top + right, width: 8cm, height: 2cm, fill: orange)
  fakeimg(top + left, dy: 5cm, height: 3cm, width: 3cm, fill: blue)
  fakeimg(left + horizon, height: 1cm, width: 6cm, fill: green)
  fakeimg(bottom + right, height: 6cm, width: 5cm, fill: red)
  container()
  content(filler)
})

#pagebreak()

#reflow(overflow: true, {
  fakeimg(center + horizon, dx: 5%, dy: 10%, width: 7cm, height: 5cm, fill: green)
  fakeimg(top + left, fill: blue, width: 6cm, height: 6cm)
  fakeimg(bottom + right, fill: orange, width: 5cm, height: 3cm)
  container(width: 47%)
  container(align: top + right, width: 47%)
  content(filler)
})

#pagebreak()

#reflow(overflow: true, {
  fakeimg(top + left, width: 7cm, height: 7cm, fill: green)
  fakeimg(top + left, dx: 5cm, dy: 5cm, width: 6cm, height: 6cm, fill: orange)
  container(width: 40%)
  container(align: top + right, width: 55%)
  content(filler)
})

#pagebreak()

#reflow(overflow: true, {
  fakeimg(top + center, width: 8cm, height: 2cm, fill: orange)
  fakeimg(top + center, dy: 5cm, height: 3cm, width: 3cm, fill: blue)
  fakeimg(center + horizon, height: 1cm, width: 6cm, fill: green)
  fakeimg(center + bottom, height: 6cm, width: 5cm, fill: red)
  container(width: 47%)
  container(align: top + right, width: 47%)
  content(filler)
})

#pagebreak()

#reflow(overflow: true, {
  for i in range(11) {
    fakeimg(top + left, dy: i * 2.2cm, width: i * 1cm, height: 2cm, fill: orange)
    if i <= 8 {
      fakeimg(top + right, dy: i * 2.2cm, width: (8 - i) * 1cm, height: 2cm, fill: orange)
    }
  }
  container()
  content(filler)
})

#pagebreak()

#[
  #set text(hyphenate: false)
  #set par(justify: true)
  #set linebreak(justify: true)
#reflow(overflow: true, {
  let vradius = 12.2cm
  let vcount = 50
  let hradius = 5cm
  for i in range(vcount) {
    let frac = (2 * (i + 0.5) / vcount) - 1
    let width = calc.sqrt(1 - frac * frac) * 10cm
    fakeimg(top + left, dy: i * (2 * vradius / vcount), width: width, height: 2 * vradius / vcount, fill: red)
  }
  container()
  content(filler)
})
]

#pagebreak()

#reflow(overflow: true, {
  for i in range(30) {
    fakeimg(top + left, dy: -i * 4mm + 14cm, width: i * 3mm, height: 3mm, fill: blue)
    fakeimg(top + right, dy: -i * 4mm + 14cm, width: i * 3mm, height: 3mm, fill: blue)
    fakeimg(bottom + left, dy: i * 4mm - 14cm, width: i * 3mm, height: 3mm, fill: blue)
    fakeimg(bottom + right, dy: i * 4mm - 14cm, width: i * 3mm, height: 3mm, fill: blue)
  }
  container()
  content(filler)
})

#pagebreak()

#place(center + horizon)[#box(width: 5cm, height: 5cm, fill: blue)]
#reflow(overflow: true, {
  container(align: center + horizon, width: 5cm, height: 5cm)
  content(filler)
})

#pagebreak()

#reflow(debug: true, overflow: true, {
  placed(bottom + left,
    boundary: contour.horiz(div: 70, y => (0, y)) + contour.margin(2pt),
    box(width: 70%, height: 70%),
  )
  placed(top + right,
    boundary: contour.horiz(div: 70, y => (y, 1)) + contour.margin(2pt),
    box(width: 70%, height: 70%),
  )
  container()
  content[#lorem(600)]
})

