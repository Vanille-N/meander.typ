#import "/src/lib.typ" as meander

#meander.reflow({
  import meander: *
  placed(top + left, rect(width: 5cm, height: 3cm))
  container()
  content(enum(
    enum.item[#lorem(50)],
    enum.item[#lorem(50)],
    enum.item[#lorem(50)],
    enum.item[#lorem(50)],
  ))
})
