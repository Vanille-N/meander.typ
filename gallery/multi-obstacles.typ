// @scrybe(jump import; grep preview; grep {{version}})
// @scrybe(until eof; diff docs/figs/multi-obstacles.typ)
#import "@preview/meander:0.2.3"

#meander.reflow({
  import meander: *

  // As many obstacles as you want
  placed(top + left, my-img-1)
  placed(top + right, my-img-2)
  placed(horizon + right, my-img-3)
  placed(bottom + left, my-img-4)
  placed(bottom + left, dx: 32%,
         my-img-5)

  // The container wraps around all
  container()
  content[
    #set par(justify: true)
    #lorem(430)
  ]
})
