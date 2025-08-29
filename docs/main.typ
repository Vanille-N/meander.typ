#align(center)[
  #text(size: 30pt)[*Meander*] \
  #text(size: 25pt)[User guide]
]

= Description

Meander implements a content layout algorithm to provide text threading
(when text from one box spills into a different box if it overflows)
and image wrap-around.

#import "../src/lib.typ" as meander

#let fakeimg(alignment, dx: 0pt, dy: 0pt, fill: white, width: 1cm, height: 1cm, label: none) = {
  place(alignment, dx: dx, dy: dy)[#box(fill: fill.transparentize(70%), width: width, height: height, radius: 2mm)[#align(center + horizon)[#label]]]
}

#align(center)[
  #let filler = [
    = Lorem

    _#lorem(12)_

    #lorem(150)

    = Ipsum
    #lorem(350)
  ]
  #box(height: 50%, width: 50%, stroke: black, inset: 5mm)[
    #set text(size: 4pt)
    #context meander.reflow[
      #fakeimg(top + left, width: 2cm, height: 3cm, fill: green)
      #fakeimg(bottom + left, width: 2cm, height: 4cm, fill: red)
      #fakeimg(bottom + right, width: 1cm, height: 3cm, fill: blue)
      #fakeimg(top + right, width: 3cm, height: 4cm, fill: orange)
      #meander.container()
      #filler
    ]
  ]
]

= Quick start

The main function provided is `meander.reflow`, which takes as input some content,
and auto-splits it into "containers", "obstacles", and "flowing text".
Obstacles are `content` that are placed on the page with a fixed layout.
Containers are created by the function `meander.container`, and everything
else is flowing text.

After excluding the zones forbidden by obstacles and segmenting the containers
appropriately, the threading algorithm will split the flowing content across
containers to wrap around the forbidden regions.

== A simple example

#table(columns: (1fr, 1fr), stroke: none)[
  `meander.reflow` is contextual, so the invocation needs to be wrapped in a
  `context { ... }` block. Currently multi-page setups are not supported,
  but this is definitely a desired feature.

  ```typ
  #context meander.reflow[
    // Obstacle
    #place(top + left, my-image-1)

    // Full-page container
    #meander.container()

    // Flowing text
    #lorem(500)
  ]
  ```
][
  #box(height: 45%, width: 100%, stroke: black, inset: 5mm)[
    #set text(size: 5pt)
    #context meander.reflow[
      #fakeimg(top + left, width: 3cm, height: 3cm, fill: orange, label: text(size: 14pt)[`1`])
      #meander.container()
      #lorem(600)
    ]
  ]
]

== Multiple obstacles

#table(columns: (1fr, 1fr), stroke: none)[
  `meander.reflow` can handle as many obstacles as you provide
  (at the cost of potentially performance issues if there are too many,
  but experiments have shown that up to \~100 obstacles is no problem).

  ```typ
  #context meander.reflow[
    // Multiple obstacles
    #place(top + left, my-image-1)
    #place(top + right, my-image-2)
    #place(right, my-image-3)
    #place(bottom + left, my-image-4)
    #place(bottom + left, my-image-5,
      dx: 2cm)

    #meander.container()
    #lorem(500)
  ]
  ```
][
  #box(height: 45%, width: 100%, stroke: black, inset: 5mm)[
    #set text(size: 5pt)
    #context meander.reflow[
      #fakeimg(top + left, width: 3cm, height: 3cm, fill: orange, label: text(size: 14pt)[`1`])
      #fakeimg(top + right, width: 2cm, height: 1cm, fill: blue, label: text(size: 14pt)[`2`])
      #fakeimg(right, width: 4cm, height: 2cm, fill: green, label: text(size: 14pt)[`3`])
      #fakeimg(bottom + left, width: 2cm, height: 2cm, fill: red, label: text(size: 14pt)[`4`])
      #fakeimg(bottom + left, dx: 2.1cm, width: 1.5cm, height: 1cm, fill: yellow, label: text(size: 14pt)[`5`])
      #meander.container()
      #lorem(600)
    ]
  ]
]

== Columns

#table(columns: (1fr, 1fr), stroke: none)[
  In order to simulate a multi-column layout, you can provide several
  `container` invocations. They will be filled in the order provided.

  ```typ
  #context meander.reflow[
    #place(bottom + right, my-image-1)
    #place(center + horizon, my-image-2,
      dy: -1cm)
    #place(top + right, my-image-3)

    // Multiple containers produce
    // multiple columns.
    #meander.container(width: 55%)
    #meander.container(right, width: 40%)

    #lorem(600)
  ]
  ```
][
  #box(height: 45%, width: 100%, stroke: black, inset: 5mm)[
    #set text(size: 5pt)
    #context meander.reflow[
      #fakeimg(bottom + right, width: 3cm, height: 3cm, fill: orange, label: text(size: 14pt)[`1`])
      #fakeimg(center + horizon, dy: -1cm, width: 2cm, fill: blue, label: text(size: 14pt)[`2`])
      #fakeimg(top + right, width: 4cm, height: 2cm, fill: green, label: text(size: 14pt)[`3`])

      #meander.container(width: 55%)
      #meander.container(right, width: 40%)

      #lorem(600)
    ]
  ]
]

= Understanding the algorithm

#table(columns: (1fr, 1fr), stroke: none)[
  The same page setup as the previous example will internally be separated into
  - obstacles `my-image-1`, `my-image-2`, and `my-image-3`.
    They are shown on the right in red.
  - containers `(x: 0%, y: 0%, width: 55%, height: 100%)`
    and `(x: 60%, y: 0%, width: 40%, height: 100%)`
  - flowing text `lorem(600)`, not shown here.

  Respecting the horizontal separations of the obstacles, and staying within
  the bounds of the containers, the page is split into the subcontainers
  shown to the right in green.
  These boxes will be filled in order, including heuristics to properly provide
  vertical spacing between these boxes.
][
  #box(height: 45%, width: 100%, stroke: black, inset: 5mm)[
    #set text(size: 5pt)
    #import "../src/tiling/tests.typ" as tiling
    #context tiling.tile[
      #fakeimg(bottom + right, width: 3cm, height: 3cm, fill: orange, label: text(size: 14pt)[`1`])
      #fakeimg(center + horizon, dy: -1cm, width: 2cm, fill: blue, label: text(size: 14pt)[`2`])
      #fakeimg(top + right, width: 4cm, height: 2cm, fill: green, label: text(size: 14pt)[`3`])

      #meander.container(width: 55%)
      #meander.container(right, width: 40%)
    ]
  ]
]

= Advanced techniques

#table(columns: (1fr, 1fr), stroke: none)[
  Here is a way to achieve text that follows a special shape.

  ```typ
  #context meander.reflow[
    // Draw a half circle of empty boxes
    // that will count as obstacles
    #let vradius = 45%
    #let vcount = 50
    #let hradius = 60%
    #for i in range(vcount) {
      let frac = 2 * (i+0.5) / vcount - 1
      let width = hradius *
        calc.sqrt(1 - frac - frac)
      place(
        left + horizon,
        dy: (i - vcount / 2) *
          (2 * vradius / vcount)
      )[
        #box(
          width: width,
          height: 2 * vradius / vcount
        )
      ]
    }

    // Then do the usual
    #meander.container()
    #lorem(600)
  ]
  ```
][
  #box(height: 45%, width: 100%, stroke: black, inset: 5mm)[
    #set text(size: 5pt)
    #context meander.reflow[
      #let vradius = 45%
      #let vcount = 50
      #let hradius = 60%
      #{for i in range(vcount) {
        let frac = (2 * (i + 0.5) / vcount) - 1
        let width = calc.sqrt(1 - frac * frac) * hradius
        fakeimg(left + horizon, dy: (i - vcount / 2) * (2 * vradius / vcount), width: width, height: 2 * vradius / vcount, fill: white)
      }}
      #meander.container()
      #lorem(600)
    ]
  ]
]

There are limits to this technique, and in particular increasing the
number of obstacles will in turn increase the number of boxes that the layout
is segmented into. This means
- performance issues if you get too wild (though notice that having 50 obstacles
  in the previous example went fine)
- text that doesn't fit in the boxes at all, in particular if you don't give
  them any vertical space to grow because they are bounded on both sides.

In short, stay reasonable with this and don't try to add hundreds of
obstacles of 1mm height each.


= Modularity (WIP)

Because meander is cleanly split into three algorithms
(content segmentation, page segmentation, text threading),
there are plans to provide
- configuration options for each of those steps
- the ability to replace entirely an algorithm by either a variant,
  or a user-provided alternative that follows the same signature.

= Module details

#import "@preview/tidy:0.4.3"

#let parse-and-show(path, header) = {
  let path = "../src/" + path
  header
  import path as mod
  let docs = tidy.parse-module(
    read(path),
    scope: (mod: mod),
    preamble: "#import mod: *;",
  )
  tidy.show-module(
    docs,
    style: tidy.styles.default,
    sort-functions: none,
  )
}

#parse-and-show("geometry.typ")[
  == Geometry (`geometry.typ`)
  Generalist functions for 1D and 2D geometry.
]

#parse-and-show("tiling/default.typ")[
  == Tiling (`tiling/default.typ`)
  Page splitting algorithm.
]

#parse-and-show("bisect/default.typ")[
  = Bisection (`bisect/default.typ`)
  Content splitting algorithm.
]


