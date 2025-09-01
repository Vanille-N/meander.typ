#import "/src/threading.typ": reflow
#import "/src/contour.typ": *

#context reflow[#redraw(
  debug: true,
  div: 20,
  grid: (x, y) => true,
  place(center)[
    #circle(radius: 6cm, fill: yellow)
  ],
)]

#pagebreak()

#context reflow[#redraw(
  debug: true,
  div: 20,
  grid: (x, y) => {
    calc.pow(2 * x - 1, 2) + calc.pow(2 * y - 1, 2) <= 1
  },
  place(center + horizon)[
    #circle(radius: 5cm, fill: yellow)
  ],
)]

#pagebreak()

#context reflow[#redraw(
  debug: true,
  div: 20,
  grid: (x, y) => {
    calc.pow(2 * x - 1, 2) + calc.pow(2 * y - 1, 2) <= 1
  },
  place(center)[
    #circle(radius: 6cm, fill: yellow)
  ],
)]

#pagebreak()

#context reflow[#redraw(
  debug: true,
  div: 20,
  grid: (x, y) => calc.abs(x - y) <= 0.06,
  place(center + top)[
    #line(end: (5cm, 5cm))
  ],
)]
#context reflow[#redraw(
  debug: true,
  div: 20,
  horiz: y => (y - 0.07, y + 0.07),
  place(center + horizon)[
    #line(end: (5cm, 5cm))
  ],
)]
#context reflow[#redraw(
  debug: true,
  div: 20,
  vert: x => (x - 0.07, x + 0.07),
  place(center + bottom)[
    #line(end: (5cm, 5cm))
  ],
)]

#pagebreak()

#context reflow[#redraw(
  debug: true,
  div: 20,
  flush: right,
  width: y => (1 - y, 0.1),
  place(center + top)[
    #line(end: (5cm, 5cm))
  ],
)]
#context reflow[#redraw(
  debug: true,
  div: 20,
  flush: left,
  width: y => (y, 0.1),
  place(center + horizon)[
    #line(end: (5cm, 5cm))
  ],
)]
#context reflow[#redraw(
  debug: true,
  div: 20,
  flush: center,
  width: y => (y, 0.1),
  place(center + bottom)[
    #line(end: (5cm, 5cm))
  ],
)]

#pagebreak()

#context reflow[#redraw(
  debug: true,
  div: 20,
  flush: top,
  height: y => (1 - y, 0.1),
  place(center + top)[
    #line(end: (5cm, 5cm))
  ],
)]
#context reflow[#redraw(
  debug: true,
  div: 20,
  flush: bottom,
  height: y => (y, 0.1),
  place(center + horizon)[
    #line(end: (5cm, 5cm))
  ],
)]
#context reflow[#redraw(
  debug: true,
  div: 20,
  flush: horizon,
  height: y => (y, 0.1),
  place(center + bottom)[
    #line(end: (5cm, 5cm))
  ],
)]

// Other drawing functions:
// - horizontal
// - vertical
// - stacked

