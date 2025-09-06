#import "_preamble.typ": *
#meander.reflow(debug: true, {
  import meander: *
  placed(bottom + right, my-img-1)
  placed(center + horizon, my-img-2)
  placed(top + right, my-img-3)

  container(width: 55%)
  container(align: right, width: 40%)
  content[#lorem(600)]
})
