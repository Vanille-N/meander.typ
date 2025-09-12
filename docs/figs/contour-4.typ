#import "_preamble.typ": *
#import "@preview/cetz:0.4.1"
#set par(justify: true)
//@ <doc>
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
      contour.margin(5mm)
  )[
  //@ <...>
    #cetz.canvas({
      import cetz.draw: *
      merge-path(fill: yellow, {
        line((0, 0), (0, 6))
        line((), (5, 6))
        line((), (0, 0))
        line((), (0, -6))
        line((), (5, -6))
        line((), (0, 0))
      })
    })
  //@ </...> inline
  ]
  //@ <...>
  container()
  content[#lorem(600)]
  //@ </...>
})
