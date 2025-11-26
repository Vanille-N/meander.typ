#import "/src/lib.typ" as meander
#set par(justify: true)

#text(fill: red)[#lorem(200)]

#meander.reflow({
  import meander: *
  // Gets rid of the paragraph break between
  // the columns and the overflow.
  opt.placement.spacing(below: 0.65em)

  // This turns on some debugging information,
  // specifically showing the boundaries
  // of the boxes in green.
  opt.debug.post-thread()

  container(
    width: 48%,height: 50%,
    style: (text-fill: blue),
  )
  container(
    width: 48%, height: 50%, align: right,
    style: (text-fill: blue),
  )

  content[#lorem(700)]

  // This applies a style to the text
  // that overflows the layout.
  opt.overflow.custom(data => {
    set text(fill: orange)
    data.styled
  })
})

#text(fill: red)[#lorem(200)]
