#import "/src/lib.typ" as meander

#lorem(100)
#meander.reflow({
  import meander: *
  opt.placement.spacing(both: 0em)
  opt.placement.phantom()
  container()
  content[#set text(fill: red); #lorem(100)]
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
  opt.placement.spacing(both: 0em)
  opt.placement.phantom()
  placed(top, box(width: 100%, height: 50%, fill: red.transparentize(70%)))
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

