#import "/src/lib.typ" as meander

#meander.reflow({
  import meander: *
  opt.debug.post-thread()

  placed(top + right, box(width: 5cm, height: 5cm, fill: green))
  container()
  content[
    / Lorem: #lorem(30)
    / Ipsum: #lorem(30)
    / Dolor: #lorem(30)
  ]
})
