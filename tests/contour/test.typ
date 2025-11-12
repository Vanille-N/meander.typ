#import "/src/lib.typ" as meander
#import meander: reflow, placed, container, content, contour

#reflow(debug: meander.debug.post-thread, {
  placed(
    center,
    boundary: contour.grid(div: 20, (x,y) => true),
    circle(radius: 6cm, fill: yellow)
  )
})

#pagebreak()

#reflow(debug: meander.debug.post-thread, {
  placed(
    center + horizon,
    boundary: contour.margin(1cm) + contour.grid(div: 20, (x, y) => {
      calc.pow(2 * x - 1, 2) + calc.pow(2 * y - 1, 2) <= 1
    }),
    circle(radius: 5cm, fill: yellow)
  )
})

#pagebreak()

#reflow(debug: meander.debug.post-thread, {
  placed(
    center,
    boundary: contour.grid(div: 20, (x, y) => {
      calc.pow(2 * x - 1, 2) + calc.pow(2 * y - 1, 2) <= 1
    }),
    circle(radius: 6cm, fill: yellow),
  )
})

#pagebreak()

#reflow(debug: meander.debug.post-thread, {
  placed(
    center + top,
    boundary: contour.margin(5pt) + contour.grid(div: 20, (x, y) => {
      calc.abs(x - y) <= 0.06
    }),
    line(end: (5cm, 5cm))
  )
})


#reflow(debug: meander.debug.post-thread, {
  placed(
    center + horizon,
    boundary: contour.margin(5pt) + contour.horiz(div: 20, y => (y - 0.07, y + 0.07)),
    line(end: (5cm, 5cm)),
  )
})

#reflow(debug: meander.debug.post-thread, {
  placed(
    center + bottom,
    boundary: contour.margin(5pt) + contour.vert(div: 20, x => (x - 0.07, x + 0.07)),
    line(end: (5cm, 5cm)),
  )
})

#pagebreak()

#reflow(debug: meander.debug.post-thread, {
  placed(
    center + top,
    boundary: contour.margin(5pt) + contour.width(
      div: 20,
      flush: right,
      y => (1 - y, 0.1),
    ),
    line(end: (5cm, 5cm))
  )
})

#reflow(debug: meander.debug.post-thread, {
  placed(
    center + horizon,
    boundary: contour.margin(5pt) + contour.width(
      div: 20, flush: left,
      y => (y, 0.1),
    ),
    line(end: (5cm, 5cm))
  )
})

#reflow(debug: meander.debug.post-thread, {
  placed(
    center + bottom,
    boundary: contour.margin(5pt) + contour.width(
      div: 20, flush: center,
      y => (y, 0.1),
    ),
    line(end: (5cm, 5cm))
  )
})

#pagebreak()

#reflow(debug: meander.debug.post-thread, {
  placed(
    center + top,
    boundary: contour.margin(5pt) + contour.height(
      div: 20, flush: top,
      y => (1 - y, 0.1),
    ),
    line(end: (5cm, 5cm))
  )
})

#reflow(debug: meander.debug.post-thread, {
  placed(
    center + horizon,
    boundary: contour.margin(5pt) + contour.height(
      div: 20, flush: bottom,
      y => (y, 0.1),
    ),
    line(end: (5cm, 5cm))
  )
})

#reflow(debug: meander.debug.post-thread, {
  placed(
    center + bottom,
    boundary: contour.margin(5pt) + contour.height(
      div: 20, flush: horizon,
      y => (y, 0.1)
    ),
    line(end: (5cm, 5cm))
  )
})

#pagebreak()

#reflow(debug: meander.debug.post-thread, {
  placed(
    center + horizon,
    dx: -5cm,
    dy: -5cm,
    boundary: contour.margin(x: 1cm, top: 5mm),
    circle(radius: 3cm, fill: yellow),
  )
  placed(
    center + horizon,
    dx: 5cm,
    dy: -5cm,
    boundary: contour.margin(1cm, bottom: 1mm),
    circle(radius: 3cm, fill: yellow),
  )
  placed(
    center + horizon,
    dx: -5cm,
    dy: 5cm,
    boundary: contour.margin(top: 1mm, bottom: 2mm, left: 3mm, right: 4mm),
    circle(radius: 3cm, fill: yellow),
  )
  placed(
    center + horizon,
    dx: 5cm,
    dy: 5cm,
    boundary: contour.margin(1mm, y: 1cm, bottom: 1mm),
    circle(radius: 3cm, fill: yellow),
  )
})

#pagebreak()

#reflow(debug: meander.debug.post-thread, {
  placed(
    center + horizon,
    boundary: contour.phantom(),
    circle(radius: 5cm, fill: yellow),
  )
  container()
  content[#lorem(600)]
})

