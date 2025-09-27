#import "_preamble.typ": *
//@ <doc>
#let overflow = state("overflow")
#meander.reflow(
  placement: box,
  overflow: overflow, {
  import meander: *
  container(height: 50%)
  content[#lorem(400)]
})

#set text(fill: red)
#text(size: 25pt)[
  *The following content overflows:*
]
_#{context overflow.get().styled}_
