#import "/src/lib.typ" as meander

#let box1 = box(width: 7cm, height: 7cm, fill: green)
#meander.reflow({
  import meander: *

  placed(top + left, box1)
  container()
  content[#lorem(10) @stacked_borrows @tree_borrows #lorem(5)]
})

#bibliography("lit.bib")
