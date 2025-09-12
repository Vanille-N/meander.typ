#import "../_preamble.typ": *
//@ <doc>
#meander.reflow({
  import meander: *

  placed(top + left, my-img-1)
  placed(bottom + right, my-img-2)
  container()

  pagebreak()

  placed(top + right, my-img-3)
  placed(bottom + left, my-img-4)
  container(width: 45%)
  container(align: right, width: 45%)

  content[#lorem(1000)]
})
