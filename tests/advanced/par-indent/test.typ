#import "/src/lib.typ" as meander

#let current-par = par(first-line-indent: (amount:2em, all: true), justify: true)[#lorem(200)]

#meander.reflow({
  import meander: *

  placed(center + horizon, box(width: 5cm, height: 5cm, fill:red))

  container(width: 49%)
  container()
  pagebreak()
  container(width: 49%)
  container()

  content({
    for i in range(4){ current-par }
  })
})

#pagebreak()

#let current-par = par(hanging-indent: 2em, justify: true)[#lorem(200)]

#meander.reflow({
  import meander: *

  placed(center + horizon, box(width: 5cm, height: 5cm, fill: red))

  container(width: 49%)
  container()
  pagebreak()
  container(width: 49%)
  container()

  content({
    for i in range(4) { current-par }
  })
})

#pagebreak()

#[
  #set par(first-line-indent: (amount: 2em, all: true), justify: true)
  #let current-par = par(lorem(200))

  #meander.reflow({
    import meander: *

    placed(center + horizon, box(width: 5cm, height: 5cm, fill:red))

    container(width: 49%)
    container()
    pagebreak()
    container(width: 49%)
    container()

    content({
      for i in range(4){ current-par }
    })
  })
]

#pagebreak()

#[
  #set par(hanging-indent: 2em, justify: true)
  #let current-par = par(lorem(200))

  #meander.reflow({
    import meander: *

    placed(center + horizon, box(width: 5cm, height: 5cm, fill: red))

    container(width: 49%)
    container()
    pagebreak()
    container(width: 49%)
    container()

    content({
      for i in range(4) { current-par }
    })
  })
]


