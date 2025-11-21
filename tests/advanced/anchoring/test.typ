#import "/src/lib.typ" as meander

#let thing(fill) = box(width: 5cm, height: 3cm, fill: fill)

#meander.reflow({
  import meander: *
  placed(center + horizon, anchor: top + left, thing(blue))
  placed(center + horizon, anchor: top + right, thing(red))
  placed(center + horizon, anchor: bottom + left, thing(green))
  placed(center + horizon, anchor: bottom + right, thing(yellow))
  placed(center + horizon, anchor: center + horizon, thing(black))
})

#pagebreak()

#meander.reflow({
  import meander: *
  placed(center + horizon, anchor: top, thing(blue))
  placed(center + horizon, anchor: bottom, thing(red))
  placed(center + horizon, anchor: left, thing(green))
  placed(center + horizon, anchor: right, thing(yellow)) 
})
