#import "/src/lib.typ" as meander
#set par(justify: true)
//@ <doc>
#text(fill: green)[#lorem(200)]
#meander.reflow({
  import meander: *
  opt.placement.spacing(below: 0.65em)
  container(width: 48%, height: 50%, style: (text-fill: blue))
  container(width: 48%, height: 50%, align: right, style: (text-fill: blue))
  content[#lorem(700)]
})
#text(fill: red)[#lorem(200)]
