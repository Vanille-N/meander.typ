#import "_preamble.typ": *
//@ <doc>
#meander.reflow({
  import meander: *
  placed(center + horizon)[#circle(radius: 3cm, fill: yellow)]

  container(width: 48%)
  container(align: right, width: 48%)

  content[
    #set par(justify: true)
    #lorem(590)
  ]
})
