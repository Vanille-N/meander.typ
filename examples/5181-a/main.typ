#import "/src/lib.typ" as meander

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

#context[#meander.reflow[
  // Define the boundaries of the image
  #meander.redraw(
    div: 45,
    flush: right,
    width: y => {
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
  )[#place(right)[
    #image("image.png")
  ]]

  // Place the text
  #meander.container(right, dy: 1cm, width: 80%)

  #set par(justify: true)
  #paragraph
]]
