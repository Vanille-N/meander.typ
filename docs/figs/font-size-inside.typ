#import "_preamble.typ": *
//@ <doc>
#meander.reflow({
  //@ <...>
  import meander: *
  container()
  placed(
    left,
    boundary: contour.horiz(div: 100, _ => (0, 1)),
    line(end: (0%, 100%), stroke: white)
  )
  //@ </...>
  content[
    #set text(size: 30pt)
    #lorem(80)
  ]
})
