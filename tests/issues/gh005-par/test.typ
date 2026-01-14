#import "/src/lib.typ" as meander

#let pg(height) = {
  meander.reflow({
    import meander: *
    opt.debug.post-thread()

    placed(
      top + right,
      boundary: contour.margin(left: .5cm, bottom: .4cm),
      rect(width: 1cm, height: height)
    )

    container()

    content[#lorem(60)]
  })
}

#show: columns.with(3)
#pg(5cm)
#colbreak()
#pg(5.10cm)
#colbreak()
#pg(5.2cm)

#colbreak()
#pg(5.1cm)
#colbreak()
#pg(5.15cm)
#colbreak()
#pg(5.2cm)


