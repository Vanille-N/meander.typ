#import "/src/lib.typ" as meander

#show: align.with(center)

#meander.reflow({
  import meander: *
  placed(top + left)[#rect(width: 3cm, height: 3cm, fill: yellow)]
  container(width: 40%)
  content[#lorem(200)]
})
