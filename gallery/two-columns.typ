// @scrybe(jump import; grep preview; grep {{version}})
// @scrybe(until eof; diff docs/figs/two-columns.typ)
#import "@preview/meander:0.2.5"

#meander.reflow({
  import meander: *

  placed(bottom + right, my-img-1)
  placed(center + horizon, my-img-2)
  placed(top + right, my-img-3)

  // With two containers we can
  // emulate two columns.

  // The first container takes 60%
  // of the page width.
  container(width: 60%, margin: 5mm)
  // The second container automatically
  // fills the remaining space.
  container()
  content[#lorem(470)]
})
