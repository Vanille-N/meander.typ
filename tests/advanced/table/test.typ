#import "/src/lib.typ" as meander

#meander.reflow({
  import meander: *

  placed(top + right)[#box(fill: orange, width: 5cm, height: 5cm)]
  container()
  content[
    #lorem(55)
    #table(columns: 4, ..{ for i in range(12) { ([#i],) } })
  ]
})
