#import "/src/lib.typ" as meander

#meander.reflow({
  import meander: *
  container(width: 60%)
  container()
  content[#lorem(2000)]
  opt.overflow.repeat()
})
