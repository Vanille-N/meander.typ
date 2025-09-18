#import "_preamble.typ": *
//@ <doc>
#set text(size: 30pt)
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

    #lorem(80)
  ]
})
