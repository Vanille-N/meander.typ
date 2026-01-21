#import "/src/lib.typ" as meander
#import "@preview/cetz:0.4.1"
#set par(justify: true)
//@ <doc>
#meander.reflow({
  import meander: *
  opt.debug.post-thread()
  placed(left + horizon,
    boundary:
      contour.height(
        div: 20,
        flush: horizon,
        x => (0.5, 1 - x),
      ) +
      contour.margin(5mm)
  )[
  //@ <...>
    #cetz.canvas({
      import cetz.draw: *
      merge-path(fill: yellow, {
        line((0, 0), (0, 14))
        line((), (5, 7))
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
