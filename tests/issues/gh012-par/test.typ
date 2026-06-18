#import "/src/lib.typ" as meander

#set page("a5", margin: 13%)
#set par(first-line-indent: (amount: 1em, all: true))

#meander.reflow({
  import meander: *
  //opt.debug.post-thread()
  placed(
    bottom + right, dx: 10%, dy: 5%,
    boundary:
      contour.margin(5pt) +
      contour.horiz(
        div: 20,
        y => (0.5 - calc.sqrt(0.25 - calc.pow((y - 0.5), 2)), 1),
      ),
    ellipse(width: 75%, height: 96%),
  )
  container()
  content[
    Automatic Indentation with `#par`:

    #set text(red)
    #par(lorem(50))

    #set text(blue)
    #par(lorem(11))

    #text(green)[#par(lorem(20))]

    #par(text(black, lorem(2)))

    #par({
      set text(orange)
      lorem(2)
    })

    #set text(purple)
    #par(lorem(12))
  ]
})

