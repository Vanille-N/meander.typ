#import "_preamble.typ": *
#meander.reflow({
  import meander: *
  opt.debug.minimal()
  placed(bottom + right, my-img-1)
  placed(center + horizon, my-img-2)
  placed(top + right, my-img-3)

  container(width: 60%)
  container(align: right, width: 35%)
})
