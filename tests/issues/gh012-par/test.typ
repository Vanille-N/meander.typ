#import "/src/lib.typ" as meander

#set page("a5", margin: 13%)
#set par(spacing: 0.65em) // Assertion failed
// #set par(spacing: 1em) // No issue

#meander.reflow({
  import meander: *
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
    #text([Start #lorem(50) end], fill: red)
    
    #text([Start #lorem(10) end], fill: blue)

    #text([Start #lorem(20) end], fill: green)

    #text([Start end], fill: black)

    #text([Start #lorem(2) end], fill: orange)

    #text([Start #lorem(12) end], fill: purple)
  ]
})

#meander.reflow({
  import meander: *
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
    #text([Start #lorem(50) end], fill: red)

    #text([Start #lorem(10) end], fill: blue)

    #text([Start #lorem(20) end], fill: green)

    #text([Start end], fill: black)

    #text([Start #lorem(2) end], fill: orange)

    #text([Start #lorem(12) end], fill: purple)
  ]
})
