#import "_preamble.typ": *
#meander.reflow({
  import meander: *
  opt.debug.pre-thread()
  placed(center + horizon)[#circle(radius: 3cm, fill: yellow)]

  container(width: 50% - 3mm, margin: 6mm)
  container()

  content[
    #set par(justify: true)
    #lorem(600)
  ]
})
