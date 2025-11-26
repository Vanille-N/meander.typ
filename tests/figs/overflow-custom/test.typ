#import "/src/lib.typ" as meander
//@ <doc>
#meander.reflow({
  import meander: *
  container(height: 50%)
  content[#lorem(400)]

  opt.overflow.custom(tt => [
    #set text(fill: red)
    #text(size: 25pt)[
      *The following content overflows:*
    ]
    _#{tt.styled}_
  ])
})

