#import "_preamble.typ": *
#meander.regions({
  import meander: *
  placed(center + horizon,
    boundary: contour.margin(1cm) + contour.grid(div: 25, (x, y) => {
      calc.pow(2 * x - 1, 2) + calc.pow(2 * y - 1, 2) <= 1
    }) + contour.margin(2pt)
  )[#circle(radius: 3cm, fill: yellow)]

  container(width: 48%)
  container(align: right, width: 48%)

  content[
    #set par(justify: true)
    #lorem(600)
  ]
})
