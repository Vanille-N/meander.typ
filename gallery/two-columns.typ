// @scrybe(jump import; grep preview; grep {{version}})
// @scrybe(until eof; diff docs/figs/two-columns.typ)
#import "@preview/meander:0.2.1"

#meander.reflow({
  import meander: *

  placed(bottom + right, my-img-1)
  placed(center + horizon, my-img-2)
  placed(top + right, my-img-3)

  // With two containers we can
  // emulate two columns.
  container(width: 55%)
  container(align: right, width: 40%)
  content[#lorem(470)]
})
