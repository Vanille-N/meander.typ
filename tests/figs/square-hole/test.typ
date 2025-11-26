#import "/src/lib.typ" as meander
//@ <doc>
#meander.reflow({
  import meander: *
  placed(center + horizon)[
    #circle(radius: 3cm, fill: yellow)
  ]

  container(width: 50% - 3mm, margin: 6mm)
  container()

  content[
    #set par(justify: true)
    #lorem(590)
  ]
})
