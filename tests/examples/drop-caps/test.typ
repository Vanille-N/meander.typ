#set document(
  title: [Alice in Wonderland],
  author: "Lewis Carroll"
)

#set text(size: 9pt)

#set page(
  width: 4.25in, height: 5.5in,
  margin: (x: 0.37in, top: 0.7in, bottom: 0.5in)
)

#set par(
  first-line-indent: (amount: 1em, all: true),
  spacing: 0.65em, justify: true,
)

#set heading(numbering: "I.")
#show heading: it => {
  pagebreak(weak: true)
  set text(weight: "regular")

  block(align({
    // note: outline doesn't supply numbering
    if it.numbering != none {
      smallcaps(
        text(
          counter(heading).display("i"),
          size: 2em
        )
      )
    }
    
    set text(weight: "regular", size: 2em)
    set par(justify: false, first-line-indent: 0em)
    smallcaps(text(it.body, size: 0.7em))
    
    v(0.6in)
  }, center), width: 100%, inset: (left: 0.3in, right: 0.3in))
}

= Down the Rabbit#sym.hyph.nobreak;Hole

#import "@preview/meander:0.3.1"

#meander.reflow({
    import meander: *
    // opt.debug.minimal()
    //opt.debug.post-thread()
    // opt.debug.pre-thread()
    // Obstacle in the top left
    opt.placement.spacing(below: 0.65em)
    // placed(
    //     top + left, 
    //     boundary: contour.margin(2pt) + 
    //     contour.horiz(
    //     div: 20,
    //     y => if y < 0.7 {
    //         (0, 1)
    //     } else if y < 0.84 {
    //         (0, 0.8)
    //     } else {
    //         (0, 0.6)
    //     }
    //     ),
    //     dy: -20pt, 
    //     dx: -3pt,
    //     image("dickens_drop_caps_A.png", height: 3.3cm)
    // )
    placed(
        top + left, 
        boundary: contour.margin(3pt) + 
        /*contour.horiz(
        div: 20,
        y => if y < 0.55 {
            (0, 0.42)
        } else if y < 0.64 {
            (0, 1)
        } else {
            (0, 1)
        }
        )*/
        contour.horiz(
          div: 22,
          y => if y < 0.7 {
            (0, 1)
          } else {
            (0, 1.7 * (1 - y) + 0.5)
          }
        )
        ,
        dy: -17pt,
        dx: -3pt,
        image("capital-a.png", height: 3.3cm)
    )
    
    container()

    content[#set par(first-line-indent: 0pt)
lice was beginning to get very tired of sitting by her sister on the
bank, and of having nothing to do: once or twice she had peeped into
the book her sister was reading, but it had no pictures or conversations in it, “and what is the use of a book,” thought Alice.

So she was considering in her own mind (as well as she could, for the
hot day made her feel very sleepy and stupid), whether the pleasure of
making a daisy-chain would be worth the trouble of getting up and
picking the daisies, when suddenly a White Rabbit with pink eyes ran
close by her.
    ]
})

There was nothing so _very_ remarkable in that; nor did Alice think it
so _very_ much out of the way to hear the Rabbit say to itself, “Oh
dear! Oh dear! I shall be late!” (when she thought it over afterwards,
it occurred to her that she ought to have wondered at this, but at the
time it all seemed quite natural); but when the Rabbit actually _took a
watch out of its waistcoat-pocket_, and looked at it, and then hurried
