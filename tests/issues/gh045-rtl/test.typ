#import "/src/lib.typ" as meander

#set page(width: 4in, height: 3in, margin: 0.3in)
#set text(dir: rtl)

// Workaround:
// #set place(top + left)

#meander.reflow({
  import meander: *
  placed(bottom + left, boundary: contour.margin(right: 8pt, top: 6pt), rect(
    width: 1.2in,
    height: 1.4in,
    fill: gray,
  ))
  container()
  content(lorem(50))
})
