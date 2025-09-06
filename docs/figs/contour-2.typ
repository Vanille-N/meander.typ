#import "_preamble.typ": *
#import "@preview/cetz:0.4.1"
#set par(justify: true)
//@ <doc>
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
      contour.margin(5mm)
  )[
  //@ <...>
    #cetz.canvas({
      import cetz.draw: *
      merge-path(fill: yellow, {
        line((0, 0), (10, 0))
        line((), (5, 12))
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
