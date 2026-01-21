#import "/src/lib.typ" as meander
#import "@preview/cetz:0.4.1"
#set par(justify: true)
//@ <doc>
#meander.reflow({
  import meander: *
  opt.debug.post-thread()
  placed(top,
    boundary:
      contour.vert(
        div: 25,
        x => if x <= 0.5 {
          (0, 2 * (0.5 - x))
        } else {
          (0, 2 * (x - 0.5))
        },
      ) +
      contour.margin(5mm)
  )[
  //@ <...>
    #cetz.canvas({
      import cetz.draw: *
      merge-path(fill: yellow, {
        line((0, 0), (8, 0))
        line((), (8, -5))
        line((), (0, 0))
        line((), (-8, 0))
        line((), (-8, -5))
        line((), (0, 0))
      })
    })
  //@ </...> inline
  ]
  //@ <...>
  container()
  content[#lorem(590)]
  //@ </...>
})
