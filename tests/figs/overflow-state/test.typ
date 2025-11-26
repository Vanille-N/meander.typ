#import "/src/lib.typ" as meander
//@ <doc>
#let overflow = state("overflow")
#meander.reflow({
  import meander: *
  container(height: 50%)
  content[#lorem(400)]

  opt.overflow.state(overflow)
})

#set text(fill: red)
#text(size: 25pt)[
  *The following content overflows:*
]
_#{context overflow.get().styled}_
