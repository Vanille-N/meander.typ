#import "/src/lib.typ" as meander

#lorem(100)
#meander.reflow(placement: page, {
  import meander: *
  container()
  content[#set text(fill: red); #lorem(100)]
})
#lorem(100)

#pagebreak()

#lorem(100)
#meander.reflow(placement: box, {
  import meander: *
  container()
  content[#set text(fill: red); #lorem(100)]
})
#lorem(100)

#pagebreak()

#lorem(100)
#meander.reflow(placement: float, {
  import meander: *
  container()
  content[#set text(fill: red); #lorem(100)]
})
#lorem(100)

#pagebreak()

#lorem(200)
#meander.reflow(placement: page, {
  import meander: *
  placed(top, box(width: 100%, height: 50%, fill: red.transparentize(70%)))
})
#lorem(100)

#pagebreak()

#lorem(200)
#meander.reflow(placement: box, {
  import meander: *
  placed(top, box(width: 100%, height: 50%, fill: red.transparentize(70%)))
})
#lorem(100)

#pagebreak()

#lorem(200)
#meander.reflow(placement: float, {
  import meander: *
  placed(top, box(width: 100%, height: 50%, fill: red.transparentize(70%)))
})
#lorem(100)

