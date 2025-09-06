#import "_preamble.typ": *
//@ <doc>
#meander.reflow({
  import meander: *
  // Obstacle in the top left
  placed(top + left, my-img-1)

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

