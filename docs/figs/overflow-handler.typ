#import "_preamble.typ": *
//@ <doc>
#meander.reflow(
  placement: box,
  overflow: tt => [
    #set text(fill: red, size: 25pt)
    *The following content overflows:*
    _#{tt.styled}_
  ], {
  import meander: *
  container(height: 50%)
  content[#lorem(400)]
})

