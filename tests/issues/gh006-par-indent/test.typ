#import "/src/lib.typ" as meander

= My Title

== My Sub-title

#set par(
  justify: true,
  first-line-indent: (
    amount: 1.5em,
    all: true,
  ),
)

#lorem(30)#lorem(20)

#let my-img-1 = box(width: 3cm, height: 3cm, fill: orange)

== My other sub-title
#lorem(100)
#meander.reflow({
  import meander: *

  // As many obstacles as you want
  placed(top + left, my-img-1)

  // The container wraps around all
  container(width: 48%, margin: 5mm)
  container()

  content[
    #set text(blue)
    #par(lorem(100))  // Add explicit call to `par` here

    #set text(red)
    #par(lorem(250)) // And here.
  ]
})
