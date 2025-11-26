#import "/src/lib.typ" as meander
//@ <doc>
#meander.reflow({
  import meander: *
  container(
    height: 70%, width: 48%,
    style: (text-fill: blue),
  )
  container(
    align: right,
    height: 70%, width: 48%,
    style: (text-fill: blue),
  )
  content[#lorem(1000)]
  opt.overflow.pagebreak()
})
#text(fill: red)[#lorem(100)]
