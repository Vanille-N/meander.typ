#import "/src/lib.typ" as meander

#lorem(300)

#meander.reflow({
  import meander: *
  opt.placement.spacing(both: 0em)
  opt.debug.pre-thread()
  container()
})
