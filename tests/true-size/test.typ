#import "/src/lib.typ" as meander

#lorem(300)

#meander.reflow(debug: meander.debug.pre-thread, {
  import meander: *
  container()
})
