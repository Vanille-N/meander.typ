#align(center)[
  #text(size: 30pt)[*Meander*] \
  #text(size: 25pt)[User guide]
]

#show link: set text(fill: blue.darken(20%))

//#show raw.where(lang: "typ", block: true): box.with(baseline: 1pt, radius: 2pt, inset: 1pt, fill: gray.transparentize(85%))
//#show raw.where(lang: "typ", block: false): highlight.with(radius: 2pt, fill: gray.transparentize(85%))

#import "../src/lib.typ" as meander

#let fakeimg(alignment, dx: 0pt, dy: 0pt, fill: white, width: 1cm, height: 1cm, label: none) = {
  place(alignment, dx: dx, dy: dy)[#box(fill: fill.transparentize(70%), width: width, height: height, radius: 2mm)[#align(center + horizon)[#label]]]
}

#let pseudopage(content) = {
  box(width: 7cm, height: 11cm, stroke: 1pt, inset: 5mm)[
    #set text(size: 5pt)
    #context { content }
  ]
}

#v(2cm)

#table(columns: 2, stroke: none)[
  *Abstract* \
  Meander implements a content layout algorithm to provide text threading
  (when text from one box spills into a different box if it overflows),
  uneven columns, and image wrap-around.

  *Feature requests* \
  For as long as the feature doesn't exist natively in Typst
  (see issue: #link("https://github.com/typst/typst/issues/5181")[`github:typst/typst #5181`]),
  feel free to submit test cases of layouts you would like to see supported
  by opening a new #link("https://github.com/Vanille-N/meander.typ/issues")[issue].

  *Versions* \
  - #link("https://github.com/Vanille-N/meander.typ")[`dev`]
  - #link("https://typst.app/universe/package/meander")[`0.1.0`]
][
  #align(center)[
    #let filler = [
      #set heading(outlined: false)
      = Lorem

      _#lorem(12)_

      #lorem(150)

      = Ipsum
      #lorem(350)
    ]
    #pseudopage[
      #meander.reflow[
        #fakeimg(top + left, width: 1.5cm, height: 3cm, fill: green)
        #fakeimg(bottom + left, width: 2cm, height: 2cm, fill: red)
        #fakeimg(bottom + right, width: 1cm, height: 2cm, fill: blue)
        #fakeimg(top + right, width: 2cm, height: 4cm, fill: orange)
        #meander.container()
        #set par(justify: true)
        #filler
      ]
    ]
  ]
]

#align(bottom)[
  #line(length: 100%)
  #outline(depth: 2)
]
#set heading(numbering: (..nums) => {
  let nums = nums.pos()
  if nums.len() <= 2 {
    return numbering("A.1 -", ..nums)
  } else {
    return ""
  }
})

#pagebreak()

= Quick start

The main function provided is ```typ #meander.reflow```, which takes as input some content,
and auto-splits it into "containers", "obstacles", and "flowing text".
Obstacles are toplevel (must not be inside any containers or any styling rules)
```typ content``` that are placed on the page with a fixed layout.
Containers are created at the toplevel by the function ```typ #meander.container```,
and everything else is flowing text.

After excluding the zones forbidden by obstacles and segmenting the containers
appropriately, the threading algorithm will split the flowing content across
containers to wrap around the forbidden regions.

== A simple example

#table(columns: (1fr, 1fr), stroke: none)[
  ```typ #meander.reflow``` is contextual, so the invocation needs to be wrapped in a
  ```typ #context { ... }``` block. Currently multi-page setups are not supported,
  but this is definitely a desired feature.

  ```typ
  #context meander.reflow[
    // Obstacle
    #place(top + left, my-image-1)

    // Full-page container
    #meander.container()

    // Flowing text
    #set heading(numbering: "1.")
    = Lorem
    _#lorem(30)_

    = Ipsum
    #[
      #set par(justify: true)
      #lorem(200)
    ]

    = Dolor
    #lorem(100)
  ]
  ```
][
  #pseudopage[
    #meander.reflow[
      #fakeimg(top + left, width: 2.5cm, height: 3cm, fill: orange, label: text(size: 14pt)[`1`])
      #meander.container()
      #text(size: 8pt)[*1. Lorem*] \
      _#lorem(30)_

      #text(size: 8pt)[*2. Ipsum*] \
      #[
        #set par(justify: true)
        #lorem(200)
      ]

      #text(size: 8pt)[*3. Dolor*] \
      #lorem(100)
    ]
  ]
]

Meander is expected to respect the majority of styling options,
including headings, paragraph justification, font size, etc.
If you find a discrepancy make sure to file it as a
#link("https://github.com/Vanille-N/meander.typ/issues")[bug report]
if it is not already part of the
#link("https://github.com/Vanille-N/meander.typ/tree/master/KNOWN-ISSUES.md")[known limitations].

Note: paragraph breaks may behave incorrectly. You can insert vertical spaces if needed.


== Multiple obstacles

#table(columns: (1fr, 1fr), stroke: none)[
  ```typ #meander.reflow``` can handle as many obstacles as you provide
  (at the cost of potentially performance issues if there are too many,
  but experiments have shown that up to \~100 obstacles is no problem).

  ```typ
  #context meander.reflow[
    // Multiple obstacles
    #place(top + left, my-image-1)
    #place(top + right, my-image-2)
    #place(horizon + right, my-image-3)
    #place(bottom + left, my-image-4)
    #place(bottom + left, my-image-5,
      dx: 2cm)

    #meander.container()
    #set par(justify: true)
    #lorem(500)
  ]
  ```
][
  #pseudopage[
    #meander.reflow[
      #fakeimg(top + left, width: 2.5cm, height: 3cm, fill: orange, label: text(size: 14pt)[`1`])
      #fakeimg(top + right, width: 2cm, height: 1cm, fill: blue, label: text(size: 14pt)[`2`])
      #fakeimg(horizon + right, width: 4cm, height: 2cm, fill: green, label: text(size: 14pt)[`3`])
      #fakeimg(bottom + left, width: 2cm, height: 2cm, fill: red, label: text(size: 14pt)[`4`])
      #fakeimg(bottom + left, dx: 2.1cm, width: 1.5cm, height: 1cm, fill: yellow, label: text(size: 14pt)[`5`])
      #meander.container()
      #set par(justify: true)
      #lorem(600)
    ]
  ]
]

== Columns

#table(columns: (1fr, 1fr), stroke: none)[
  In order to simulate a multi-column layout, you can provide several
  ```typ container``` invocations. They will be filled in the order provided.

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
  #pseudopage[
    #meander.reflow[
      #fakeimg(bottom + right, width: 2.7cm, height: 3cm, fill: orange, label: text(size: 14pt)[`1`])
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
  - containers ```typ #(x: 0%, y: 0%, width: 55%, height: 100%)```
    and ```typ #(x: 60%, y: 0%, width: 40%, height: 100%)```
  - flowing text ```typ #lorem(600)```, not shown here.

  Initially obstacles are placed on the page #text(fill: purple)[($->$)] and surrounded by an
  exclusion zone with a small (soon to be configurable) margin.

  Then the containers are placed on the page and segmented into rectangles
  to avoid the exclusion zones #text(fill: purple)[($arrow.b$)].

  Finally the flowing text is threaded through those boxes
  #text(fill: purple)[($arrow.br$)], which may be resized vertically a bit compared
  to the initial segmentation.
][
  #pseudopage[
    #meander.debug-reflow[
      #fakeimg(bottom + right, width: 2.7cm, height: 3cm, fill: orange, label: text(size: 14pt)[`1`])
      #fakeimg(center + horizon, dy: -1cm, width: 2cm, fill: blue, label: text(size: 14pt)[`2`])
      #fakeimg(top + right, width: 4cm, height: 2cm, fill: green, label: text(size: 14pt)[`3`])
    ]
  ]
][
  #pseudopage[
    #meander.debug-reflow[
      #fakeimg(bottom + right, width: 2.7cm, height: 3cm, fill: orange, label: text(size: 14pt)[`1`])
      #fakeimg(center + horizon, dy: -1cm, width: 2cm, fill: blue, label: text(size: 14pt)[`2`])
      #fakeimg(top + right, width: 4cm, height: 2cm, fill: green, label: text(size: 14pt)[`3`])

      #meander.container(width: 55%)
      #meander.container(right, width: 40%)
    ]
  ]
][
  #pseudopage[
    #meander.reflow(debug: true)[
      #fakeimg(bottom + right, width: 2.7cm, height: 3cm, fill: orange, label: text(size: 14pt)[`1`])
      #fakeimg(center + horizon, dy: -1cm, width: 2cm, fill: blue, label: text(size: 14pt)[`2`])
      #fakeimg(top + right, width: 4cm, height: 2cm, fill: green, label: text(size: 14pt)[`3`])

      #meander.container(width: 55%)
      #meander.container(right, width: 40%)
      #lorem(600)
    ]
  ]
]
#pagebreak()

The order in which the boxes are filled is in the priority of
- container order
- top $->$ bottom
- left $->$ right
which has implications for how your text will be laid out.
Indeed compare the following situations that result in the same boxes but in
different orders:

#table(columns: (1fr, 1fr), stroke: none)[
  ```typ
  #context meander.reflow[
    #place(center + horizon,
      line(end: (100%, 0%)))
    #place(center + horizon,
      line(end: (0%, 100%)))

    #meander.container(width: 100%)

  ]
  ```
][
  ```typ
  #context meander.reflow[
    #place(center + horizon,
      line(end: (100%, 0%)))
    #place(center + horizon,
      line(end: (0%, 100%)))

    #meander.container(width: 50%)
    #meander.container(right, width: 50%)
  ]
  ```
][
  #pseudopage[
    #context meander.debug-reflow[
      #place(center + horizon)[#line(end: (100%, 0%))]
      #place(center + horizon)[#line(end: (0%, 100%))]

      #meander.container(width: 100%)
    ]
    #place(center + horizon, dx: -25%, dy: -25%)[#text(size: 50pt)[*1*]]
    #place(center + horizon, dx: 25%, dy: -25%)[#text(size: 50pt)[*2*]]
    #place(center + horizon, dx: -25%, dy: 25%)[#text(size: 50pt)[*3*]]
    #place(center + horizon, dx: 25%, dy: 25%)[#text(size: 50pt)[*4*]]
  ]
][
  #pseudopage[
    #context meander.debug-reflow[
      #place(center + horizon)[#line(end: (100%, 0%))]
      #place(center + horizon)[#line(end: (0%, 100%))]

      #meander.container(width: 50%)
      #meander.container(right, width: 50%)
    ]
    #place(center + horizon, dx: -25%, dy: -25%)[#text(size: 50pt)[*1*]]
    #place(center + horizon, dx: 25%, dy: -25%)[#text(size: 50pt)[*3*]]
    #place(center + horizon, dx: -25%, dy: 25%)[#text(size: 50pt)[*2*]]
    #place(center + horizon, dx: 25%, dy: 25%)[#text(size: 50pt)[*4*]]
  ]
]
And even in the example above, the box *1* will be filled before the first
line of *2* is used.
In short, Meander *does not "guess" columns*. If you want columns rather than
a top-bottom and left-right layout, you need to specify them.

#pagebreak()

= Advanced techniques

Although Meander started as only a text threading engine,
the ability to place text in boxes of unequal width has direct applications
in more advanced paragraph shapes. This has been a desired feature since at
least #link("https://github.com/typst/typst/issues/5181")[issue \#5181].

Even though this is somewhat outside of the original feature roadmap,
Meander makes an effort for this application to be more user-friendly,
by providing retiling functions. Here we walk through these steps.

Here is our starting point: a simple double-column page
with a cutout in the middle for an image.
```typ
#context meander.reflow[
  #place(center + horizon)[
    #circle(radius: 1.5cm, fill: yellow)
  ]

  #meander.container(width: 48%)
  #meander.container(right, width: 48%)

  #set par(justify: true)
  #lorem(600)
]
```
#table(columns: (1fr, 1fr), stroke: none)[
  #pseudopage[
    #context meander.debug-reflow[
      #place(center + horizon)[#circle(radius: 1.5cm, fill: yellow)]

      #meander.container(width: 48%)
      #meander.container(right, width: 48%)

      #set par(justify: true)
      #lorem(600)
    ]
  ]
][
  #pseudopage[
    #context meander.reflow[
      #place(center + horizon)[#circle(radius: 1.5cm, fill: yellow)]

      #meander.container(width: 48%)
      #meander.container(right, width: 48%)

      #set par(justify: true)
      #lorem(600)
    ]
  ]
]
Meander sees all obstacles as rectangular, so the circle leaves a big
ugly #link("https://www.youtube.com/watch?v=6pDH66X3ClA")[square hole] in our page.

Fear not! We can redraw the boundaries.
```typ #meander.redraw``` accepts as parameter a function normalized to
the interval $[0, 1]$ to define the real boundaries of the object relative
to its dimensions.
A `grid` redrawing function is from $[0, 1] times [0, 1]$ to `bool`,
returning for each normalized coordinate `(x, y)` whether it belongs to
the obstacle.

So instead of placing directly the circle, we write:
```typ
#meander.redraw(
  // How many subdivisions we want.
  div: 15,
  // Whether each point belongs to the circle or not.
  // Remember: x and y are normalized to [0, 1].
  grid: (x, y) => calc.pow(2 * x - 1, 2) + calc.pow(2 * y - 1, 2) <= 1,
  // The original object is measured, then is not counted as an obstacle.
  place(center + horizon)[#circle(radius: 1.5cm, fill: yellow)]
)
```
This results in the new subdivisions of containers below.
#table(columns: (1fr, 1fr), stroke: none)[
  #pseudopage[
    #context meander.debug-reflow[
      #meander.redraw(
        div: 15,
        grid: (x, y) => calc.pow(2 * x - 1, 2) + calc.pow(2 * y - 1, 2) <= 1,
        place(center + horizon)[#circle(radius: 1.5cm, fill: yellow)]
      )

      #meander.container(width: 48%)
      #meander.container(right, width: 48%)

      #set par(justify: true)
      #lorem(600)
    ]
  ]
][
  #pseudopage[
    #context meander.reflow[
      #meander.redraw(
        div: 15,
        grid: (x, y) => calc.pow(2 * x - 1, 2) + calc.pow(2 * y - 1, 2) <= 1,
        place(center + horizon)[#circle(radius: 1.5cm, fill: yellow)]
      )

      #meander.container(width: 48%)
      #meander.container(right, width: 48%)

      #set par(justify: true)
      #lorem(600)
    ]
  ]
]
Setting aside the obvious hyphenation issues above,
this enables in theory drawing arbitrary paragraph shapes.
If your shape is not convenient to express through a grid function, here
are the other options available:
- `vert`: given `x`, return a tuple `(top, bottom)` where `top < bottom`,
  resulting in an obstacle between `top` and `bottom`.
- `height`: given `x`, return a tuple `(anchor, height)`,
  resulting in an obstacle of height `height`.
  The interpretation of `anchor` depends on the additional parameter
  `flush` passed to the function `#redraw`: if `flush = top` then `anchor`
  will be the top of the obstacle. If `flush = bottom` then `anchor` will be
  the bottom of the obstacle. If `flush = horizon` then `anchor` will be the
  center of the obstacle.
- `horiz`: a horizontal version of `vert`.
- `width`: a horizontal version of `height`.

the inputs are guaranteed and the outputs are assumed to be normalized
to $[0, 1]$. Below are some examples.

#import "@preview/cetz:0.4.1"

#table(columns: (2fr, 1fr), stroke: none)[
][
  #context box(width: 5.6cm, height: 5.6cm, stroke: black, inset: 3mm)[
    #set text(size: 4pt)
    #set par(justify: true)
    #meander.reflow[
      #meander.redraw(
        debug: true,
        div: 7,
        horiz: y => (1 - y, 1),
        place(right + bottom)[#cetz.canvas({
          import cetz.draw: *
          merge-path(fill: yellow, {
            line((0, 0), (3, 0))
            line((), (3, 2))
            line((), (0, 0))
          })
        })]
      )
      #meander.container()
      #lorem(500)
    ]
  ]
][
][
  #context box(width: 5.6cm, height: 5.6cm, stroke: black, inset: 3mm)[
    #set text(size: 4pt)
    #set par(justify: true)
    #meander.reflow[
      #meander.redraw(
        debug: true,
        div: 12,
        flush: center,
        width: y => (0.5, y),
        place(center + bottom)[#cetz.canvas({
          import cetz.draw: *
          merge-path(fill: yellow, {
            line((0, 0), (3.4, 0))
            line((), (1.7, 4))
            line((), (0, 0))
          })
        })]
      )
      #meander.container()
      #lorem(500)
    ]
  ]
][
][
  #context box(width: 5.6cm, height: 5.6cm, stroke: black, inset: 3mm)[
    #set text(size: 4pt)
    #set par(justify: true)
    #meander.reflow[
      #meander.redraw(
        debug: true,
        div: 12,
        vert: x => (0.5 * x, 1 - 0.5 * x),
        place(left + horizon)[#cetz.canvas({
          import cetz.draw: *
          merge-path(fill: yellow, {
            line((0, 0), (0, 4))
            line((), (1, 2))
            line((), (0, 0))
          })
        })]
      )
      #meander.container()
      #lorem(500)
    ]
  ]
][
][
  #context box(width: 5.6cm, height: 5.6cm, stroke: black, inset: 3mm)[
    #set text(size: 4pt)
    #set par(justify: true)
    #meander.reflow[
      #meander.redraw(
        debug: true,
        div: 26,
        horiz: y => if y <= 0.5 { (0, 1 - 2 * y) } else { (0, 2 * (y - 0.5)) },
        place(left + horizon)[#cetz.canvas({
          import cetz.draw: *
          merge-path(fill: yellow, {
            line((0, 0), (0, 2.5))
            line((), (2, 2.5))
            line((), (0, 0))
            line((), (0, -2.5))
            line((), (2, -2.5))
            line((), (0, 0))
          })
        })]
      )
      #meander.container()
      #lorem(500)
    ]
  ]
]

There are of course limits to this technique, and in particular increasing the
number of obstacles will in turn increase the number of boxes that the layout
is segmented into. This means
- performance issues if you get too wild
  (though notice that having 15 obstacles in the previous example went completely
  fine, and I have test cases with up to \~100)
- text may not fit in the boxes, and the vertical stretching of boxes still
  needs improvements.
In the meantime it is highly discouraged to use a subdivision that results
in obstacles much smaller than the font height.

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

#parse-and-show("tiling.typ")[
  == Tiling (`tiling.typ`)
  Page splitting algorithm.
]

#parse-and-show("bisect.typ")[
  == Bisection (`bisect.typ`)
  Content splitting algorithm.
]

#parse-and-show("threading.typ")[
  == Threading (`threading.typ`)
  Filling and stretches boxes iteratively.
]

