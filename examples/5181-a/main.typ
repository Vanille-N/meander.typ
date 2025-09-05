#import "/src/lib.typ" as meander

#set page(width: 16.5cm, height: 16cm)

#let paragraph = [
  `seminar.sty` is a LaTeX style for typesetting slides or
  transparencies, and accompanying notes. Here are some of its special features:
  It is compatible with AmS-LaTeX, and you can use PostScript and AmS
  fonts. Slides can be landscape and portrait. There is support for color and
  frames. The magnification can be changed easily.
  Overlays can be produced from a single slide environment.
  Accompanying notes, such as the text of a presentation, can be put
  outside the slide environments. The slides, notes or both together
  can then be typeset in a variety of formats.
]

#meander.reflow({
  import meander: *
  // Define the boundaries of the image
  placed(right,
    image("image.png"),
    boundary: contour.width(
      div: 45,
      flush: right,
      y => {
        let right = 0
        let width = if y <= 0.65 {
          0.1 + 1 - (y * 1.3)
        } else if y <= 0.9 {
          0.5
        } else {
          1.4 - y
        }
        (right, width)
      }
    ),
  )

  // Place the text
  container(dy: 1cm, height: 100% - 1cm)

  content[
    #set par(justify: true)
    #paragraph
  ]
})
