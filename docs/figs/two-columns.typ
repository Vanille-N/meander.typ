#import "_preamble.typ": *
//@ <doc>
#meander.reflow({
  import meander: *
  placed(bottom + right, my-img-1)
  placed(center + horizon, my-img-2)
  placed(top + right, my-img-3)

  // With two containers we can
  // emulate two columns.
  container(width: 55%)
  container(align: right, width: 40%)
  // Alternatively, a simple
  // container()
  // would also work because the first
  // container counts as occupied and
  // the second one would take all the
  // remaining space.
  content[#lorem(470)]
})
