#import "/src/lib.typ" as meander

#set par(justify: true)
#set text(size: 19.5pt)

//@ <doc>
#let indent = (first-line-indent: (amount: 5em, all: true))
#set par(..indent)

#meander.reflow({
  //@ <...>
  import meander: *

  for i in range(4) {
    placed(right, dy: i * 25%, box(width: 0%, height: 24%))
  }
  container()
  //@ </...>
  content[
    #set text(fill: red)
    #par[
      #lorem(60)
    ]
    //@ <...>
    #set text(fill: blue)
    #par[
      #lorem(60)
    ]
    #set text(fill: green)
    #par[
      #lorem(60)
    ]
    //@ </...>
  ]
})

