#import "@preview/mantys:1.0.2": *
#import "@preview/swank-tex:0.1.0": LaTeX
#import "@preview/tidy:0.4.3"

#import "revised.typ"

#show regex("Introduced in "): "Since "
#show regex("Available until "): "Until "

#let repo = "https://github.com/Vanille-N/meander.typ/"
#let typst-repo = "https://github.com/typst/typst/"

#let show-page(tag, page: 1, width: auto) = {
  box(stroke: black)[
    #image("/tests/figs/" + tag + "/ref/" + str(page) + ".png", width: width)
  ]
}

#let show-code(tag, resize: 0pt) = context {
  let relevant-lines = ()
  let take = false
  let compress = none
  for line in read("/tests/figs/" + tag + "/test.typ").split("\n") {
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
  if relevant-lines == () {
    relevant-lines = ("",)
  }
  codesnippet(
    raw(lang: "typ", block: true, relevant-lines.join("\n"))
  )
}

#let show-module(name, module: false, scope: (:), outlined: true) = {
  let path = "../src/" + name + ".typ"
  import path as mod
  tidy-module(
    name,
    module: if module == true { name } else if module == false { none } else { module },
    read(path),
    scope: scope,
  )
}

#let twocols(frac: 50%, l, r) = {
  table(columns: (frac, 100% - frac), stroke: none, l, r)
}

#show: revised.highlight-outline-entries

#show: mantys(
  ..toml("../typst.toml"),
  title: "MEANDER",
  subtitle: "User guide",
  date: datetime.today(),

  show-index: false,
  show-urls-in-footnotes: false,

  abstract: [
    MEANDER implements a content layout algorithm that supports automatically
    wrapping text around figures, and with a bit of extra work it can handle
    images of arbitrary shape.
    In practice, this makes MEANDER a temporary solution to
    #link(typst-repo + "issues/5181")[issue \#5181].
    When Typst eventually includes that feature natively, either MEANDER will
    become obsolete, or the additional options it provides will be reimplemented
    on top of the builtin features, greatly simplifying the codebase.

    Though very different in its modeling, MEANDER can be seen as a Typst
    alternative to #LaTeX's `wrapfig` and `parshape`, effectively
    enabling the same kinds of outputs.

    #box[
      #twocols(frac: 57%)[
        *Contributions* \
        If you have ideas for improvements, or if you encounter a bug,
        you are encouraged to contribute to MEANDER by submitting a
        #link(repo + "issues")[bug report],
        #link(repo + "issues")[feature request],
        or #link(repo)[pull request].

        // @scrybe(jump releases; grep {{version}})
        *Versions*
        - #link(repo)[`dev`]
        - #link(repo + "releases/tag/v0.4.0")[`0.4.0`]
          (#link("https://typst.app/universe/package/meander")[`latest`])
        - #link(repo + "releases/tag/v0.3.1")[`0.3.1`]
        - #link(repo + "releases/tag/v0.3.0")[`0.3.0`]
        - #link(repo + "releases/tag/v0.2.5")[`0.2.5`]
        - #link(repo + "releases/")[...]
      ][
        #show-page("cover")
      ]
    ]

    #colbreak()
    #place(box(width: 100%, height: 100%)[
      #place(bottom + right, dx: 1.5cm)[
        #box(width: 6.6cm, stroke: gray, radius: 5mm, inset: 5mm)[
          #set text(fill: gray, size: 10.5pt)
          #set linebreak(justify: true)
          #show: align.with(left)
          // @scrybe(jump latest; grep {{version}})
          Highlighted chapters denote
          #(revised.styles.breaking)[breaking changes],
          #(revised.styles.major)[major updates],
          #(revised.styles.minor)[minor updates],
          and #(revised.styles.new)[new additions],
          in the latest version `0.4.0`
          // TODO: add major/minor distinction
        ]
      ]
    ])
    #warning-alert[
      To migrate existing code, please consult @migration-0-3-0 and @migration-0-4-0
    ]
    #colbreak()
  ],
)

= Quick start

Import the latest version of MEANDER with:
// @scrybe(jump import; grep preview; grep {{version}})
#codesnippet[```typ
#import "@preview/meander:0.4.0"
```]

The main function provided by MEANDER is @cmd:meander:reflow,
which takes as input
a sequence of "containers", "obstacles", and "flowing content",
created respectively by the functions @cmd:container, @cmd:placed,
and @cmd:content.
Obstacles are placed on the page with a fixed layout. After excluding the zones
occupied by obstacles, the containers are segmented into boxes then filled
by the flowing content.

More details about MEANDER's model are given in
@explain-algo.

== A simple example

Below is a single page whose layout is fully determined by MEANDER.
The general pattern of @cmd:placed + @cmd:container + @cmd:content is
almost universal.

#twocols(frac: 51.5%)[
  #show-code("simple", resize: -1pt)
][
  #show-page("simple")
]

Within a @cmd:meander:reflow block, use @cmd:placed
(same parameters as the standard function #typ.place)
to position obstacles made of arbitrary content on the page,
specify areas where text is allowed with @cmd:container,
then give the actual content to be written there using @cmd:content.

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

A single @cmd:meander:reflow invocation can contain multiple @cmd:placed objects.
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
  However, thanks to this ability to wrap around an arbitrary number of obstacles,
  we can approximate a non-rectangular obstacle using sereval rectangles.
  See concrete applications and techniques for defining
  these rectangular tilings in @contouring.
]

== Columns <two-columns>

Similarly, MEANDER can also handle multiple occurrences of @cmd:container.
They will be filled in the order provided, leaving a (configurable) margin
between one and the next. Among other things, this can allow producing a layout
in columns, including columns of uneven width
(a longstanding #link(typst-repo + "issues/1460")[typst issue]).

#twocols(frac: 54%)[
  #show-code("two-columns", resize: -1pt)
][
  #show-page("two-columns")
]

== Anatomy of an invocation <anatomy>

As you can extrapolate from these examples,
every MEANDER invocation looks like this:
```typ
#meander.reflow({
  import meander: *
  // pre-layout options
  
  // layout and dynamic options
  
  // post-layout options
})
```

The most important part is the layout, composed of
+ `pagebreak`-separated pages, each made of
  - `container`s that can hold content,
  - `placed` obstacles delimiting regions that cannot hold content.
+ flowing `content`, which may also be interspersed with
  - `colbreak`s and `colfill`s to have finer control over how containers are filled.

Pre-layout options --- currently ```typc opt.debug``` and ```typc opt.placement``` ---
are configuration settings that come before any layout specification.
They apply to the entire layout that follows.

Post-layout options --- currently ```typc opt.overflow``` --- determine
how to close the layout and chain naturally with the text that follows.

Dynamic options are not instanciated yet,
but they will be settings that can be updated during the layout
affecting all following elements.

== Going further

If you want to learn more advanced features or if there's a glitch in your
layout, here are my suggestions.

In any case, I recommend briefly reading @explain-algo, as having a basic
understanding of what happens behind the scenes can't hurt.
This includes turning on some debugging options in @debug.

To learn how to handle non-rectangular obstacles, see @contouring.

If you have issues with text size or paragraph leading,
or if you want to enable hyphenation only for a single paragraph,
you can find details in @styling-layout.

To produce layouts that span more or less than a single page, see @multi-page.
If you are specifically looking to give MEANDER only a single paragraph
and you want the rest of the text to gracefully fit around, consult @placement.
If you want to learn about what to do when text overflows the provided containers,
this is covered in @overflow.

For more obscure applications, you can read @interactive,
or dive directly into the module documentation in @api.

== 0.2.x Migration Guide <migration-0-3-0>

From 0.2.5 to 0.3.0, configuration options have been reworked,
phasing out global settings in favor of pre- and post-layout settings.
Here is a comparison between old and new to help guide your migration.

#let hfill = h(1fr)
#table(columns: 2,
  [pre-*0.2.5*], [post-*0.3.0*],
  
  table.cell(colspan: 2)[#align(center)[*Debugging*]],

  [```typ #meander.regions({..})```  #hfill (command)],
  [```typc opt.debug.pre-thread()```  #hfill (pre)],

  [```typc debug: true```  #hfill (parameter)],
  [```typc opt.debug.post-thread()```  #hfill (pre)],

  table.cell(colspan: 2)[#align(center)[*Overflow*]],

  [```typc overflow: false``` #hfill (parameter)],
  [```typc opt.overflow.alert()``` #hfill (post)],

  [```typc overflow: true``` #hfill (parameter)],
  [```typc opt.overflow.ignore()``` #hfill (post)],

  [```typc overflow: pagebreak``` #hfill (parameter)],
  [```typc opt.overflow.pagebreak()``` #hfill (post)],

  [```typc overflow: text``` #hfill (parameter)],
  [new default],

  [```typc overflow: panic``` #hfill (parameter)],
  [discontinued due to convergence issues],

  [```typc overflow: repeat``` #hfill (parameter)],
  [```typc opt.overflow.repeat()``` #hfill (post)],

  [```typc overflow: state("_")``` #hfill (parameter)],
  [```typc opt.overflow.state("_")``` #hfill (post)],

  [```typc overflow: (_ => {})``` #hfill (parameter)],
  [```typc opt.overflow.custom(_ => {})``` #hfill (post)],

  table.cell(colspan: 2)[#align(center)[*Placement*]],
  [```typc placement: page``` #hfill (parameter)],
  [```typc opt.placement.phantom()``` #hfill (pre)],

  [```typc placement: box``` #hfill (parameter)],
  [new default],

  [```typc placement: float``` #hfill (parameter)],
  [discontinued],
)

#revised.new[== 0.3.x Migration Guide <migration-0-4-0>]

From 0.3.1 to 0.4.0, the `query` module received major reworks.
Instead of using `query` functions directly in the layout elements,
you should instead use a `callback` in conjunction with `query`
as below:
#table(columns: 2, [old], [new],
  codesnippet[```typc
  





  placed(
    query.position(..),
    ..
  )
  container(
    align: query.position(..),
    width: query.width(..),
    height: query.height(..),
  )



  ```],
  codesnippet[```typc
  callback(env: (
      pos1: query.position(..),
      align2: query.position(..),
      width2: query.width(..),
      heigth2: query.height(..),
    ),
    env => {
      placed(
        env.pos1,
        ..
      )
      container(
        align: env.align2,
        width: env.width2,
        height: env.height2,
      )
    },
  )
  ```]
)
Although slightly more verbose, this new approach is much more flexible
and will reduce the amount of repeated computations.
For more details, consult @querying.

= Understanding the algorithm <explain-algo>

Although it can produce the same results as `parshape` in practice,
MEANDER's model is fundamentally different.
In order to better understand the limitations of what is feasible,
know how to tweak an imperfect layout, and anticipate issues that may occur,
it helps to have a basic understanding of MEANDER's algorithm(s).

Even if you don't plan to contribute to the implementation of MEANDER,
I suggest you nevertheless briefly read this section to have an intuition
of what happens behind the scenes.

== Debugging <debug>

The examples below use some options that are available for debugging.

Debug configuration is a pre-layout option, which means it should be specified
before any other elements.
```typ
#meander.reflow({
  import meander: *
  opt.debug.pre-thread() // <- sets the debug mode to "pre-thread"
  // ...
})
```
The debug modes available are as follows:
- `release`: this is the default, having no visible debug markers.
- `pre-thread`: includes obstacles (in red) and containers (in green) but not content.
  Helps visualize the usable regions.
- `post-thread`: includes obstacles (in red), containers, and content.
  Containers have a green border to show the real boundaries after adjustments
  (during threading, container boundaries are tweaked to produce consistent
  line spacing).
- `minimal`: does not render the obstacles and is thus an even more
  streamlined version of `pre-thread`.

//See @opt-debug for more details.

== Page tiling

When you write some layout such as the one below,
MEANDER receives a sequence of elements that it splits into obstacles,
containers, and content.
#show-code("debug-post", resize: -3pt)
First the #typ.measure of each obstacle is computed, their positioning
is inferred from the alignment parameter of @cmd:placed, and they are
placed on the page. The regions they cover as marked as forbidden.

Then the same job is done for the containers, marking those regions as allowed.
The two sets of computed regions are combined by subtracting the forbidden regions
from the allowed ones, giving a rectangular subdivision of the usable areas.

#figure(
  [
    #show-page("debug-obstacles", width: 4.5cm)
    #show-page("debug-containers", width: 4.5cm)
    #show-page("debug-pre", width: 4.5cm)
  ],
  caption: [Left to right: the forbidden, allowed, and combined regions.],
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
2. splitting #typ.strong text is equivalent to applying #typ.strong to both
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
  show-page("debug-post", width: 4.5cm),
  caption: [Debug view of the final output via ```typc opt.debug.post-thread()```],
)

#info-alert[
  Every piece of content produced by @cmd:meander:reflow is placed,
  and therefore does not affect layout outside of @cmd:meander:reflow.
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
and we can do so using the function @cmd:contour:grid,
which takes as input a 2D formula normalized to $[0,1]$,
i.e. a function from $[0,1] times [0,1]$ to #typ.t.bool.

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

#revised.minor[== Boundaries as layers]

If your shape is not convenient to express through a grid function, but
has some horizontal or vertical regularity, here are some other suggestions.
As before, they are all normalized between $0$ and $1$.

#info-alert[
  Recall that when using all of these you have access to
  the various settings of `opt.debug` (@debug) that can help
  understand how a given contour segments the obstacle.
]

=== Horizontal rectangles

@cmd:contour:horiz and @cmd:contour:width produce horizontal layers of varying width.
@cmd:contour:horiz works on a `(left, right)` basis
(the parameterizing function should return the two extremities of the obstacle),
while @cmd:contour:width works on an `(anchor, width)` basis.

#twocols(frac: 40%,
  show-page("contour-1"),
  show-code("contour-1"),
)

The interpretation of #arg[flush] for @cmd:contour:width is as follows:
- if #arg(flush: left), the `anchor` point will be the left of the obstacle;
- if #arg(flush: center), the `anchor` point will be the middle of the obstacle;
- if #arg(flush: right), the `anchor` point will be the right of the obstacle.
#twocols(frac: 60%,
  show-code("contour-2"),
  show-page("contour-2"),
)

=== Vertical rectangles

@cmd:contour:vert and @cmd:contour:height produce vertical layers of varying height.

#twocols(frac: 40%,
  show-page("contour-4"),
  show-code("contour-4"),
)

The interpretation of #arg[flush] for @cmd:contour:height is as follows:
- if #arg(flush: top), the `anchor` point will be the top of the obstacle;
- if #arg(flush: horizon), the `anchor` point will be the middle of the obstacle;
- if #arg(flush: bottom), the `anchor` point will be the bottom of the obstacle.
#twocols(frac: 60%,
  show-code("contour-3"),
  show-page("contour-3"),
)

== Autocontouring

The contouring function @cmd:contour:ascii-art takes as input
a string or raw code and uses it to draw the shape of the image.
The characters that can occur are:
#twocols(frac: 52%,
  show-code("ascii-sheet", resize: -2pt),
  show-page("ascii-sheet"),
)

If you have #link("https://imagemagick.org/")[ImageMagick]
and #link("https://www.python.org/")[Python 3] installed,
you may use the auxiliary tool
#link("https://pypi.org/project/autocontour/")[`autocontour`]
to produce a first draft.
This small Python script will read an image, pixelate it, apply a customizable
threshold function, and produce a `*.contour` file that can be given as input
to @cmd:contour:ascii-art.

#codesnippet[```sh
  # Install the script
  $ pip install autocontour

  # Run on `image.png` down to 15 by 10 pixels, with an 80% threshold.
  $ autocontour image.png 15x10 80%

  # Then use your text editor of choice to tweak `image.png.contour`
  # if it is not perfect.
  ```
]
#codesnippet[```typ
  #meander.reflow({
    import meander: *
    placed(top + left,
      // Import statically generated boundary.
      boundary: contour.ascii-art(read("image.png.contour")),
      image("image.png"),
    )
    // ...
  })
  ```
]

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
rule outside of the invocation of @cmd:meander:reflow altogether.

#wrong-way(
  show-code("justify-par", resize: -2pt),
  show-page("justify-par", width: 3.2cm),
)

#right-way(
  show-code("justify-inside", resize: -2pt),
  show-page("justify-inside", width: 3.2cm),
)

#right-way(
  show-code("justify-outside", resize: -2pt),
  show-page("justify-outside", width: 3.2cm),
)

== Font size and leading

The font size indirectly affects layout because it determines the spacing between
lines. When a linebreak occurs between containers, MEANDER needs to manually
insert the appropriate spacing there. Since the spacing is affected by font size,
make sure to update the font size outside of the @cmd:meander:reflow.
invocation if you want the correct line spacing. Alternatively, #arg[size]
can be passed as a parameter of @cmd:content and it will be interpreted as the text size.

Analogously, if you wish to change the spacing between lines,
use either a ```typ #set par(leading: 1em)``` outside of @cmd:meander:reflow,
or pass #arg(leading: 1em) as a parameter to @cmd:content.

#wrong-way(
  show-code("font-size-inside", resize: -2pt),
  show-page("font-size-inside", width: 2.6cm),
)

#right-way(
  show-code("font-size-outside", resize: -2pt),
  show-page("font-size-outside", width: 2.6cm),
)

#right-way(
  show-code("font-size-content", resize: -2pt),
  show-page("font-size-content", width: 2.6cm),
)

== Hyphenation and language

Hyphenation can only be fetched contextually, and highly influences how text
is split between boxes. Language indirectly influences layout because it determines
hyphenation rules.
To control the hyphenation and language, use the same approach as for the text
size: either ```typ #set``` them outside of @cmd:meander:reflow,
or pass them as parameters to #typ.t.content.

#wrong-way(
  show-code("text-hyphenate-inside", resize: -2pt),
  show-page("text-hyphenate-inside", width: 2.6cm),
)

#right-way(
  show-code("text-hyphenate-outside", resize: -2pt),
  show-page("text-hyphenate-outside", width: 2.6cm),
)

#right-way(
  show-code("text-hyphenate-content", resize: -2pt),
  show-page("text-hyphenate-content", width: 2.6cm),
)

== Styling containers

@cmd:container accepts a #arg[style] dictionary that may contain the following
keys:
- #arg[text-fill]: the color of the text in this container,
- #arg[align]: the left/center/right alignment of content,
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
you just need to place one or more @cmd:pagebreak appropriately.
Note that @cmd:pagebreak only affects the obstacles and containers,
while @cmd:content blocks ignore them entirely.

The layout below spans two pages:
- obstacles and containers before the @cmd:pagebreak go to the first page,
- obstacles and containers after the @cmd:pagebreak go to the second page,
- @cmd:content is page-agnostic and will naturally overflow to the second
  page when all containers from the first page are full.
#twocols[
  #show-code("two-pages", resize: -2pt)
][
  #show-page("two-pages", page: 1, width: 3.5cm)
  #show-page("two-pages", page: 2, width: 3.5cm)
  *Notice:* text from a 1-column layout overflows into a 2-column layout.
]

== Colbreak

Analogously, @cmd:colbreak breaks to the next container.
Note that @cmd:pagebreak is a _container_ separator while
@cmd:colbreak is a _content_ separator. The next container may be
on the next page, so the right way to create an entirely new page for both
containers and content is a @cmd:pagebreak *and* a @cmd:colbreak...
or you could just end the @cmd:meander:reflow and start a new one.

#show-code("colbreak", resize: -2pt)
#table(columns: (1fr, 1fr, 1fr), stroke: none,
  show-page("colbreak", page: 1),
  show-page("colbreak", page: 2),
  show-page("colbreak", page: 3),
)

== Colfill

Contrary to @cmd:colbreak which breaks to the next container,
@cmd:colfill fills the current container, _then_ breaks to the next
container.
There is sometimes a subtle difference between these behaviors,
as demonstrated by the examples below.
Choose whichever is appropriate based on your use-case.
#twocols(frac: 70%)[
  #show-code("break-or-fill")
][
  #show-page("break-or-fill")
]
#twocols(frac: 70%)[
  #show-code("fill-or-break")
][
  #show-page("fill-or-break")
]
#info-alert[
  Recall that filled containers count as obstacles for future containers,
  so there is a difference between dropping containers and filling them with
  nothing.
]

== Placement <placement>

Placement options control how a @cmd:meander:reflow invocation is visible
by and sees other content.
By default, MEANDER will automatically insert invisible boxes of the correct
height to emulate the text's placement. If this does not behave exactly
as you want, this section details the alternatives available.

Placement options are pre-layout, meaning they come in the shape
of ```typc opt.placement.___``` before any containers or obstacles.

If the space computed by MEANDER is wrong, you can disable it entirely
by adding ```typc opt.placement.phantom()``` (see below: right),
or adjust the margins such as with ```typc opt.placement.spacing(below: 0.65em)```
(see below: left).

#figure(
  grid(columns: 3, gutter: 5mm,
    show-page("placement-spacing", width: 4cm),
    show-page("placement-box", width: 4cm),
    show-page("placement-box-bad", width: 4cm),
    [Manually adjusted spaces above and below to correct for paragraph breaks.],
    [Default heuristic, with artificial spacing.],
    [No artificial spacing.],
  )
)

== Overflow <overflow>

By default, if the content provided overflows the available containers,
it will spill over after the MEANDER invocation. This default behavior means
that you don't have to worry about losing text if the containers are too
small, and should work for most use-cases.

See below: the text in green / red is respectively before / after the MEANDER
invocation. The actual layout is only the two blue columns, but the text in
black overflows and is thus placed afterwards normally.
#figure({
  show-page("overflow-default", page: 1, width: 4.5cm)
  h(1em)
  show-page("overflow-default", page: 2, width: 4.5cm)
})
#show-code("overflow-default", resize: -2pt)

Nevertheless if you need more control over what happens with the overflow,
the following options are available.

=== No overflow

With ```typc opt.overflow.alert()```, a warning message will be added to the
document if there is any overflow. The overflow itself will disappear, so
the layout is guaranteed to take no more than the allocated space.
As for ```typc opt.overflow.ignore()```, it will silently drop any content
that doesn't fit.
#twocols(
  [```typc opt.overflow.alert()``` \
    #show-code("overflow-alert", resize: -2pt)
  ],
  show-page("overflow-alert", width: 3.5cm),
)

#twocols(
  [```typc opt.overflow.ignore()``` \
    #show-code("overflow-ignore", resize: -2pt)
  ],
  show-page("overflow-ignore", width: 3.5cm),
)

=== Predefined layouts

With ```typc opt.overflow.pagebreak()```,
any content that overflows is placed on the next page.
This can be particularly interesting if you are also using
```typc opt.placement.phantom()``` because that one will not behave well
with the default overflow settings.

#twocols[
  #show-code("overflow-pagebreak", resize: -2pt)
][
  #show-page("overflow-pagebreak", page: 1, width: 3.5cm)
  #show-page("overflow-pagebreak", page: 2, width: 3.5cm)
  Blue text is part of the base layout.
  The overflow is in black on the next page even though the layout does not
  occupy the entire page.
]

Secondly, ```typc opt.overflow.repeat(count: 1)``` will duplicate the `count`
last pages (default: 1) of the layout until all the content fits.
#twocols[
  #show-code("overflow-repeat")
][
  #show-page("overflow-repeat", page: 1, width: 2.3cm)
  #show-page("overflow-repeat", page: 2, width: 2.3cm)
  #show-page("overflow-repeat", page: 3, width: 2.3cm)
]

=== Custom layouts

#warning-alert[
  Before resorting to one of these solutions, check if there isn't a better way to do
  whatever you're trying to achieve.
  If it really is the only solution, consider
  #link("https://github.com/Vanille-N/meander.typ/issues")[reaching out]
  to see if there is a way to make your desired layout better supported
  and available to other people.
]

If your desired output does not fit in the above predefined behaviors,
you can fall back to storing it to a state or writing a custom overflow handler.
Any function #lambda("overflow", ret:content) passed to
```typc opt.overflow.custom(_ => {})``` can serve as handler,
including another invocation of @cmd:meander:reflow.
This function will be given as input an object of type @type:overflow,
which is concretely a dictionary with fields:
- #arg[styled] is #typ.t.content with all styling options applied and is generally
  what you should use,
- #arg[structured] is an array of @type:elem, suitable for placing in another
  @cmd:meander:reflow invocation,
- #arg[raw] uses an internal representation that you can iterate over, but
  that is not guaranteed to be stable. Use as last resort only.

Similarly if you pass to ```typc opt.overflow.state(label)```
a #typ.state or a #typ.t.str, it will receive any content that overflows
in the same 3 formats, and you can use ```typc state.get()``` on it afterwards.

For example here is a handler that adds a header and some styling options
to the text that overflows:
#twocols(frac: 63%)[
  #show-code("overflow-custom", resize: -1pt)
][
  #show-page("overflow-custom")
]

And here is one that stores to a state to be retrieved later:
#twocols(frac: 63%)[
  #show-code("overflow-state", resize: -1pt)
][
  #show-page("overflow-state")
]
#warning-alert[
  Use in moderation. Chaining multiple of these together can make your
  layout diverge.
]

See also an answer I gave to
#link("https://github.com/Vanille-N/meander.typ/issues/1#issuecomment-3306100761")[issue \#1]
which demonstrates how passing a @cmd:meander:reflow layout as overflow handler
can achieve layouts not otherwise supported.
Use this only as a last-resort solution.

= Inter-element interaction <interactive>

MEANDER allows attaching tags to elements.
These tags can then be used to:
- control visibility of obstacles to other elements,
- apply post-processing style parameters,
- position an element relative to a previous one,
- measuring the width or height of a placed element.

More features are planned, including
- additional styling options,
- default parameters controlled by tags.
Open a #link(repo + "issues")[feature request] if you have an idea of a behavior
based on tags that should be supported.

You can put one or more tags on any obstacle or container by adding a parameter
#arg[tags] that contains a #typ.t.label or an array of #typ.t.label. For example:
- ```typc placed(..., tags: <A>)```
- ```typc container(..., tags: (<B>, <C>))```

== Locally invisible obstacles

By passing one or more tags to the parameter #arg[invisible] of ```typc container(..)```,
you can make it unaffected by the obstacles in question.

#twocols(frac: 57.5%)[
  #show-code("invisible")
][
  #show-page("invisible")
]
#info-alert[
  This is already doable globally by setting #arg[boundary] to @cmd:contour:phantom.
  The innovation of #arg[invisible] is that this can be done on a per-container basis.
]

#revised.breaking[== Callbacks and queries <querying>]

The module ```typ #query``` contains functions that allow referencing properties
of other elements, as well as other properties that may be dynamically updated
in the process of computing the layout. They are used in conjunction with a
`callback` invocation that determines the point of evaluation.
See @queries for a list of properties that can be queried, and @cmd:callback
for other technical details.

A @cmd:callback takes a list of named parameters and a function,
evaluates the parameters at the call site while the layout is ongoing,
and then call the function with the appropriate environment.
Below is a possible usage:

#twocols(frac: 60%)[
  #show-code("query", resize: -1.5pt)
][
  #show-page("query")
  In this example, after giving an absolute position to one image,
  we create a container with position and dimensions relative to the image,
  and place another image immediately after the container ends.
]

== A nontrivial example

Here is an interesting application of these features.
The @cmd:placed obstacles all receive a tag ```typc <x>```,
and the second container has #arg(invisible: <x>).
Therefore the @cmd:placed elements count as obstacles to the first
container but not the second.
The first container is immediately filled with empty content and counts as
an obstacle to the second container.
The queries reduce the amount of lengths we have to compute by hand.
#twocols(frac: 62%)[
  #show-code("interactive", resize: -2pt)
][
  #show-page("interactive")
]

= Showcase

A selection of nontrivial examples of what is feasible,
inspired mostly by requests on #link(typst-repo + "issues/5181")[issue \#5181].
You can find the source code for these on the #link(repo + "tree/master/tests/examples")[repository].

#revised.minor[== Side illustrations]

#box(width: 49%)[
#sourcecode[
  #align(center)[#image("/tests/examples/typst-5181-a/ref/1.png", width: 7cm)]
  #show: align.with(bottom)
  #set text(size: 10pt)
  #link(repo + "tree/master/tests/examples/typst-5181-a/test.typ")[`tests/examples/typst-5181-a/test.typ`] \
  Motivated by #link(typst-repo + "issues/5181#issue-2580297357")[`github:typst/typst` \#5181 (a)]
]
]
#box(width: 49%)[
#sourcecode[
  #align(center)[#image("/tests/examples/cow/ref/1.png", width: 7cm)]
  #show: align.with(bottom)
  #set text(size: 10pt)
  #link(repo + "tree/master/tests/examples/cow/test.typ")[`tests/examples/cow/test.typ`] \
  Motivated by #link("https://forum.typst.app/t/is-there-an-equivalent-to-latex-s-parshape/1006/3")["Is there an equivalent to LaTeX's \\parshape?" (Typst forum)]
]
]
#box(width: 49%)[
#sourcecode[
  #align(center)[#image("/tests/examples/typst-5181-b/ref/1.png", width: 6cm)]
  #show: align.with(bottom)
  #set text(size: 10pt)
  #link(repo + "tree/master/tests/examples/typst-5181-b/test.typ")[`tests/examples/typst-5181-b/test.typ`] \
  Motivated by #link(typst-repo + "issues/5181#issue-2580297357")[`github:typst/typst` \#5181 (b)]
]
]

#revised.minor[== Paragraph packing]

#box(width: 49%)[
#sourcecode[
  #image("/tests/examples/talmudifier/ref/1.png", width: 7cm)
  #show: align.with(bottom)
  #set text(size: 10pt)
  #link(repo + "tree/master/tests/examples/talmudifier/test.typ")[`tests/examples/talmudifier/test.typ`] \
  From #link("https://github.com/subalterngames/talmudifier")[`github:subalterngames/talmudifier`] \
  Motivated by #link(typst-repo + "issues/5181#issuecomment-2661180292")[`github:typst/typst` \#5181 (c)]
  ]
]
#box(width: 49%)[
#sourcecode[
  #image("/tests/examples/area-of-a-circle/ref/1.png", width: 7cm)
  #show: align.with(bottom)
  #set text(size: 9pt)
  #link(repo + "tree/master/tests/examples/area-of-a-circle/test.typ")[`tests/examples/area-of-a-circle/test.typ`] \
  Inspired by TeXBook, asked on #link("https://tex.stackexchange.com/questions/341550/how-was-this-circular-paragraph-made")[Stack Exchange]
]
]

#revised.new[== Drop caps]

#box(width: 49%)[
#sourcecode[
  #image("../tests/examples/drop-caps/ref/1.png", width: 7cm)
  #show: align.with(bottom)
  #link(repo + "tree/master/tests/examples/drop-caps/test.typ")[`tests/examples/drop-caps/test.typ`] \
  Courtesy of #github-user("wade-cheng")
  on #link(repo + "issues/18")[#{"#"}18]
]
]

= Public API <api>

These are the user-facing functions of MEANDER.

// TODO: colors
#custom-type("state")
#custom-type("elem")
#custom-type("block") // Don't forget the optional bounds and styles
#custom-type("blocks")
#custom-type("contour")
#custom-type("align")
#custom-type("size")
#custom-type("overflow")

#revised.major[== Elements <elem-doc>]

All constructs that are valid within a ```typ #meander.reflow({ .. })``` block.
Note that they all produce an object that is a singleton dictionary,
so that the ```typ #meander.reflow({ .. })``` invocation is automatically
passed as input the concatenation of all these elements.
For clarity we use the more descriptive type @type:elem,
instead of the internal representation `(dictionary,)`

#show-module("elems")

== Layouts

These are the toplevel invocations.
They expect a sequence of `elem` as input, and produce `content`.

#show-module("layouts", module: "meander")

== Contouring <contouring-doc>

Functions for approximating non-rectangular boundaries.
We refer to those collectively as being of type @type:contour.
They can be concatenated with `+` which will apply contours successively.

#show-module("contour", module: true)

#revised.breaking[== Queries <queries>]

Enables interactively fetching properties from previous elements.
See how to use them in @interactive.

#show-module("query", module: true)

== Options

Configuring the behavior of @cmd:meander:reflow.

=== Pre-layout options

These come before all elements.

==== Debug settings
Visualizing containers and obstacle boundaries.
#show-module("opt/debug", module: "opt.debug")

==== Placement settings
Controlling the interactions between content
inside and outside of the MEANDER invocation.
#show-module("opt/placement", module: "opt.placement")

=== Dynamic options

These modify parameters on the fly.

#warning-alert[None yet]

=== Post-layout options

These come after all elements.

==== Overflow settings
What happens to content that doesn't fit.
#show-module("opt/overflow", module: "opt.overflow")

== Public internals

If MEANDER is too high-level for you, you may use the public internals
made available as lower-level primitives.

#warning-alert[
  Public internal functions have a lower standard for backwards compatibility.
  Make sure to pin a specific version.
]

// @scrybe(jump import; grep {{version}})
#codesnippet[
```typ
#import "@preview/meander:0.4.0": internals.fill-box
```
]
This grants you access to the primitive `fill-box`, which is the entry
point of the content bisection algorithm. It allows you to take as much
content as fits in a specific box. See @cmd:bisect:fill-box for details.

// @scrybe(jump import; grep {{version}})
#codesnippet[
```typ
#import "@preview/meander:0.4.0": internals.geometry
```
]
This grants you access to all the functions in the `geometry` module,
which implement interesting 1D and 2D primitives. See @geometry for details.


#show-module("internals", module: true)

#revised.major[= Internal module details <internal>]

== Utils

#show-module("utils", module: true)

== Types

#show-module("types", module: true)

== Geometry <geometry>

#show-module("geometry", module: true)

== Tiling

#show-module("tiling", module: true)

== Bisection

#show-module("bisect", module: true)

== Threading

#show-module("threading", module: true)

= About

== Related works

This package takes a lot of basic ideas from
#link("https://laurmaedje.github.io/posts/layout-models/")[Typst's own builtin layout model],
mainly lifting the restriction that all containers must be of the same width,
but otherwise keeping the container-oriented workflow.
There are other tools that implement similar features, often with very different
models internally.

*In Typst:*
- #universe("wrap-it") has essentially the same output as MEANDER with
  only one obstacle and one container. It is noticeably more concise for very
  simple cases.

*In #LaTeX:*
- #link("https://ctan.org/pkg/wrapfig")[`wrapfig`] can achieve similar results
  as MEANDER as long as the images are rectangular, with the notable difference
  that it can even affect content outside of the
  ```tex \begin{wrapfigure}...\end{wrapfigure}``` environment.
- #link("https://ctan.org/pkg/floatflt")[`floatfit`] and
  #link("https://ctan.org/pkg/picins")[`picins`] can do a similar job as `wrapfig` with
  slightly different defaults.
- #link("https://ctan.org/topic/parshape")[`parshape`] is more low-level than all of
  the above, requiring every line length to be specified one at a time.
  It has the known drawback to attach to the paragraph data that depends on the
  obstacle, and is therefore very sensitive to layout adjustments.

*Others:*
- #link("https://helpx.adobe.com/indesign/using/text-wrap.html")[Adobe InDesign]
  supports threading text and wrapping around images with arbitrary shapes.

== Dependencies

In order to obtain hyphenation patterns, MEANDER imports
#universe("hy-dro-gen"), which is a wrapper around #github("typst/hypher").
This manual is built using #universe("mantys") and #universe("tidy").

== Acknowledgements

MEANDER would have taken much more effort to bootstrap had I not had access to
#universe("wrap-it")'s source code to understand the internal representation
of content, so thanks to #github-user("ntjess").

MEANDER started out as an idea in the Typst Discord server;
thanks to everyone who gave input and encouragements.

Thanks also to the people who use MEANDER and submit bug reports and feature requests,
many regressions would not have been discovered as quickly were it not for their
vigilance.

