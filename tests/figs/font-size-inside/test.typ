#import "/src/lib.typ" as meander
//@ <doc>
#meander.reflow({
  //@ <...>
  import meander: *
  placed(
    left,
    boundary: contour.horiz(div: 100, _ => (0, 1)),
    line(end: (1%, 100%), stroke: white)
  )
  container()
  //@ </...>
  content[
    #set text(size: 30pt)
    #lorem(80)
  ]
})
