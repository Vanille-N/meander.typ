#align(center)[
  #text(size: 30pt)[*Meander*] \
  #text(size: 25pt)[User guide]
]

#let TODO = box(fill: red, stroke: black + 5pt, inset: 5mm)[
  #text(size: 20pt)[TODO]
]

#let show-page(tag, width: auto) = {
  box(stroke: black)[
    #image("figs/" + tag + ".svg", width: width)
  ]
}

#let repo = "https://github.com/Vanille-N/meander.typ/"
#let typst-repo = "https://github.com/typst/typst/"

#let show-code(tag) = {
  let relevant-lines = ()
  let take = false
  let compress = none
  for line in read("figs/" + tag + ".typ").split("\n") {
    if line.contains("<doc>") {
      take = true
    } else if line.contains("</doc>") {
      take = false
    } else if line.contains("<...>") {
      take = false
    } else if line.contains("</...>") {
      take = true
      if line.contains("inline") {
        relevant-lines.last() += "..."
        compress = line.position("//@")
      } else {
        relevant-lines.push(" " * line.position("//@") + "// ...")
      }
    } else if take {
      if compress != none {
        relevant-lines.last() += line.slice(calc.min(compress, line.len()))
        compress = none
      } else {
        relevant-lines.push(line)
      }
    }
  }
  raw(lang: "typ", block: true, relevant-lines.join("\n"))
}

#show link: set text(fill: blue.darken(20%))

#import "../src/lib.typ" as meander

#v(2cm)

#table(columns: (auto, auto), stroke: none)[
  *Abstract* \
  Meander implements a content layout algorithm to provide text threading
  (when text from one box spills into a different box if it overflows),
  uneven columns, and image wrap-around.

  *Feature requests* \
  For as long as the feature doesn't exist natively in Typst
  (see issue: #link(typst-repo + "issues/5181")[`github:typst/typst #5181`]),
  feel free to submit test cases of layouts you would like to see supported
  by opening a new #link(repo + "issues")[issue].

  *Versions* \
  - #link(repo)[`dev`]
  - #link(repo + "releases/tag/v0.2.1")[`0.2.1`]
    (#link("https://typst.app/universe/package/meander")[`latest`])
  - #link(repo + "releases/tag/v0.2.0")[`0.2.0`]
  - #link(repo + "releases/tag/v0.1.0")[`0.1.0`]
][
  #align(center)[
    #show-page("cover")
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
  Multi-page setups are also possible, see @multi-page.

  #show-code("simple-example")
][
  #show-page("simple-example", width: 7cm)
]

Meander is expected to respect the majority of styling options,
including headings, paragraph justification, font size, etc.
Notable exceptions are detailed in @styling-layout.
If you find a discrepancy make sure to file it as a
#link(repo + "issues")[bug report]
if it is not already part of the
#link(repo + "tree/master/ROADMAP.md")[known limitations].

Note: paragraph breaks may behave incorrectly. You can insert vertical spaces if needed.

== Multiple obstacles

#table(columns: (1fr, 1fr), stroke: none)[
  ```typ #meander.reflow``` can handle as many obstacles as you provide
  (at the cost of potentially performance issues if there are too many,
  but experiments have shown that up to \~100 obstacles is no problem).

  #show-code("multi-obstacles")
][
  #show-page("multi-obstacles")
]

== Columns <two-columns>

#table(columns: (55%, 40%), stroke: none)[
  In order to simulate a multi-column layout, you can provide several
  ```typ container``` invocations. They will be filled in the order provided.

  #show-code("two-columns")
][
  #show-page("two-columns")
]

#pagebreak()

= Showcase

A selection of nontrivial examples of what is feasible.

#table(columns: (1fr, 1fr), stroke: gray, align: center + horizon,
  [
    #image("/examples/5181-a/main.svg", width: 7.5cm)
    #link(repo + "tree/master/examples/5181-a/main.typ")[`examples/5181-a/main.typ`] \
    Motivated by #link(typst-repo + "issues/5181#issue-2580297357")[`github:typst/typst` \#5181 (a)]
  ],
  [
    #image("/examples/5181-b/main.svg", width: 7.5cm)
    #v(1.9cm)
    #link(repo + "tree/master/examples/5181-b/main.typ")[`examples/5181-b/main.typ`] \
    Motivated by #link(typst-repo + "issues/5181#issue-2580297357")[`github:typst/typst` \#5181 (b)]
  ],
  [
    #image("/examples/talmudifier/main.svg", width: 7.5cm)
    #link(repo + "tree/master/examples/talmudifier/main.typ")[`examples/talmudifier/main.typ`] \
    From #link("https://github.com/subalterngames/talmudifier")[`github:subalterngames/talmudifier`] \
    Motivated by #link(typst-repo + "issues/5181#issuecomment-2661180292")[`github:typst/typst` \#5181 (c)]
  ],
)

#pagebreak()

= Understanding the algorithm

#table(columns: (1fr, 1fr), stroke: none)[
  The same page setup as the previous @two-columns[example]
  will internally be separated into
  - obstacles `my-img-1`, `my-img-2`, and `my-img-3`.
  - containers ```typ #(x: 0%, y: 0%, width: 55%, height: 100%)```
    and ```typ #(x: 60%, y: 0%, width: 40%, height: 100%)```
  - flowing content ```typ #lorem(470)```.

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
  #show-page("debug-regions-obstacles")
][
  #show-page("debug-regions-full")
][
  #show-page("debug-reflow")
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
  #show-page("4-regions-1", width: 6cm)
][
  #show-page("4-regions-2", width: 6cm)
]
And even in the example above, the box *1* will be filled before the first
line of *2* is used.
In short, Meander *does not "guess" columns*. If you want columns rather than
a top-bottom and left-right layout, you need to specify them.

#pagebreak()

= Advanced techniques

== Obstacle contouring

Although Meander started as only a text threading engine,
the ability to place text in boxes of unequal width has direct applications
in more advanced paragraph shapes. This has been a desired feature since at
least #link(typst-repo + "issues/5181")[issue \#5181].

Even though this is somewhat outside of the original feature roadmap,
Meander makes an effort for this application to be more user-friendly,
by providing functions to redraw the boundaries of an obstacle.
Here we walk through these steps.

Basic contouring is simply the ability to customize the margin around obstacles
by passing to ```typ #placed``` the argument `boundary: contour.margin(1cm)`.
```typ #contour.margin``` also accepts parameters `x`, `y`, `top`, `bottom`,
`left`, `right`, with the precedence you would expect, to customize the margins
precisely.

=== As equations

Here is our starting point: a simple double-column page
with a cutout in the middle for an image.

#show-code("square-hole")
#table(columns: (1fr, 1fr), stroke: none)[
  #show-page("square-hole-debug", width: 6cm)
][
  #show-page("square-hole", width: 6cm)
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
  #show-page("circle-hole-debug", width: 6cm) 
][
  #show-page("circle-hole", width: 6cm)
]
This enables in theory drawing arbitrary paragraph shapes.
Note the high density of obstacles on the debug view above:
this works here but we are getting close to the resolution limit of meander,
so don't try to draw obstacles with a resolution too much lower than the normal
line height.

=== As stacked rectangles

If your shape is not convenient to express through a grid function, but
has some horizontal or vertical regularity, here are some other suggestions:

#table(columns: (1fr, 1fr), stroke: none, inset: (y: 2mm), align: center,
  table.hline(stroke: gray),
  show-page("contour-1", width: 5cm),
  show-code("contour-1"),
  table.hline(stroke: gray),
  show-code("contour-2"),
  show-page("contour-2", width: 5cm),
  table.hline(stroke: gray),
  show-page("contour-3", width: 5cm),
  show-code("contour-3"),
  table.hline(stroke: gray),
  show-code("contour-4"),
  show-page("contour-4", width: 5cm),
  table.hline(stroke: gray),
)

To summarize,
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

All of these functions operate on values normalized to $[0, 1]$.

#pagebreak()

=== As ASCII art

Another method of specifying contours is by drawing a rough shape of the obstacle
in ASCII art. Pass a code block made of the characters ```# /\[]^_,.'`JFL7```
to the contouring function ```typ #contour.ascii-art```, and you can easily draw the
shape of your image.

#table(columns: (1fr, 1fr), stroke: none)[
  #show-code("ascii-sheet")
][
  #show-page("ascii-sheet")
]
See #link(repo + "tree/master/examples/5181-b/main.typ")[`examples/5181-b/main.typ`] for a nontrivial use-case.

=== Remarks

The contouring functions available should already cover a reasonable range
of use-cases, but if you have other ideas you could always try to submit one
as a new #link(repo + "issues")[issue].

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

#pagebreak()

== Multi-page setups <multi-page>

Meander can deal with text that spans multiple pages,
you just need to place ```typ #pagebreak```s appropriately.
Note that ```typ #pagebreak``` only affects the obstacles and containers,
while ```typ #content``` blocks ignore them entirely.

#show-code("two-pages/doc")
#table(columns: (1fr, 1fr), stroke: none)[
  #show-page("two-pages/doc.1", width: 6cm)
][
  #show-page("two-pages/doc.2", width: 6cm)
]

#pagebreak()

If you run into performance issues, consider finding spots where you can break
the ```typ #reflow``` invocation. As long as you don't insert a ```typ #pagebreak```
explicitly, several ```typ #reflow```s can coexist on the same page.

#table(columns: (70%, 35%), stroke: none,
  show-code("junction/doc"),
  [
    #show-page("junction/doc.1", width: 5cm)
    #show-page("junction/doc.2", width: 5cm)
  ],
)

*Note:* the default behavior if the content provided overflows the available
containers is *not* to put in on the next page, but rather to show a warning.
You can manually enable the overflow going to the next page by passing
to ```typ #reflow``` the parameter `overflow: pagebreak`.
Other options include `overflow: panic` if you want accidental overflows to
trigger an immediate panic.

#pagebreak()

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
  #show-page("par-justify", width: 5cm)
][
  #text(fill: green, size: 20pt)[*Correct*]
  #show-code("set-par-justify")
  #show-page("set-par-justify", width: 5cm)
]

#pagebreak()

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
  #show-page("font-size-inside", width: 5cm)
][
  #text(fill: green, size: 20pt)[*Correct*]
  #show-code("font-size-outside")
  #show-page("font-size-outside", width: 5cm)
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
  #show-page("text-hyphenate-inside", width: 5cm)
][
  #text(fill: green, size: 20pt)[*Correct*]
  #show-code("text-hyphenate-outside")
  #show-page("text-hyphenate-outside", width: 5cm)
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

