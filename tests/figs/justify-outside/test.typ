#import "/src/lib.typ" as meander
#set text(hyphenate: false)
//@ <doc>
#set par(justify: true)
#meander.reflow({
  //@ <...>
  import meander: *
  for i in range(100) {
    placed(right, dy: i * 1%, box(width: 0%, height: 2%))
  }
  container()
  //@ </...>
  content[

    #lorem(600)
  ]

})
