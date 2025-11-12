#import "/src/lib.typ" as meander

#lorem(300)

#meander.reflow({
  import meander: *
  opt.debug.pre-thread()
  container()
})
