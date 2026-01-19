#import "/src/lib.typ" as meander
#meander.reflow({
  import meander: *
  // Obstacle in the top left

  placed(top + left, dx: 5pt, dy: 5pt, display: false, rect(width: 60pt, height: 40pt, stroke: 1pt + red))

  // Full-page container
  container()

  // Flowing content
  content[
    _#lorem(60)_
    #[
      #set par(justify: true)
      #lorem(300)
    ]
    #lorem(200)
  ]
})

