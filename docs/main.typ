#align(center)[
  #text(size: 30pt)[*Meander*] \
  #text(size: 25pt)[User guide]
]

#let show-code(tag) = {
  let relevant-lines = ()
  let relevant = false
  let take = false
  let deindent = none
  let compress = none
  for line in read("/docs/main.typ").split("\n") {
    if line.contains("//@") and line.contains("<" + tag + ">") {
      if deindent != none { panic("tag <" + tag + "> occurs multiple times") }
      relevant = true
      take = true
      deindent = line.position("//@")
    } else if line.contains("//@") and line.contains("</" + tag + ">") {
      relevant = false
    } else if relevant {
      if line.contains("<...>") {
        take = false
      } else if line.contains("</...>") {
        take = true
        if line.contains("inline") {
          relevant-lines.last() += "..."
          compress = line.position("//@")
        } else {
          relevant-lines.push(" " * (line.position("//@") - deindent) + "// ...")
        }
      } else if take {
        if compress != none {
          relevant-lines.last() += line.slice(calc.min(compress, line.len()))
          compress = none
        } else {
          relevant-lines.push(line.slice(calc.min(deindent, line.len())))
        }
      }
    }
  }
  raw(lang: "typ", block: true, relevant-lines.join("\n"))
}

#show link: set text(fill: blue.darken(20%))

#import "../src/lib.typ" as meander

#let fakeimg(alignment, dx: 0pt, dy: 0pt, fill: white, width: 1cm, height: 1cm, label: none) = {
  meander.placed(
    alignment, dx: dx, dy: dy,
    boundary: meander.contour.margin(5pt),
  )[#box(fill: fill.transparentize(70%), width: width, height: height, radius: 2mm)[#align(center + horizon)[#label]]]
}

#let pseudopage(content) = {
  box(width: 7cm, height: 11cm, stroke: 1pt, inset: 5mm)[
    #set text(size: 5pt)
    #context { content }
  ]
}

#let my-img-1 = box(width: 2.5cm, height: 3cm, fill: orange.transparentize(70%), radius: 2mm)[#align(center + horizon)[#text(size: 14pt)[`1`]]]
#let my-img-2 = box(width: 2cm, height: 1cm, fill: blue.transparentize(70%), radius: 2mm)[#align(center + horizon)[#text(size: 14pt)[`2`]]]
#let my-img-3 = box(width: 4cm, height: 2cm, fill: green.transparentize(70%), radius: 2mm)[#align(center + horizon)[#text(size: 14pt)[`3`]]]
#let my-img-4 = box(width: 2cm, height: 2cm, fill: red.transparentize(70%), radius: 2mm)[#align(center + horizon)[#text(size: 14pt)[`4`]]]
#let my-img-5 = box(width: 1.5cm, height: 1cm, fill: yellow.transparentize(70%), radius: 2mm)[#align(center + horizon)[#text(size: 14pt)[`5`]]]

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
  - #link("https://github.com/Vanille-N/meander.typ/releases/tag/v0.2.0")[`0.2.0`]
    (#link("https://typst.app/universe/package/meander")[`latest`])
  - #link("https://github.com/Vanille-N/meander.typ/releases/tag/v0.1.0")[`0.1.0`]
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
      #meander.reflow({
        fakeimg(top + left, width: 1.5cm, height: 3cm, fill: green)
        fakeimg(bottom + left, width: 2cm, height: 2cm, fill: red)
        fakeimg(bottom + right, width: 1cm, height: 2cm, fill: blue)
        fakeimg(top + right, width: 2cm, height: 4cm, fill: orange)
        meander.container()
        meander.content[
          #set par(justify: true)
          #filler
        ]
      })
    ]
  ]
]

#align(bottom)[
  #line(length: 100%)
  #outline(depth: 1)
]
#set heading(numbering: (..nums) => {
  let nums = nums.pos()
  if nums.len() <= 2 {
    return numbering("I.a", ..nums)
  } else {
    return ""
  }
})

#pagebreak()

= Quick start

The main function provided is ```typ #meander.reflow```, which takes as input
a sequence of "containers", "obstacles", and "flowing content",
created respectively by the functions ```typ #container```, ```typ #placed```,
and ```typ #content```.
Obstacles are placed on the page with a fixed layout. After excluding the zones
occupied by obstacles, the containers are segmented into boxes then filled
by the flowing content.

== A simple example

#table(columns: (1fr, 1fr), stroke: none)[
  Below is a single page whose layout is fully determined by Meander.
  Currently multi-page setups are not supported,
  but this is definitely a desired feature.

  #show-code("simple-example")
][
  #pseudopage[
    //@ <simple-example>
    #meander.reflow({
      import meander: *
      // Obstacle in the top left
      placed(top + left, my-img-1)

      // Full-page container
      container()

      // Flowing content
      content[
        _#lorem(30)_
        #[
          #set par(justify: true)
          #lorem(200)
        ]
        #lorem(100)
      ]
    })
    //@ </simple-example>
  ]
]

Meander is expected to respect the majority of styling options,
including headings, paragraph justification, font size, etc.
Notable exceptions are detailed in @styling-layout.
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

  #show-code("multi-obstacles")
][
  #pseudopage[
    //@ <multi-obstacles>
    #meander.reflow({
      import meander: *
      // As many obstacles as you want
      placed(top + left, my-img-1)
      placed(top + right, my-img-2)
      placed(horizon + right, my-img-3)
      placed(bottom + left, my-img-4)
      placed(bottom + left, dx: 35%,
        my-img-5)

      // The container wraps around all
      container()
      content[
        #set par(justify: true)
        #lorem(600)
      ]
    })
    //@ </multi-obstacles>
  ]
]

== Columns

#table(columns: (55%, 40%), stroke: none)[
  In order to simulate a multi-column layout, you can provide several
  ```typ container``` invocations. They will be filled in the order provided.

  #show-code("two-columns")
][
  #pseudopage[
    //@ <two-columns>
    #meander.reflow({
      import meander: *
      placed(bottom + right, my-img-1)
      placed(center + horizon, my-img-2)
      placed(top + right, my-img-3)

      // With two containers we can
      // emulate two columns.
      container(width: 55%)
      container(align: right, width: 40%)
      content[#lorem(600)]
    })
    //@ </two-columns>
  ]
]

= Showcase

A selection of nontrivial examples of what is feasible.

#table(columns: (1fr, 1fr), stroke: gray, align: center + horizon)[
  #image("/examples/5181-a/main.svg", width: 7.5cm)
  #link("https://github.com/Vanille-N/meander.typ/tree/master/examples/5181-a/main.typ")[`examples/5181-a/main.typ`] \
  Inspired by #link("https://github.com/typst/typst/issues/5181#issue-2580297357")[`github:typst/typst` \#5181 (a)]
][
  #image("/examples/5181-b/main.svg", width: 7.5cm)
  #v(1.9cm)
  #link("https://github.com/Vanille-N/meander.typ/tree/master/examples/5181-b/main.typ")[`examples/5181-b/main.typ`] \
  Inspired by #link("https://github.com/typst/typst/issues/5181#issue-2580297357")[`github:typst/typst` \#5181 (b)]
]


#pagebreak()

= Understanding the algorithm

#table(columns: (1fr, 1fr), stroke: none)[
  The same page setup as the previous example will internally be separated into
  - obstacles `my-img-1`, `my-img-2`, and `my-img-3`.
  - containers ```typ #(x: 0%, y: 0%, width: 55%, height: 100%)```
    and ```typ #(x: 60%, y: 0%, width: 40%, height: 100%)```
  - flowing content ```typ #lorem(600)```.

  Initially obstacles are placed on the page #text(fill: purple)[($->$)].
  If they have a `boundary` parameter, it recomputes the exclusion zone.

  Then the containers are placed on the page and segmented into rectangles
  to avoid the exclusion zones #text(fill: purple)[($arrow.b$)].

  Finally the flowing content is threaded through those boxes
  #text(fill: purple)[($arrow.br$)], which may be resized vertically a bit compared
  to the initial segmentation.

  The debug views on this page are accessible via
  ```typ #meander.regions``` and ```typ #meander.reflow.with(debug: true)```
][
  #pseudopage[
    #meander.regions({
      import meander: *
      placed(bottom + right, my-img-1)
      placed(center + horizon, my-img-2)
      placed(top + right, my-img-3)
    })
  ]
][
  #pseudopage[
    #meander.regions({
      import meander: *
      placed(bottom + right, my-img-1)
      placed(center + horizon, my-img-2)
      placed(top + right, my-img-3)

      // With two containers we can
      // emulate two columns.
      container(width: 55%)
      container(align: right, width: 40%)
      content[#lorem(600)]
    })
  ]
][
  #pseudopage[
    #meander.reflow(debug: true, {
      import meander: *
      placed(bottom + right, my-img-1)
      placed(center + horizon, my-img-2)
      placed(top + right, my-img-3)

      // With two containers we can
      // emulate two columns.
      container(width: 55%)
      container(align: right, width: 40%)
      content[#lorem(600)]
    })
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
  #show-code("4-regions-1")
][
  #show-code("4-regions-2")
][
  #pseudopage[
    //@ <4-regions-1>
    #meander.regions({
      import meander: *
      placed(center + horizon,
        line(end: (100%, 0%)))
      placed(center + horizon,
        line(end: (0%, 100%)))

      container(width: 100%)


    })
    //@ </4-regions-1>
    #place(center + horizon, dx: -25%, dy: -25%)[#text(size: 50pt)[*1*]]
    #place(center + horizon, dx: 25%, dy: -25%)[#text(size: 50pt)[*2*]]
    #place(center + horizon, dx: -25%, dy: 25%)[#text(size: 50pt)[*3*]]
    #place(center + horizon, dx: 25%, dy: 25%)[#text(size: 50pt)[*4*]]
  ]
][
  #pseudopage[
    //@ <4-regions-2>
    #meander.regions({
      import meander: *
      placed(center + horizon,
        line(end: (100%, 0%)))
      placed(center + horizon,
        line(end: (0%, 100%)))

      container(width: 50%)
      container(align: right,
        width: 50%)
    })
    //@ </4-regions-2>
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
by providing functions to redraw the boundaries of an obstacle.
Here we walk through these steps.

Here is our starting point: a simple double-column page
with a cutout in the middle for an image.

#show-code("square-hole")
#table(columns: (1fr, 1fr), stroke: none)[
  #pseudopage[
    #meander.regions({
      import meander: *
      placed(center + horizon)[#circle(radius: 1.5cm, fill: yellow)]

      container(width: 48%)
      container(align: right, width: 48%)

      content[
        #set par(justify: true)
        #lorem(600)
      ]
    })
  ]
][
  #pseudopage[
    //@ <square-hole>
    #meander.reflow({
      import meander: *
      placed(center + horizon)[#circle(radius: 1.5cm, fill: yellow)]

      container(width: 48%)
      container(align: right, width: 48%)

      content[
        #set par(justify: true)
        #lorem(600)
      ]
    })
    //@ </square-hole>
  ]
]
Meander sees all obstacles as rectangular, so the circle leaves a big
ugly #link("https://www.youtube.com/watch?v=6pDH66X3ClA")[square hole] in our page.

Fear not! We can redraw the boundaries.
```typ #meander.placed``` accepts as parameter `boundary` a sequence of
box transformers to change the way the object affects the layout.
These transformations are normalized to the interval $[0, 1]$ for convenience.
The default `boundary` value is ```typ #contour.margin(5pt)```.

```typ #meander.contour.grid``` is one such redrawing function,
from $[0, 1] times [0, 1]$ to `bool`, returning for each normalized
coordinate `(x, y)` whether it belongs to the obstacle.

So instead of placing directly the circle, we write:
#show-code("circle-hole")
This results in the new subdivisions of containers below.
#table(columns: (1fr, 1fr), stroke: none)[
  #pseudopage[
    #meander.regions({
      import meander: *
      placed(center + horizon,
        boundary: contour.margin(4pt) + contour.grid(div: 25, (x, y) => {
          calc.pow(2 * x - 1, 2) + calc.pow(2 * y - 1, 2) <= 1
        })
      )[#circle(radius: 1.5cm, fill: yellow)]

      container(width: 48%)
      container(align: right, width: 48%)

      content[
        #set par(justify: true)
        #lorem(600)
      ]
    })
  ]
][
  #pseudopage[
    //@ <circle-hole>
    #meander.reflow({
      import meander: *
      placed(
        center + horizon,
        boundary:
          // Override the default margin
          contour.margin(4pt) +
          // Then redraw the shape as a grid
          contour.grid(
            // 25 vertical and horizontal subdivisions (choose whatever looks good)
            div: 25,
            // Equation for a circle of center (0.5, 0.5) and radius 0.5
            (x, y) => calc.pow(2 * x - 1, 2) + calc.pow(2 * y - 1, 2) <= 1
          ),
        // Underlying object
        circle(radius: 1.5cm, fill: yellow),
      )
      //@ <...>
      container(width: 48%)
      container(align: right, width: 48%)

      content[
        #set par(justify: true)
        #lorem(600)
      ]
      //@ </...>
    })
    //@ </circle-hole>
  ]
]
This enables in theory drawing arbitrary paragraph shapes.
If your shape is not convenient to express through a grid function, here
are the other options available:
- `vert(div: _, fun)`: subdivide vertically in `div` sections,
  then `fun(x) = (top, bottom)` produces an obstacle between `top` and `bottom`.
- `height(div: _, flush: _, fun)`: subdivide vertically in `div` sections,
  then `fun(x) = (anchor, height)` produces an obstacle of height `height`,
  with the interpretation of `anchor` depending on the value of `flush`:
  - if `flush = top` then `anchor` will be the top of the obstacle;
  - if `flush = bottom` then `anchor` will be the bottom of the obstacle;
  - if `flush = horizon` then `anchor` will be the center of the obstacle.
- `horiz`: a horizontal version of `vert`.
- `width`: a horizontal version of `height`.

Reminder: all of these functions operate on values normalized to $[0, 1]$.
See some examples below.

#import "@preview/cetz:0.4.1"

// TODO: enable showing some obstacle boxes

#table(columns: (1fr, 1fr), stroke: none)[
  #box(width: 5.6cm, height: 5cm, stroke: black, inset: 3mm)[
    #set text(size: 5pt)
    #set par(justify: true)
    //@ <contour-1>
    #meander.reflow({
      import meander: *
      placed(right + bottom,
        boundary:
          // The right aligned edge makes
          // this easy to specify using
          // `horiz`
          contour.horiz(
            div: 20,
            // (left, right)
            y => (1 - y, 1),
          ) +
          // Add a post-segmentation margin
          contour.margin(5pt)
      )[
      //@ <...>
        #cetz.canvas({
          import cetz.draw: *
          merge-path(fill: yellow, {
            line((0, 0), (3, 0))
            line((), (3, 2))
            line((), (0, 0))
          })
        })
      //@ </...> inline
      ]
      //@ <...>
      container()
      content[#lorem(500)]
      //@ </...>
    })
    //@ </contour-1>
  ]
  #show-code("contour-1")
][
  #box(width: 5.6cm, height: 5cm, stroke: black, inset: 3mm)[
    #set text(size: 5pt)
    #set par(justify: true)
    //@ <contour-2>
    #meander.reflow({
      import meander: *
      placed(center + bottom,
        boundary:
          // This time the vertical symetry
          // makes `width` a good match.
          contour.width(
            div: 20,
            flush: center,
            // Centered in 0.5, of width y
            y => (0.5, y),
          ) +
          contour.margin(5pt)
      )[
      //@ <...>
        #cetz.canvas({
          import cetz.draw: *
          merge-path(fill: yellow, {
            line((0, 0), (3.4, 0))
            line((), (1.7, 3))
            line((), (0, 0))
          })
        })
      //@ </...> inline
      ]
      //@ <...>
      container()
      content[#lorem(500)]
      //@ </...>
    })
    //@ </contour-2>
  ]
  #show-code("contour-2")
]

#table(columns: (1fr, 1fr), stroke: none)[
  #box(width: 5.6cm, height: 5cm, stroke: black, inset: 3mm)[
    #set text(size: 5pt)
    #set par(justify: true)
    //@ <contour-3>
    #meander.reflow({
      import meander: *
      placed(left + horizon,
        boundary:
          contour.height(
            div: 20,
            flush: horizon,
            x => (0.5, 1 - x),
          ) +
          contour.margin(5pt)
      )[
      //@ <...>
        #cetz.canvas({
          import cetz.draw: *
          merge-path(fill: yellow, {
            line((0, 0), (0, 4))
            line((), (1, 2))
            line((), (0, 0))
          })
        })
      //@ </...> inline
      ]
      //@ <...>
      container()
      content[#lorem(500)]
      //@ </...>
    })
    //@ </contour-3>
  ]
  #show-code("contour-3")
][
  #box(width: 5.6cm, height: 5cm, stroke: black, inset: 3mm)[
    #set text(size: 5pt)
    #set par(justify: true)
    //@ <contour-4>
    #meander.reflow({
      import meander: *
      placed(left + horizon,
        boundary:
          contour.horiz(
            div: 25,
            y => if y <= 0.5 {
              (0, 2 * (0.5 - y))
            } else {
              (0, 2 * (y - 0.5))
            },
          ) +
          contour.margin(3pt)
      )[
      //@ <...>
        #cetz.canvas({
          import cetz.draw: *
          merge-path(fill: yellow, {
            line((0, 0), (0, 2.2))
            line((), (2, 2.2))
            line((), (0, 0))
            line((), (0, -2.2))
            line((), (2, -2.2))
            line((), (0, 0))
          })
        })
      //@ </...> inline
      ]
      //@ <...>
      container()
      content[#lorem(500)]
      //@ </...>
    })
    //@ </contour-4>
  ]
  #show-code("contour-4")
]

The contouring functions available should already cover a reasonable range
of use-cases, but if you have other ideas you could always try to submit one
as a new #link("https://github.com/Vanille-N/meander.typ/issues")[issue].

There are of course limits to this technique, and in particular increasing the
number of obstacles will in turn increase the number of boxes that the layout
is segmented into. This means
- performance issues if you get too wild
  (though notice that having 20+ obstacles in the previous examples went completely
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

#pagebreak()

= Style-sensitive layout <styling-layout>

Meander respects most styling options through a dedicated content segmentation
algorithm. Bold, italic, underlined, stroked, highlighted, colored, etc. text
is preserved through threading, and easily so because those styling options do
not affect layout much.

There are however styling parameters that have a consequence on layout,
and some of them require special handling.
Some of these restrictions may be relaxed or entirely lifted by future updates.

== Paragraph justification

In order to properly justify text across boxes, Meander needs to have contextual
access to ```typ #par.justify```, which is only updated via a ```typ #set``` rule.

As such *do not* use ```typ #par(justify: true)[...]```.

Instead prefer ```typ #[#set par(justify: true); ...]```, or put the ```typ #set```
rule outside of the invocation of ```typ #meander.reflow``` altogether.

#table(columns: (1fr, 1fr), stroke: none, align: center)[
  #text(fill: red, size: 20pt)[*Wrong*]
  #show-code("par-justify")
  #pseudopage[
    #set text(hyphenate: false)
    //@ <par-justify>
    #meander.reflow({
      //@ <...>
      import meander: *
      for i in range(100) {
        container(dy: i * 1%, height: 2%)
      }
      //@ </...>
      content[
        #par(justify: true)[
          #lorem(600)
        ]
      ]
    })
    //@ </par-justify>
  ]
][
  #text(fill: green, size: 20pt)[*Correct*]
  #show-code("set-par-justify")
  #pseudopage[
    #set text(hyphenate: false)
    //@ <set-par-justify>
    #meander.reflow({
      //@ <...>
      import meander: *
      for i in range(100) {
        container(dy: i * 1%, height: 2%)
      }
      //@ </...>
      content[
        #set par(justify: true)
        #lorem(600)
      ]

    })
    //@ </set-par-justify>
  ]
]

== Font size

The font size indirectly affects layout because it determines the spacing between
lines. When a linebreak occurs between containers, Meander needs to manually
insert the appropriate spacing there. Since the spacing is affected by font size,
make sure to update the font size outside of the ```typ #meander.reflow```
invocation if you want the correct line spacing.

As such, it is currently discouraged to do large changes of font size in highly
segmented regions from within the invocation. A future update will provide a 
way to do this in a more well-behaved manner.

#table(columns: (1fr, 1fr), stroke: none, align: center)[
  #text(fill: red, size: 20pt)[*Wrong*]
  #show-code("font-size-inside")
  #pseudopage[
    //@ <font-size-inside>
    #meander.reflow({
      //@ <...>
      import meander: *
      container()
      placed(
        left,
        boundary: contour.horiz(div: 100, _ => (0, 1)),
        line(end: (0%, 100%), stroke: white)
      )
      //@ </...>
      content[
        #set text(size: 15pt)
        #lorem(600)
      ]
    })
    //@ </font-size-inside>
  ]
][
  #text(fill: green, size: 20pt)[*Correct*]
  #show-code("font-size-outside")
  #pseudopage[
    //@ <font-size-outside>
    #set text(size: 15pt)
    #meander.reflow({
      //@ <...>
      import meander: *
      container()
      placed(
        left,
        boundary: contour.horiz(div: 100, _ => (0, 1)),
        line(end: (0%, 100%), stroke: white)
      )
      //@ </...>
      content[
        #lorem(600)
      ]
    })
    //@ </font-size-outside>
  ]
]

#pagebreak()

== Hyphenation and language

The language is not yet configurable. This feature will come soon.

Hyphenation can only be fetched contextually, and highly influences how text
is split between boxes.
Thus hyphenation can currently only be enabled or disabled outside of the
```typ #meander.reflow``` invocation. A future update will provide a means
to change it more locally.

#table(columns: (1fr, 1fr), stroke: none, align: center)[
  #text(fill: red, size: 20pt)[*Wrong*]
  #show-code("text-hyphenate-inside")
  #pseudopage[
    #set par(justify: true)
    #set text(hyphenate: false)
    //@ <text-hyphenate-inside>
    #meander.reflow({
      //@ <...>
      import meander: *
      for i in range(100) {
        container(dy: i * 1%, height: 2%)
      }
      //@ </...>
      content[
        #set text(hyphenate: true)
        #lorem(600)
      ]
    })
    //@ </text-hyphenate-inside>
  ]
][
  #text(fill: green, size: 20pt)[*Correct*]
  #show-code("text-hyphenate-outside")
  #pseudopage[
    #set par(justify: true)
    #set text(hyphenate: false)
    //@ <text-hyphenate-outside>
    #set text(hyphenate: true)
    #meander.reflow({
      //@ <...>
      import meander: *
      for i in range(100) {
        container(dy: i * 1%, height: 2%)
      }
      //@ </...>
      content[
        #lorem(600)
      ]
    })
    //@ </text-hyphenate-outside>
  ]
]

#pagebreak()

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

#parse-and-show("contour.typ")[
  == Contouring (`contour.typ`)
  Image boundary transformers.
]

#parse-and-show("bisect.typ")[
  == Bisection (`bisect.typ`)
  Content splitting algorithm.
]

#parse-and-show("threading.typ")[
  == Threading (`threading.typ`)
  Filling and stretches boxes iteratively.
]

