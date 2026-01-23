#import "/src/lib.typ" as meander

#meander.reflow({
  import meander: *
  placed(top + left, box(width: 5cm, height: 3cm, fill: green))
  container()
  content[
    + #lorem(40)
    + #lorem(20)
    + #lorem(30)
  ]
})
