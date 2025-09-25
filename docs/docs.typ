#import "@preview/mantys:1.0.2": *
#import "@preview/swank-tex:0.1.0": LaTeX
#import "@preview/tidy:0.4.3"


#let repo = "https://github.com/Vanille-N/meander.typ/"
#let typst-repo = "https://github.com/typst/typst/"

#let show-page(tag, width: auto) = {
  box(stroke: black)[
    #image("figs/" + tag + ".svg", width: width)
  ]
}

#let show-code(tag, resize: 0pt) = context {
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
  set text(size: text.size + resize)
  codesnippet(
    raw(lang: "typ", block: true, relevant-lines.join("\n"))
  )
}

#let show-module(name, module: false, scope: (:), outlined: true) = {
  let path = "../src/" + name + ".typ"
  import path as mod
  tidy-module(
    name,
    module: if module { name } else { none },
    read(path),
    scope: scope,
  )
}

#let twocols(frac: 50%, l, r) = {
  table(columns: (frac, 100% - frac), stroke: none, l, r)
}

#show: mantys(
  ..toml("../typst.toml"),
  show-urls-in-footnotes: false,
  /*
  name: "mantys",
  version: "1.0.0",
  authors: (
    "Jonas Neugebauer",
  ),
  license: "MIT",
  description: "Helpers to build manuals for Typst packages.",
  repository: "https://github.com/jneug/typst-mantys",
  */

  /// Uncomment one of the following lines to load the above
  /// package information directly from the typst.toml file
  // ..toml("../typst.toml"),
  // ..toml("typst.toml"),

  title: "MEANDER",
  subtitle: "User guide",
  date: datetime.today(),
  show-index: false,

  abstract: [
    MEANDER implements a content layout algorithm that supports wrapping text around images of arbitrary shape.
    Though very different in its modeling, MEANDER can be seen as a Typst alternative to #LaTeX's `wrapfig` and `parshape`.

    Internally this is enabled by
    1. a page segmentation algorithm that detects floating content and arranges containers around them,
    // TODO: content in color
    2. a text bisection algorithm to recursively explore and split `content`,
    3. a threading algorithm (threading is when text that overflows from one box continues to a different box).

    #box[
      #twocols[
        *Contributions* \
        If you have ideas or complaints, you're welcome
        to contribute to MEANDER by submitting a
        #link(repo + "issues")[bug report],
        #link(repo + "issues")[feature request],
        or #link(repo)[pull request].

        *Versions*
        - #link(repo)[`dev`]
        - #link(repo + "releases/tag/v0.2.2")[`0.2.2`]
          (#link("https://typst.app/universe/package/meander")[`latest`])
        - #link(repo + "releases/tag/v0.2.1")[`0.2.1`]
        - #link(repo + "releases/tag/v0.2.0")[`0.2.0`]
        - #link(repo + "releases/tag/v0.1.0")[`0.1.0`]
      ][
        #show-page("cover")
      ]
    ]
  ],

  // examples-scope: (
  //   scope: (:),
  //   imports: (:)
  // )

  // theme: themes.modern
)

= Quick start

The main function provided by MEANDER is ```typ #meander.reflow```,
which takes as input
a sequence of "containers", "obstacles", and "flowing content",
created respectively by the functions ```typc container(..)```, ```typc placed(..)```,
and ```typc content(..)```.
Obstacles are placed on the page with a fixed layout. After excluding the zones
occupied by obstacles, the containers are segmented into boxes then filled
by the flowing content.

More details about MEANDER's model are given in
@explain-algo.

== A simple example

Below is a single page whose layout is fully determined by MEANDER. The general pattern of ```typc placed(..)``` + ```typc container(..)``` + ```typc content(..)``` is
almost universal.

Within a ```typ #meander.reflow``` block, use ```typc placed(..)```
(same parameters as the standard function ```typc place(..)```)
to position obstacles made of arbitrary content on the page,
specify areas where text is allowed with ```typc container(..)```,
then give the actual content to be written there using ```typc content(..)```.

#twocols(frac: 51.5%)[
  #show-code("simple-example", resize: -1pt)
][
  #show-page("simple-example")
]

#info-alert[
  MEANDER is expected to automatically respect the majority of styling options,
  including headings, paragraph justification, bold and italics, etc.
  Notable exceptions that must be specified manually are detailed in @styling-layout.
]

#warning-alert[
  If you find a style discrepancy, make sure to file it as a
  #link(repo + "issues")[bug report],
  if it is not already part of the
  #link(repo + "tree/master/ROADMAP.md")[known limitations].
]

== Multiple obstacles

A single ```typ #meander.reflow``` invocation can contain multiple ```typc placed(..)``` objects.
A possible limitation would be performance if the number of obstacles grows too large, but experiments have shown that up to \~100 obstacles is still workable.

#info-alert[
  In fact, this ability to handle arbitrarily many obstacles
  is what I consider MEANDER's main innovation compared to
  #universe("wrap-it"), which also provides text wrapping
  but around at most two obstacles.
]

#twocols(frac: 56.2%)[
  #show-code("multi-obstacles", resize: -1pt)
][
  #show-page("multi-obstacles")
]

#info-alert[
  Technically, MEANDER can only handle rectangular obstacles.
  However, thanks to this ability to handle an arbitrary number of obstacles, we can approximate a non-rectangular obstacle using sereval rectangles.
  See concrete applications and techniques for defining
  these rectangular tilings in
  @contouring.
]

== Columns <two-columns>

Similarly, MEANDER can also handle multiple occurrences of ```typc container(..)```.
They will be filled in the order provided, leaving a (configurable) margin between one and the next.
Among other things, this can allow producing a layout in columns, including columns of uneven width
(a longstanding #link(typst-repo + "issues/1460")[typst issue]).

#twocols(frac: 54%)[
  #show-code("two-columns", resize: -1pt)
][
  #show-page("two-columns")
]

= Understanding the algorithm <explain-algo>

Although it can produce the same results as `parshape` in practice,
MEANDER's model is fundamentally different.
In order to better understand the limitations of what is feasible,
know how to tweak an imperfect layout, and anticipate issues that may occur,
it helps to have a basic understanding of MEANDER's algorithm(s).

Even if you don't plan to contribute to the implementation of MEANDER,
I suggest you nevertheless briefly read this section to have an intuition
of what happens behind the scenes.

== Page tiling

When you write some layout such as the one below,
MEANDER receives a sequence of elements that it splits into obstacles,
containers, and content.
#show-code("debug-reflow-code", resize: -1pt)
First the ```typc measure(..)``` of each obstacle is computed, their positioning
is inferred from the alignment parameter of ```typc placed(..)```, and they are
placed on the page. The regions they cover as marked as forbidden.

Then the same job is done for the containers, marking those regions as allowed.
The two sets of computed regions are combined by subtracting the forbidden regions
from the allowed ones, giving a rectangular subdivision of the usable areas.

You can have a visual representation of these regions by replacing
```typ #meander.reflow``` with ```typ #meander.regions```, with the same inputs.

#figure(
  [
    #show-page("debug-regions-obstacles", width: 4.5cm)
    #show-page("debug-regions-containers", width: 4.5cm)
    #show-page("debug-regions-full", width: 4.5cm)
  ],
  caption: [Left to right: the forbidden, allowed, and combined regions],
)

== Content bisection

The second building block of MEANDER is its algorithm to split content.
The regions computed by the tiling algorithm must be filled in order,
and text from one box might overflow to another.
The content bisection rules are all MEANDER's heuristics to split text and
take as much as fits in a box.

For example, consider the content ```typc bold(lorem(20))```
which does not fit in the container ```typc box(width: 5cm, height: 5cm)```:

#align(center)[
  #box(width: 5cm, height: 1.5cm, stroke: (paint: red, dash: "dashed"))[
    #align(left)[#strong(lorem(20))]
  ]
]
#v(2cm)

MEANDER will determine that
1. the content fits in the box until "eius-", and everything afterwards is overflow,
2. splitting `strong` text is equivalent to applying ```typc strong(..)``` to both
   halves,
3. therefore the content can be separated into
  - on the one hand, the text that fits ```typc strong("Lorem ... eius-")```
  - on the other hand, the overflow ```typc strong("mod ... quaerat.")```

If you find weird style artifacts near container boundaries, it is probably
a case of faulty bisection heuristics, and deserves to be #link(repo + "issues")[reported].

== Threading

The threading process interactively invokes both the tiling and the bisection algorithms,
establishing the following dialogue:
1. the tiling algorithm yields an available container
+ the bisection algorithm finds the maximum text that fits inside
+ the now full container becomes an obstacle and the tiling is updated
+ start over from step 1.

#info-alert[
  The order in which the boxes are filled always follows the priority of
  - container order,
  - top $->$ bottom,
  - left $->$ right.
  In other words, MEANDER will not guess columns, you must always
  specify columns explicitly.
]

The exact boundaries of containers may be altered in the process for better spacing.

#figure(
  show-page("debug-reflow", width: 4.5cm),
  caption: [Debug view of the final output of ```typ #meander.reflow```],
)

#info-alert[
  Every piece of content produced by ```typ #meander.reflow``` is placed,
  and therefore does not affect layout outside of ```typ #meander.reflow```.
  See @placement for solutions.
]

= Contouring <contouring>

I made earlier two seemingly contradictory claims:
1. MEANDER supports wrapping around images of arbitrary shape,
2. MEANDER only supports rectangular obstacles.

This is not a mistake. The reality is that these statements are only incompatible
if we assume that 1 image = 1 obstacle. We call "contouring functions" the utilities
that allow splitting one image into multiple obstacles to approximate an arbitrary shape.

All contouring utilities live in the `contour` module.

== Margins

The simplest form of contouring is adjusting the margins.
The default is a uniform ```typc 5pt``` gap, but you can adjust it for each
obstacle and each direction.

#twocols(frac: 39.5%)[
  #show-code("margins", resize: -2pt)
][
  #show-page("margins")
]

== Boundaries as equations

For more complex shapes, one method offered is to describe as equations
the desired shape.
Consider the following starting point: a simple double-column page
with a cutout in the middle for an image.

#show-code("square-hole")
#twocols[
  #show-page("square-hole-debug", width: 5cm)
][
  #show-page("square-hole", width: 5cm)
]
MEANDER sees all obstacles as rectangular, so the circle leaves a big
ugly #link("https://www.youtube.com/watch?v=6pDH66X3ClA")[square hole] in the page.
Fortunately the desired circular shape is easy to describe in equations,
and we can do so using the function ```typc contour.grid(..)```,
which takes as input a 2D formula normalized to $[0,1]$,
i.e. a function from $[0,1] times [0,1]$ to ```typc bool```. // TODO: bool type

#show-code("circle-hole")
This results in the new subdivisions of containers below.
#twocols[
  #show-page("circle-hole-debug", width: 5cm)
][
  #show-page("circle-hole", width: 5cm)
]
This enables in theory drawing arbitrary paragraph shapes.
In practice not all shapes are convenient to express in this way,
so the next sections propose other methods.

#info-alert[
  Watch out for the density of obstacles.
  Too many obstacles too close together can impact performance.
]

== Boundaries as layers

If your shape is not convenient to express through a grid function, but
has some horizontal or vertical regularity, here are some other suggestions.
As before, they are all normalized between $0$ and $1$.

=== Horizontal rectangles

```typc contour.horiz(..)``` and ```typc contour.width(..)```
produce horizontal layers of varying width.
```typc contour.horiz(..)``` works on a `(left, right)` basis
(the parameterizing function should return the two extremities of the obstacle),
while ```typc contour.width(..)``` works on an `(anchor, width)` basis.

#twocols(frac: 40%,
  show-page("contour-1"),
  show-code("contour-1"),
)

The interpretation of `flush` for ```typc contour.width(..)``` is as follows:
- if `flush = left`, the `anchor` point will be the left of the obstacle;
- if `flush = center`, the `anchor` point will be the middle of the obstacle;
- if `flush = right`, the `anchor` point will be the right of the obstacle.
#twocols(frac: 60%,
  show-code("contour-2"),
  show-page("contour-2"),
)

=== Vertical rectangles

```typc contour.vert(..)``` and ```typc contour.height(..)```
produce vertical layers of varying height.

#twocols(frac: 40%,
  show-page("contour-4"),
  show-code("contour-4"),
)

The interpretation of `flush` for ```typc contour.height(..)``` is as follows:
- if `flush = top`, the `anchor` point will be the top of the obstacle;
- if `flush = horizon`, the `anchor` point will be the middle of the obstacle;
- if `flush = bottom`, the `anchor` point will be the bottom of the obstacle.
#twocols(frac: 60%,
  show-code("contour-3"),
  show-page("contour-3"),
)

== Autocontouring

The contouring function ```typc contour.ascii-art(..)``` takes as input
a string or raw code and uses it to draw the shape of the image.
The characters that can occur are:
#twocols(frac: 52%,
  show-code("ascii-sheet", resize: -1pt),
  show-page("ascii-sheet"),
)

If you have #link("https://imagemagick.org/")[ImageMagick]
and #link("https://www.python.org/")[Python 3] installed,
you may use the auxiliary tool
#link("https://pypi.org/project/autocontour/")[`autocontour`]
to produce a first draft.
This small Python script will read an image, pixelate it, apply a customizable
threshold function, and produce a `*.contour` file that can be given as input
to ```typc contour.ascii-art(..)```.

#codesnippet[```sh
  # Install the script
  $ pip install autocontour

  # Run on `image.png` down to 15 by 10 pixels, with an 80% threshold.
  $ autocontour image.png 15x10 80%
```]
#codesnippet[```typ
  #meander.reflow({
    import meander: *
    placed(top + left,
      boundary: contour.ascii-art(read("image.png.contour")),
      image("image.png"),
    )
    // ...
  })
```]

#info-alert[
  You can read more about `autocontour` on the dedicated #link("https://github.com/Vanille-N/meander.typ/tree/master/autocontour/README.md")[`README.md`]
]

#warning-alert[
  `autocontour` is still very experimental.
]

#warning-alert[
  The output of `autocontour` is unlikely to be perfect, and it is not meant to be.
  The format is simple on purpose so that it can be tweaked by hand afterwards.
]

== More to come

If you find that the shape of your image is not convenient to express through
any of those means, you're free to submit suggestions as a
#link(repo + "issues")[feature request].

= Styling <styling-layout>

#let wrong-way(code, page) = {
  box[
    #table(columns: (15%, 85%), stroke: none, align: right, inset: 0pt,
      move(dy: -0.5pt, {
        context box(width: 100%, height: measure(page).height + 11pt, fill: red.darken(-80%), inset: 5mm, radius: (left: 5mm))[
          #align(center + horizon)[
            #rotate(-90deg, reflow: true)[
              #text(fill: red.darken(-50%), size: 20pt)[*Wrong*]
            ]
          ]
        ]
      }),
      box(width: 100%, fill: white, stroke: red.darken(-80%))[
        #twocols(code, page)
      ]
    )
  ]
}

#let right-way(code, page) = {
  box[
    #table(columns: (15%, 85%), stroke: none, align: right, inset: 0pt,
      move(dy: -0.5pt, {
        context box(width: 100%, height: measure(page).height + 11pt, fill: green.darken(-80%), inset: 5mm, radius: (left: 5mm))[
          #align(center + horizon)[
            #rotate(-90deg, reflow: true)[
              #text(fill: green.darken(-50%), size: 20pt)[*Correct*]
            ]
          ]
        ]
      }),
      box(width: 100%, fill: white, stroke: green.darken(-80%))[
        #twocols(code, page)
      ]
    )
  ]
}


MEANDER respects most styling options through a dedicated content segmentation
algorithm, as briefly explained in @explain-algo.
Bold, italic, underlined, stroked, highlighted, colored, etc. text
is preserved through threading, and easily so because those styling options do
not affect layout much.

There are however styling parameters that have a consequence on layout,
and some of them require special handling.
Some of these restrictions may be relaxed or entirely lifted by future updates.

== Paragraph justification

In order to properly justify text across boxes, MEANDER needs to have contextual
access to ```typ #par.justify```, which is only updated via a ```typ #set``` rule.

As such *do not* use ```typ #par(justify: true)[...]```.

Instead prefer ```typ #[#set par(justify: true); ...]```, or put the ```typ #set```
rule outside of the invocation of ```typ #meander.reflow``` altogether.

#wrong-way(
  show-code("par-justify", resize: -2pt),
  show-page("par-justify", width: 3.2cm),
)

#right-way(
  show-code("set-par-justify", resize: -2pt),
  show-page("set-par-justify", width: 3.2cm),
)

#right-way(
  show-code("set-par-justify-1", resize: -2pt),
  show-page("set-par-justify-1", width: 3.2cm),
)

== Font size and `par` leading

The font size indirectly affects layout because it determines the spacing between
lines. When a linebreak occurs between containers, MEANDER needs to manually
insert the appropriate spacing there. Since the spacing is affected by font size,
make sure to update the font size outside of the ```typ #meander.reflow```
invocation if you want the correct line spacing. Alternatively, `size`
can be passed as a parameter of `content` and it will be interpreted as the text size.

Analogously, if you wish to change the spacing between lines,
use either a ```typ #set par(leading: 1em)``` outside of ```typ #meander.reflow```,
or pass ```typc leading: 1em``` as a parameter to `content`. // TODO: type

#wrong-way(
  show-code("font-size-inside", resize: -2pt),
  show-page("font-size-inside", width: 2.9cm),
)

#right-way(
  show-code("font-size-outside", resize: -2pt),
  show-page("font-size-outside", width: 2.9cm),
)

#right-way(
  show-code("font-size-content", resize: -2pt),
  show-page("font-size-content", width: 2.9cm),
)

== Hyphenation and language

Hyphenation can only be fetched contextually, and highly influences how text
is split between boxes. Language indirectly influences layout because it determines
hyphenation rules.
To control the hyphenation and language, use the same approach as for the text
size: either ```typ #set``` them outside of ```typ #meander.reflow```,
or pass them as parameters to `content`. // TODO: type

#wrong-way(
  show-code("text-hyphenate-inside", resize: -2pt),
  show-page("text-hyphenate-inside", width: 2.9cm),
)

#right-way(
  show-code("text-hyphenate-outside", resize: -2pt),
  show-page("text-hyphenate-outside", width: 2.9cm),
)

#right-way(
  show-code("text-hyphenate-content", resize: -2pt),
  show-page("text-hyphenate-content", width: 2.9cm),
)

=== Styling containers

```typc container(..)``` accepts a `style` dictionary that may contain the following
keys:
- `text-fill`: the color of the text in this container,
- `align`: the left/center/right alignment of content,
- and more to come.

These options have in common that they do not affect layout so they can be applied
post-threading to the entire box. Future updates may lift this restriction.
#twocols(frac: 70%)[
  #show-code("post-style")
][
  #show-page("post-style")
]

= Multi-page setups <multi-page>

== Pagebreak

MEANDER can deal with text that spans multiple pages,
you just need to place ```typc pagebreak()```s appropriately.
Note that ```typc pagebreak()``` only affects the obstacles and containers,
while ```typc content(..)``` blocks ignore them entirely.

The layout below spans two pages:
- obstacles and containers before the ```typc pagebreak()``` go to the first page,
- obstacles and containers after the ```typc pagebreak()``` go to the second page,
- ```typc content(..)``` is page-agnostic and will naturally overflow to the second
  page when all containers from the first page are full.
#twocols[
  #show-code("two-pages/doc", resize: -2pt)
][
  #show-page("two-pages/doc.1", width: 3.5cm)
  #show-page("two-pages/doc.2", width: 3.5cm)
  Notice: text from a 1-column layout overflows into a 2-column layout.
]

== Colbreak

Analogously, ```typc colbreak()``` breaks to the next container.
Note that ```typc pagebreak()``` is a _container_ separator while
```typc colbreak()``` is a _content_ separator. The next container may be
on the next page, so the right way to create an entirely new page for both
containers and content is a ```typc pagebreak()``` *and* a ```typc colbreak()```...
or you could just end the ```typ #meander.reflow``` and start a new one.

#show-code("colbreak/doc", resize: -2pt)
#table(columns: (1fr, 1fr, 1fr), stroke: none,
  show-page("colbreak/doc.1"),
  show-page("colbreak/doc.2"),
  show-page("colbreak/doc.3"),
)

== Placement <placement>

Placement options control how a ```typ #meander.reflow``` invocation is visible
by and sees other content. This is important because MEANDER
places all its contents, so it is by default invisible to the native layout.

=== `page`

The default, and least opinionated, mode is `placement: page`.
- suitable for: one or more pages that `meander` has full control over.
- advantages: supports `pagebreak`s, several invocations can be superimposed,
  flexible.
- drawbacks: superimposed with content that follows.

=== `box`

The option `placement: box` will emit non-`place`d boxes to simulate the
actual space taken by the MEANDER-controlled layout.
- suitable for: an invocation that is part of a larger page.
- advantages: supports ```typc pagebreak()```, content that follows is automatically placed after.
- drawbacks: cannot superimpose multiple invocations.

=== `float`

Finally, `placement: float` produces a layout that spans at most a page,
but in exchange it can take the whole page even if some content has already
been placed.
- suitable for: single page layouts.
- advantages: gets the whole page even if some content has already been written.
- drawbacks: does not support `pagebreak`s, does not consider other content.

=== Use-case

Below is a layout that is not (as easily) achievable in `page` as it is in `box`.
Only text in red is actually controlled by MEANDER, the rest is naturally
placed before and after. This makes it possible to hand over to MEANDER only
a few paragraphs where a complex layout is required, then fall back to the native
Typst layout engine.
#table(columns: (1fr, 1fr), stroke: none)[
  #show-code("placement-box")

  For reference, to the right is the same page if we omit `placement: box`,
  where we can see a glitchy superimposition of text.
][
  #show-page("placement-box", width: 7cm)
  #align(right)[
    #v(-2cm)
    #show-page("placement-box-bad", width: 3cm)
  ]
]

== Overflow

By default, if the content provided overflows the available containers,
it will show a warning. This behavior is configurable.

=== No overflow

The default behavior is ```typc overflow: false``` because it avoids panics while
still alerting that something is wrong. The red warning box suggests adding
more containers or a pagebreak to fit the remaining text.
Setting ```typc overflow: true``` will silently ignore the overflow, while
```typc overflow: panic``` will immediately abort compilation.

#twocols(
  [```typc overflow: false``` \
    #show-code("overflow-false", resize: -2pt)
  ],
  show-page("overflow-false", width: 3.5cm),
)

#twocols(
  [```typc overflow: true``` \
    #show-code("overflow-true", resize: -2pt)
  ],
  show-page("overflow-true", width: 3.5cm),
)

#twocols(
  [```typc overflow: panic``` \
    #show-code("overflow-panic", resize: -2pt)
  ],
  show-page("overflow-panic", width: 3.5cm),
)

=== Predefined layouts

The above options are more useful if you absolutely want the content to fit
in the defined layout. A commonly desired behavior is for the overflow
to simply integrate with the layout as gracefully as possible.
That is the purpose of the two options that follow.

With ```typc overflow: pagebreak```, any content that overflows is placed on the next page.
This is typically most useful in conjunction with ```typc placement: page```,
and is outright incompatible with ```typc placement: float```
(because it does not support pagebreaks; see @placement).
#twocols[
  #show-code("overflow-pagebreak/doc", resize: -2pt)
][
  #show-page("overflow-pagebreak/doc.1", width: 3.5cm)
  #show-page("overflow-pagebreak/doc.2", width: 3.5cm)
  Blue text is part of the base layout.
  The overflow is in black, and is naturally followed by native text in red.
]

As for `overflow: text`, it is similarly best suited in conjunction with `placement: box`,
and simply writes the text after the end of the layout.
#twocols[
  #show-code("overflow-text/doc", resize: -2pt)
][
  #show-page("overflow-text/doc.1", width: 3.5cm)
  #show-page("overflow-text/doc.2", width: 3.5cm)
]

In both cases, any content that follows the ```typ #reflow``` invocation
will more or less gracefully follow after the overflowing text,
possibly with the need to slightly adjust paragraph breaks if needed.

=== Custom layouts

If your desired output does not fit in the above predefined behaviors,
you can fall back to writing a custom overflow handler. Any function
that returns `content` can serve as handler, including another invocation of
```typ #reflow```.
This function will be given as input a dictionary with fields:
- `styled` has all styling options applied and is generally what you should use,
- `structured` is suitable for placing in another ```typ #reflow``` invocation,
- `raw` uses an internal representation that you can iterate over, but
  that is not guaranteed to be stable. Use as last resort only.

For example here is a handler that adds a header and some styling options
to the text that overflows:
#twocols(frac: 67.5%)[
  #show-code("overflow-handler", resize: -1pt)
][
  #show-page("overflow-handler")
]

See also an answer I gave to
#link("https://github.com/Vanille-N/meander.typ/issues/1#issuecomment-3306100761")[issue \#1]
which demonstrates how passing a ```typ #meander.reflow``` layout as overflow handler
can achieve layouts not otherwise supported.
These applications should remain last-resort measures, and if you find that
a layout you would want to achieve is only possible by chaining together
several ```typ #meander.reflow``` handlers, consider instead
#link("https://github.com/Vanille-N/meander.typ/issues")[reaching out]
to see if there is a way to make this layout better supported.

= Showcase

A selection of nontrivial examples of what is feasible,
inspired mostly by requests on #link(typst-repo + "issues/5181")[issue \#5181].
You can find the source code for these on the #link(repo + "tree/master/examples")[repository].

#sourcecode[
  #image("/examples/5181-a/main.svg", width: 7.5cm)
  #show: align.with(bottom)
  #link(repo + "tree/master/examples/5181-a/main.typ")[`examples/5181-a/main.typ`] \
  Motivated by #link(typst-repo + "issues/5181#issue-2580297357")[`github:typst/typst` \#5181 (a)]
]

#sourcecode[
  #image("/examples/5181-b/main.svg", width: 7.5cm)
  #show: align.with(bottom)
  #link(repo + "tree/master/examples/5181-b/main.typ")[`examples/5181-b/main.typ`] \
  Motivated by #link(typst-repo + "issues/5181#issue-2580297357")[`github:typst/typst` \#5181 (b)]
]

#sourcecode[
  #image("/examples/talmudifier/main.svg", width: 7.5cm)
  #show: align.with(bottom)
  #link(repo + "tree/master/examples/talmudifier/main.typ")[`examples/talmudifier/main.typ`] \
  From #link("https://github.com/subalterngames/talmudifier")[`github:subalterngames/talmudifier`] \
  Motivated by #link(typst-repo + "issues/5181#issuecomment-2661180292")[`github:typst/typst` \#5181 (c)]
  ]

#sourcecode[
  #image("/examples/cow/main.svg", width: 7.5cm)
  #show: align.with(bottom)
  #link(repo + "tree/master/examples/cow/main.typ")[`examples/cow/main.typ`] \
  Motivated by #link("https://forum.typst.app/t/is-there-an-equivalent-to-latex-s-parshape/1006/3")["Is there an equivalent to LaTeX's \\parshape?" (Typst forum)]
]

= Public API

== Elements

#show-module("elems")

== Layouts

#show-module("layouts")

= Internal module details

== Geometry

#show-module("geometry", module: true)

== Tiling

#show-module("tiling", module: true)

== Contouring

#show-module("contour", module: true)

== Bisection

#show-module("bisect", module: true)

== Threading

#show-module("threading", module: true)

= Modularity (WIP)

Because meander is cleanly split into three algorithms
(content bisection, page tiling, text threading),
there are plans to provide
- additional configuration options for each of those steps
- the ability to replace entirely an algorithm by either a variant,
  or a user-provided alternative that follows the same signature.

= About

== Related works

In Typst:
- #universe("wrap-it") has essentially the same output as MEANDER with at
  only one obstacle and one container. It is noticeably more concise for very
  simple cases.

In #LaTeX:
- #link("https://ctan.org/pkg/wrapfig")[`wrapfig`] can achieve similar results
  as MEANDER as long as the images are rectangular, with the notable difference
  that it can even affect content outside of the `\begin{wrapfigure}...\end{wrapfigure}`
  environment.
- #link("https://ctan.org/pkg/floatflt")[`floatfit`] and
  #link("https://ctan.org/pkg/picins")[`picins`] can do a similar job as `wrapfig` with
  slightly different defaults.
- #link("https://ctan.org/topic/parshape")[`parshape`] is more low-level than all of
  the above, requiring every line length to be specified one at a time.
  It has the known drawback to attach to the paragraph data that depends on the
  obstacle, and is therefore very sensitive to layout adjustments.

Others:
- #link("https://helpx.adobe.com/indesign/using/text-wrap.html")[Adobe InDesign]
  supports threading text and wrapping around images with arbitrary shapes.

== Dependencies

In order to obtain hyphenation patterns, MEANDER imports
#universe("hy-dro-gen"), which is a wrapper around #github("typst/hypher").

This manual uses #universe("mantys") and #universe("tidy").

== Acknowledgements

MEANDER started out as an idea in the Typst Discord server;
thank you to everyone who gave input and encouragements.


