#import "/src/lib.typ" as meander

#set page("a6")

#meander.reflow({
  import meander: *
  opt.debug.post-thread()
  placed(top + left, rect(height: 3cm, width: 3cm))
  placed(horizon + right, rect(height: 3cm, width: 3cm))
  placed(bottom + left, rect(height: 3cm, width: 3cm))
  container()
  content[
    + #lorem(15)
    + #lorem(15)
    + #lorem(15)
    + #lorem(15)
    + #lorem(15)
    + #lorem(15)
  ]
})
