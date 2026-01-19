#import "/src/lib.typ" as meander

#lorem(300)

#meander.reflow({
  import meander: *
  opt.placement.spacing(both: 0em)
  opt.debug.pre-thread()
  container()
})

#pagebreak()

#lorem(300)

#meander.reflow({
  import meander: *
  opt.placement.spacing(both: 0em)
  opt.debug.pre-thread()
  callback(size: query.parent-size(), env => {
    placed(right)[
      #rect(width: 50%, height: env.size.height)
    ]
  })
})
