#import "/src/lib.typ" as meander

// Source: https://tex.stackexchange.com/questions/341550/how-was-this-circular-paragraph-made

#let circle-text = [
  #set par(justify: true)
  The area of a circle is a mean proportional
between any two regular and similar polygons of which one
circumscribes it and the other is isoperimetric with it.
In addition, the area of the circle is less than that of any
circumscribed polygon and greater than that of any
isoperimetric polygon. And further, of these
circumscribed polygons, the one that has the greater number of sides
has a smaller area than the one that has a lesser number;
but, on the other hand, the isoperimetric polygon that
has the greater number of sides is the larger.
[Galileo, 1638]
]

#let wrapper-text = [
  #set par(justify: true)
  #let angled(ct) = $angle.l#text[#ct]angle.r$
  It's possible to control the length of lines in a much more general
way, if simple changes to `\leftskip` and `\rightskip` aren't
flexible enough for your purposes. For example, a semicircular
hole has been cut out of the present paragraph, in order to make
room for a circular illustration that contains some of Galileo's
immortal words about circles; all of the line breaks in this paragraph
and in the circular quotation were found by TeX's line-breaking
algorithm. You can specify an essentially arbitrary paragraph shape by saying `\parshape=`#angled[number], where the #angled[number] is
a positive integer $n$, followed by $2n$ #angled[dimen] specifications.
In general, '`parshape=`$n$ $i_1$ $l_1$ $i_2$ $l_2$ $dots$ $i_n$ $l_n$'
specifies a paragraph whose first $n$ lines will have lengths
$l_1, l_2, dots, l_n$, respectively, and they will be
indented from the left margin by the respective amounts
$i_1, i_2, dots, i_n$. If the paragraph has fewer than
$n$ lines, the additional specifications will be ignored;
if it has more than $n$ lines, the specifications for line $n$ will
be repeated ad infinitum. You can cancel the effect of a previously
specified `\parshape` by saying `\parshape=0`.
]

#set page(width: 19cm, margin: 3cm, height: 16cm)

#meander.reflow({
  import meander: *
  placed(
    left, dx: 1cm,
    boundary: contour.margin(left: 1cm, right: 2mm),
    image("danger.png", width: 7mm),
  )
  placed(
    right,
    dx: 2cm,
    dy: 1.6cm,
    boundary:
        contour.margin(x: 7mm, y: 5mm)
      + contour.grid(div: 26, (x, y) => calc.pow(2 * x - 1, 2) + calc.pow(2 * y - 1, 2) <= 1)
      + contour.margin(2pt),
  )[
    #let cutout-radius = 3.15cm
    #set text(size: 9pt)
    #box(
      width: 2 * cutout-radius,
      height: 2 * cutout-radius,
    )[
      #meander.reflow(overflow: true, {
        import meander: *
        placed(
          center + horizon,
          boundary: contour.grid(div: 53, (x, y) => calc.pow(2 * x - 1, 2) + calc.pow(2 * y - 1, 2) >= 1),
          box(width: 100%, height: 100%)
        )
        container()
        content[#circle-text]
      })
    ]
  ]

  container()
  content[#wrapper-text]
})
