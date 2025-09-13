#import "/src/threading.typ": *
#import "/src/tiling.typ": container, content, placed

#let fakeimg(align, dx: 0pt, dy: 0pt, fill: white, width: 1cm, height: 1cm) = {
  placed(align, dx: dx, dy: dy,
    box(fill: fill.transparentize(70%), width: width, height: height, radius: 5mm)
  )
}

#let filler = lorem(1000)
//#let filler = range(1000).map(str).join(" ")

#[
#set text(hyphenate: false)
#reflow(debug: true, {
  let vradius = 12.2cm
  let vcount = 50
  let hradius = 5cm
  for i in range(vcount) {
    let frac = (2 * (i + 0.5) / vcount) - 1
    let width = calc.sqrt(1 - frac * frac) * 10cm
    fakeimg(top + left, dy: i * (2 * vradius / vcount), width: width, height: 2 * vradius / vcount, fill: red)
  }
  container(align: top + left)
  content[
    #set text(fill: blue)
    #lorem(10)
    #lorem(10) \
    #lorem(10)
  ]

  content[
    #set text(fill: red)
    #lorem(15)
    #v(1cm)
    #lorem(10)
  ]

  content[
    #set text(fill: green)
    #set par(justify: false)
    #set linebreak(justify: true)
    #lorem(50) \
  ]

  content[
    #set text(fill: orange)
    #set par(justify: true)
    #set linebreak(justify: false)
    #lorem(27) \
    #lorem(20) \
  ]

  content[
    #set text(fill: purple)
    #set par(justify: true)
    #set linebreak(justify: true)
    #lorem(50) \
    #lorem(42) \
  ]
})
]

#pagebreak()

#[
#set text(hyphenate: true)
#reflow(debug: true, {
  let vradius = 12.2cm
  let vcount = 50
  let hradius = 5cm
  for i in range(vcount) {
    let frac = (2 * (i + 0.5) / vcount) - 1
    let width = calc.sqrt(1 - frac * frac) * 10cm
    fakeimg(top + left, dy: i * (2 * vradius / vcount), width: width, height: 2 * vradius / vcount, fill: red)
  }
  container(align: top + left)
  content[
    #set text(fill: blue)
    #lorem(10)
    #lorem(10) \
    #lorem(10)
  ]

  content[
    #set text(fill: red)
    #lorem(15)
    #v(1cm)
    #lorem(10)
  ]

  content[
    #set text(fill: green)
    #set par(justify: false)
    #set linebreak(justify: true)
    #lorem(50) \
  ]

  content[
    #set text(fill: orange)
    #set par(justify: true)
    #set linebreak(justify: false)
    #lorem(27) \
    #lorem(20) \
  ]

  content[
    #set text(fill: purple)
    #set par(justify: true)
    #set linebreak(justify: true)
    #lorem(50) \
    #lorem(42) \
  ]
})
]

#pagebreak()

#[
#set par(justify: true)
#reflow(debug: true, {
  let vradius = 12.2cm
  let vcount = 50
  let hradius = 5cm
  for i in range(vcount) {
    let frac = (2 * (i + 0.5) / vcount) - 1
    let width = calc.sqrt(1 - frac * frac) * 10cm
    fakeimg(top + left, dy: i * (2 * vradius / vcount), width: width, height: 2 * vradius / vcount, fill: red)
  }
  container()

  content[
    #set text(hyphenate: true)
    #lorem(150)
  ]
  content[
    #set text(hyphenate: false)
    #lorem(150)
  ]
})
]
