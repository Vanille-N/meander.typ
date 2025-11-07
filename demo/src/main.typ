#import "@preview/touying:0.6.1": *
#import themes.university: *
#import "@preview/cetz:0.4.2"
#import "@preview/numbly:0.1.0": numbly
#import "@preview/theorion:0.3.2": *
#import "@preview/tiaoma:0.3.0"
#import cosmos.clouds: *
#show: show-theorion

#import "@preview/meander:0.2.4"

// cetz bindings for touying
#let cetz-canvas = touying-reducer.with(reduce: cetz.canvas, cover: cetz.draw.hide.with(bounds: true))

#let title-decorations = {
  place(top + left, dx: -2cm, dy: -2cm)[#box(width: 100% + 4cm, height: 100% + 4cm)[
    #set par(justify: true)
    #meander.reflow(overflow: true, {
      import meander: *
      placed(center + horizon,
        boundary: contour.margin(7pt) + contour.grid(div: 58, (x,y) => calc.pow(2 * x - 1, 2) + calc.pow(2 * y - 1, 2) <= 1),
        block(
          radius: 50%,
          width: 12cm,
          height: 12cm,
          //stroke: blue,
        )
      )
      placed(center + horizon, dx: 7cm, dy: -4cm,
        boundary: contour.margin(10pt) + contour.grid(div: 30, (x,y) => calc.pow(2 * x - 1, 2) + calc.pow(2 * y - 1, 2) <= 1),
        block(
          radius: 50%,
          clip: true,
          image("/assets/typst-logo.png", width: 5cm),
        )
      )

      container()
      content(size: 7pt)[#lorem(2000)]
    })
  ]]
}

#show: university-theme.with(
  aspect-ratio: "16-9",
  // align: horizon,
  // config-common(handout: true),
  config-info(
    title: [Meander],
    subtitle: [A Text Threading Engine],
    author: [Neven Villani (\@vanilline_ven)],
    date: datetime(day: 7, month: 11, year: 2025),
    institution: [Typst Community Call #title-decorations],
  ),
  footer-columns: (0%, 1fr, 0%),
  footer-a: none,
  footer-b: none,
  footer-c: none,
)

#set heading(numbering: none)

#title-slide()

= Threading

#slide[
  #set text(lang: "en")
  #meander.reflow(debug: true, {
    import meander: *
    container(width: 23%)
    container(align: top + right, dy: 2cm, width: 31%)
    container(align: top + center, dy: 8cm, width: 40%)
    content[Text threading is when content that would overflow from one container]
    colbreak()
    content[
      continues into a different container.
      This happens all the time with pagebreaks,
    ]
    colbreak()
    content[
      but Typst can only do this natively for containers that all have the *same width*.
    ]
  })
]

#let invisible = (text-fill: white.transparentize(100%))
#[
  #set text(lang: "la", hyphenate: true)
  #set par(justify: true)
  #slide[
    #place(top + left)[
      #cetz.canvas({
        import cetz.draw: *
        rect((0, 0), (26, 15), stroke: none)
        content((12, 15), name: "conts")[#text(fill: green)[containers]]
        bezier((to: "conts", rel: (0, -10pt)), (to: (), rel: (-4, -0)), (to: (), rel: (-1, -0.5)), mark: (end: ">"), stroke: green)
        line((to: "conts", rel: (0, -10pt)), (to: (), rel: (0, -1)), mark: (end: ">"), stroke: green)
        bezier((to: "conts", rel: (0, -10pt)), (to: (), rel: (3.5, -0)), (to: (), rel: (1, -0.5)), mark: (end: ">"), stroke: green)

        content((5, 5), name: "buf")[#text(fill: blue)[buffer]]
        bezier((to: "buf", rel: (-1.2cm, 0)), (to: (), rel: (-0.5, -0.5)), (to: (), rel: (-1, 0)), mark: (end: ">"), stroke: blue)
      })
    ]
    #meander.reflow(debug: true, overflow: true, {
      import meander: *
      placed(top + left, dy: 11cm, boundary: contour.phantom(), box(fill: gray.lighten(30%), width: 100%, height: 4cm))
      container(dy: 11cm, width: 100%, style: (text-fill: blue))
      container(width: 25%, height: 45%)
      container(dx: 8cm, dy: 2cm, width: 30%, height: 50%)
      container(dx: 17cm, dy: 1cm, width: 20%, height: 50%)
      content(size: 14pt)[#lorem(1000)]
      colfill()
      colfill()
      colfill()
      colfill()
    })
  ]
  #slide[
    #place(top + left)[
      #cetz.canvas({
        import cetz.draw: *
        rect((0, 0), (26, 15), stroke: none)
        content((12, 15), name: "conts")[#text(fill: green)[containers]]
        bezier((to: "conts", rel: (0, -10pt)), (to: (), rel: (-4, -0)), (to: (), rel: (-1, -0.5)), mark: (end: ">"), stroke: green)
        line((to: "conts", rel: (0, -10pt)), (to: (), rel: (0, -1)), mark: (end: ">"), stroke: green)
        bezier((to: "conts", rel: (0, -10pt)), (to: (), rel: (3.5, -0)), (to: (), rel: (1, -0.5)), mark: (end: ">"), stroke: green)

        content((5, 5), name: "buf")[#text(fill: blue)[buffer]]
        bezier((to: "buf", rel: (-1.2cm, 0)), (to: (), rel: (-0.5, -0.5)), (to: (), rel: (-1, 0)), mark: (end: ">"), stroke: blue)
      })
    ]

    #meander.reflow(debug: true, overflow: true, {
      import meander: *
      container(width: 25%, height: 45%)
      placed(top + left, dy: 11cm, boundary: contour.phantom(), box(fill: gray.lighten(30%), width: 100%, height: 4cm))
      container(dy: 11cm, width: 100%, style: (text-fill: blue))
      container(dx: 8cm, dy: 2cm, width: 30%, height: 50%)
      container(dx: 17cm, dy: 1cm, width: 20%, height: 50%)
      content(size: 14pt)[#lorem(1000)]
      colfill()
      colfill()
      colfill()
    })
  ]
  #slide[
    #place(top + left)[
      #cetz.canvas({
        import cetz.draw: *
        rect((0, 0), (26, 15), stroke: none)
        content((12, 15), name: "conts")[#text(fill: green)[containers]]
        bezier((to: "conts", rel: (0, -10pt)), (to: (), rel: (-4, -0)), (to: (), rel: (-1, -0.5)), mark: (end: ">"), stroke: green)
        line((to: "conts", rel: (0, -10pt)), (to: (), rel: (0, -1)), mark: (end: ">"), stroke: green)
        bezier((to: "conts", rel: (0, -10pt)), (to: (), rel: (3.5, -0)), (to: (), rel: (1, -0.5)), mark: (end: ">"), stroke: green)

        content((5, 5), name: "buf")[#text(fill: blue)[buffer]]
        bezier((to: "buf", rel: (-1.2cm, 0)), (to: (), rel: (-0.5, -0.5)), (to: (), rel: (-1, 0)), mark: (end: ">"), stroke: blue)
      })
    ]

    #meander.reflow(debug: true, overflow: true, {
      import meander: *
      container(width: 25%, height: 45%)
      placed(top + left, dy: 11cm, boundary: contour.phantom(), box(fill: gray.lighten(30%), width: 100%, height: 4cm))
      container(dx: 8cm, dy: 2cm, width: 30%, height: 50%)
      container(dy: 11cm, width: 100%, style: (text-fill: blue))
      container(dx: 17cm, dy: 1cm, width: 20%, height: 50%)
      content(size: 14pt)[#lorem(1000)]
      colfill()
      colfill()
    })
  ]
  #slide[
    #place(top + left)[
      #cetz.canvas({
        import cetz.draw: *
        rect((0, 0), (26, 15), stroke: none)
        content((12, 15), name: "conts")[#text(fill: green)[containers]]
        bezier((to: "conts", rel: (0, -10pt)), (to: (), rel: (-4, -0)), (to: (), rel: (-1, -0.5)), mark: (end: ">"), stroke: green)
        line((to: "conts", rel: (0, -10pt)), (to: (), rel: (0, -1)), mark: (end: ">"), stroke: green)
        bezier((to: "conts", rel: (0, -10pt)), (to: (), rel: (3.5, -0)), (to: (), rel: (1, -0.5)), mark: (end: ">"), stroke: green)

        content((5, 5), name: "buf")[#text(fill: blue)[buffer]]
        bezier((to: "buf", rel: (-1.2cm, 0)), (to: (), rel: (-0.5, -0.5)), (to: (), rel: (-1, 0)), mark: (end: ">"), stroke: blue)
      })
    ]

    #meander.reflow(debug: true, overflow: true, {
      import meander: *
      container(width: 25%, height: 45%)
      container(dx: 8cm, dy: 2cm, width: 30%, height: 50%)
      container(dx: 17cm, dy: 1cm, width: 20%, height: 50%)
      placed(top + left, dy: 11cm, boundary: contour.phantom(), box(fill: gray.lighten(30%), width: 100%, height: 4cm))
      container(dy: 11cm, width: 100%, style: (text-fill: blue))
      content(size: 14pt)[#lorem(1000)]
    })
  ]
]

= Applications

== Columns of unequal width

#slide[
  #set text(size: 18pt)
  ```typ
  #import "@preview/meander:0.2.4"

  #meander.reflow({
    import meander: *

    // One container per column
    container(width: 30%)
    container(width: 80%)
    container()


  })
  ```
][
  #set text(size: 5pt)
  #set par(justify: true)
  #meander.regions(overflow: true, {
    import meander: *
    container(width: 30%, height: 100% - 1pt, margin: 2mm)
    container(width: 80%, height: 100% - 1pt, margin: 2mm)
    container(height: 100% - 1pt, )
    content[#lorem(1500)]
  })
]

#slide[
  #set text(size: 18pt)
  ```typ
  #import "@preview/meander:0.2.4"

  #meander.reflow({
    import meander: *

    // One container per column
    container(width: 30%)
    container(width: 80%)
    container()

    content[#lorem(1500)]
  })
  ```
][
  #set text(size: 5pt)
  #set par(justify: true)
  #meander.reflow(overflow: true, {
    import meander: *
    container(width: 30%, margin: 2mm)
    container(width: 80%, margin: 2mm)
    container()
    content[#lorem(1500)]
  })
]

== Text flowing around (rectangular) images

#slide[
  #set text(size: 18pt)
  ```typ
  #import "@preview/meander:0.2.4"

  #meander.reflow({
    import meander: *

    // Obstacles
    placed(center + horizon)[#image(..)]
    placed(top + left)[#image(..)]
    placed(right + horizon)[#image(..)]







  })
  ```
][
  #set text(size: 5pt)
  #set par(justify: true)
  #meander.regions({
    import meander: *
    placed(center + horizon)[#image("/assets/typst-logo.png", width: 5cm)]
    placed(top + left)[#image("/assets/typst-logo.png", width: 2cm)]
    placed(right + horizon)[#image("/assets/typst-logo.png", width: 2cm)]
    //container(width: 50%)
    //container(width: 50%, align: right)
  })
]

#slide[
  #set text(size: 18pt)
  ```typ
  #import "@preview/meander:0.2.4"

  #meander.reflow({
    import meander: *

    // Obstacles
    placed(center + horizon)[#image(..)]
    placed(top + left)[#image(..)]
    placed(right + horizon)[#image(..)]

    // Containers
    container(width: 50%)
    container(width: 50%, align: right)



  })
  ```
][
  #set text(size: 5pt)
  #set par(justify: true)
  #meander.regions({
    import meander: *
    placed(center + horizon)[#image("/assets/typst-logo.png", width: 5cm)]
    placed(top + left)[#image("/assets/typst-logo.png", width: 2cm)]
    placed(right + horizon)[#image("/assets/typst-logo.png", width: 2cm)]
    container(width: 50%)
    container(width: 50%, align: right)
  })
]

#slide[
  #set text(size: 18pt)
  ```typ
  #import "@preview/meander:0.2.4"

  #meander.reflow({
    import meander: *

    // Obstacles
    placed(center + horizon)[#image(..)]
    placed(top + left)[#image(..)]
    placed(right + horizon)[#image(..)]

    // Containers
    container(width: 50%)
    container(width: 50%, align: right)

    // Content
    content[#lorem(1500)]
  })
  ```
][
  #set text(size: 5pt)
  #set par(justify: true)
  #meander.reflow(overflow: true, {
    import meander: *
    placed(center + horizon)[#image("/assets/typst-logo.png", width: 5cm)]
    placed(top + left)[#image("/assets/typst-logo.png", width: 2cm)]
    placed(right + horizon)[#image("/assets/typst-logo.png", width: 2cm)]
    container(width: 50%, margin: 2mm)
    container(width: 50%, align: right)
    content[#lorem(1500)]
  })
]


== Text flowing around (arbitrary) images

#slide[
  #set text(size: 18pt)
  ```typ
  #import "@preview/meander:0.2.4"

  #meander.reflow({
    import meander: *

    placed(center + horizon,





      image(..),
    )




  })
  ```
][
  #set text(size: 5pt)
  #set par(justify: true)
  #meander.regions(overflow: true, {
    import meander: *

    placed(center + horizon,
      block(
        radius: 50%,
        clip: true,
        image("/assets/typst-logo.png", width: 5cm),
      )
    )
    //container(width: 50% - 1mm, margin: 2mm)
    //container(width: 50%, align: right)
  })
]


#slide[
  #set text(size: 18pt)
  ```typ
  #import "@preview/meander:0.2.4"

  #meander.reflow({
    import meander: *

    placed(center + horizon,
      boundary: contour.grid(
        div: (x: 50, y: 30),
        (x,y) => calc.pow(2 * x - 1, 2) +
              calc.pow(2 * y - 1, 2) <= 1
      ),
      image(..),
    )




  })
  ```
  #place(top + left)[#box(width: 100%, height: 100%)[
    #cetz.canvas({
      import cetz.draw: *
      rect((0,0), (13,13), stroke: none)
      content((13,8), name: "resol", pad: 5mm)[#text(fill: red)[Resolution: $50 times 30$]]
      line("resol.west", (to: (), rel: (-2.5,-0.3)), stroke: red, mark: (end: ">"))
      content((12, 4), name: "eqn", pad: 5mm)[#text(fill: red)[Equation:\ $(2 x - 1)^2 + (2 y - 1)^2 <= 1$]]
      line("eqn.north-west", (to:(), rel: (-1,1)), stroke: red, mark: (end: ">"))
    })
  ]]
][
  #set text(size: 5pt)
  #set par(justify: true)
  #meander.regions(overflow: true, {
    import meander: *

    placed(center + horizon,
      boundary: contour.margin(10pt) + contour.grid(div: (x: 50, y: 30), (x,y) => calc.pow(2 * x - 1, 2) + calc.pow(2 * y - 1, 2) <= 1) + contour.margin(2pt),
      block(
        radius: 50%,
        clip: true,
        image("/assets/typst-logo.png", width: 5cm),
      )
    )
    //container(width: 50% - 1mm, margin: 2mm)
    //container(width: 50%, align: right)
  })
]

#slide[
  #set text(size: 18pt)
  ```typ
  #import "@preview/meander:0.2.4"

  #meander.reflow({
    import meander: *

    placed(center + horizon,
      boundary: contour.grid(
        div: (x: 50, y: 30),
        (x,y) => calc.pow(2 * x - 1, 2) +
              calc.pow(2 * y - 1, 2) <= 1
      ),
      image(..),
    )

    container(width: 50%)
    container(width: 50%, align: right)

  })
  ```
][
  #set text(size: 5pt)
  #set par(justify: true)
  #meander.regions(overflow: true, {
    import meander: *

    placed(center + horizon,
      boundary: contour.margin(10pt) + contour.grid(div: (x: 50, y: 30), (x,y) => calc.pow(2 * x - 1, 2) + calc.pow(2 * y - 1, 2) <= 1) + contour.margin(2pt),
      block(
        radius: 50%,
        clip: true,
        image("/assets/typst-logo.png", width: 5cm),
      )
    )
    container(width: 50% - 1mm, margin: 2mm)
    container(width: 50%, align: right)
  })
]

#slide[
  #set text(size: 18pt)
  ```typ
  #import "@preview/meander:0.2.4"

  #meander.reflow({
    import meander: *

    placed(center + horizon,
      boundary: contour.grid(
        div: (x: 50, y: 30),
        (x,y) => calc.pow(2 * x - 1, 2) +
              calc.pow(2 * y - 1, 2) <= 1
      ),
      image(..),
    )

    container(width: 50%)
    container(width: 50%, align: right)
    content[#lorem(1500)]
  })
  ```
][
  #set text(size: 5pt)
  #set par(justify: true)
  #meander.reflow(overflow: true, {
    import meander: *

    placed(center + horizon,
      boundary: contour.margin(10pt) + contour.grid(div: (x: 50, y: 30), (x,y) => calc.pow(2 * x - 1, 2) + calc.pow(2 * y - 1, 2) <= 1) + contour.margin(2pt),
      block(
        radius: 50%,
        clip: true,
        image("/assets/typst-logo.png", width: 5cm),
      )
    )
    container(width: 50% - 1mm, margin: 2mm)
    container(width: 50%, align: right)
    content[#lorem(1500)]
  })
]

=

== And more...

#slide[
  #set text(size: 5pt)
  #set par(justify: true)
  #meander.reflow(overflow: true, {
    import meander: *

    placed(center + horizon, dy: -5mm)[
      #tiaoma.qrcode("https://github.com/Vanille-N/meander.typ", options: (scale: 2.5))
    ]
    placed(bottom + right)[
      #set text(size: 25pt)
      `github:vanille-n/meander.typ`
    ]
    placed(
      center + horizon,
      boundary: contour.grid(
        div: (x: 150, y: 90),
        (x,y) => {
          let x = 5 * calc.abs(x - 0.5)
          let y = - 2.5 * (y - 0.6)
          (100 * calc.pow(x, 0.66) / (x * x + 30)) * (10 / (y * y + 6 * y + 10) - 1) + x * x + y * y >= 1
        },
      ) + contour.margin(2pt),
      block(width: 100%, height: 100%),
    )
    container(style: (text-fill: blue.darken(30%)))
    content[#lorem(1000)]
  })
]

