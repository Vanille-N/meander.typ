#import "/src/lib.typ" as meander
#set par(justify: true)
// <doc>
#meander.reflow({
  import meander: *
  container(width: 70%)
  container()
  content[#lorem(2000)]

  opt.overflow.repeat()
})
// </doc>
