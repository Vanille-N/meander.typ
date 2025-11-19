#import "/src/lib.typ" as meander

#lorem(100)
#meander.reflow({
  import meander: *
  opt.placement.no-outset()
  container()
  content[#set text(fill: red); #lorem(100)]
  opt.placement.no-spacing()
})
#lorem(100)

#pagebreak()

#lorem(100)
#meander.reflow({
  import meander: *
  container()
  content[#set text(fill: red); #lorem(100)]
})
#lorem(100)

#pagebreak()

/*
#lorem(100)
#meander.reflow({
  import meander: *
  opt.placement.full-page()
  container()
  content[#set text(fill: red); #lorem(100)]
})
#lorem(100)
*/

#pagebreak()

#lorem(200)
#meander.reflow({
  import meander: *
  opt.placement.no-outset()
  placed(top, box(width: 100%, height: 50%, fill: red.transparentize(70%)))
  opt.placement.no-spacing()
})
#lorem(100)

#pagebreak()

#lorem(200)
#meander.reflow({
  import meander: *
  placed(top, box(width: 100%, height: 50%, fill: red.transparentize(70%)))
})
#lorem(100)

#pagebreak()

/*
#lorem(200)
#meander.reflow({
  import meander: *
  opt.placement.full-page()
  placed(top, box(width: 100%, height: 50%, fill: red.transparentize(70%)))
})
#lorem(100)
*/

