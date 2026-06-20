#import "/src/lib.typ" as meander

#let rectangle1 = rect(width: 5cm, height: 4cm, fill: orange)
#let rectangle2 = rect(width: 3cm, height: 7cm, fill: green)
#let ellipse1 = ellipse(width: 5cm, height: 9cm, fill: purple)

#set heading(numbering: "1.a.")
#set par(justify: true, first-line-indent: (amount: 1em, all: true))

//@ <doc>
#meander.reflow({
  import meander: *

  placed(top + left)[#rectangle1]
  placed(right + horizon)[#rectangle2]
  placed(
    bottom + left,
    boundary:
      contour.margin(5mm) +
      contour.horiz(div: 10, x => (0, calc.sqrt(1 - 2 * calc.pow(x - 0.5, 2)))),
  )[#ellipse1]

  container()
  content[
    = Lorem
    #par[#lorem(40)]

    = Ipsum
    #par[#lorem(200)]

    = Dolor
    #par[#lorem(210)]
  ]
})

#meander.review()
