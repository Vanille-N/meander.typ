#import "/src/lib.typ" as meander
//@ <doc>
#meander.reflow({
  import meander: *
  container()
  content[#lorem(1000)]
  opt.overflow.alert()
})
