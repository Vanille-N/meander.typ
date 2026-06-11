#import "/src/lib.typ" as meander

#let current-par = par(hanging-indent: 2em, justify: true)[#lorem(200)]

#meander.reflow({
  meander.placed(center + horizon, box(width: 5cm, height: 5cm, fill: red))
  meander.container(width: 49%)
  meander.container()
  meander.pagebreak()
  meander.container(width: 49%)
  meander.container()
  meander.content({
    for i in range(4) { current-par }
  })
})
