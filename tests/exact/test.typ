#import "/src/lib.typ" as meander

#let compare(ct) = {
  place(top + left)[
    #box(width: 5cm, stroke: blue)[
      #set text(fill: blue)
      #ct
    ]
  ]
  meander.reflow(debug: true, {
    import meander: *
    placed(
      top + left,
      boundary: contour.horiz(div: 25, y => (0,0)),
      box(width: 1cm, height: 100%),
    )
    container(width: 5cm)
    content[
      #set text(fill: red)
      #ct
    ]
  })
}

#set text(hyphenate: true)
#set page(columns: 2)

#compare[
  #for _ in range(45) [
    - #lorem(5)
  ]
]

#colbreak()

#compare[
  #for _ in range(10) [
    - #lorem(14)
  ]
]

#colbreak()

#compare[
  #for _ in range(45) [
    + #lorem(4)
  ]
]

#colbreak()

#compare[
  #for _ in range(10) [
    + #lorem(14)
  ]
]

#pagebreak()

#set text(size: 30pt)

// TODO: There is a blocking bug here with the proper segmentation of list.item and enum.item
/*
#compare[
  #for _ in range(15) [
    - #lorem(1)
  ]
]

#colbreak()

#compare[
  #for _ in range(2) [
    - #lorem(9)
  ]
]

#colbreak()

#compare[
  #for _ in range(15) [
    + #lorem(1)
  ]
]

#colbreak()

#compare[
  #for _ in range(2) [
    + #lorem(9)
  ]
]

