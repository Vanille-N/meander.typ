#import "_preamble.typ": *
#import "@preview/cetz:0.4.1"

#set par(justify: true)
//@ <doc>
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
      contour.margin(5mm)
  )[
  //@ <...>
    #cetz.canvas({
      import cetz.draw: *
      merge-path(fill: yellow, {
        line((0, 0), (12, 0))
        line((), (12, 8))
        line((), (0, 0))
      })
    })
  //@ </...> inline
  ]
  //@ <...>
  container()
  content[#lorem(700)]
  //@ </...>
})
