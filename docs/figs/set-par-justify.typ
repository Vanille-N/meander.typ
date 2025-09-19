#import "_preamble.typ": *
#set text(hyphenate: false)
//@ <doc>

#meander.reflow({
  //@ <...>
  import meander: *
  for i in range(100) {
    placed(right, dy: i * 1%, box(width: 0%, height: 2%))
  }
  container()
  //@ </...>
  content[
    #set par(justify: true)
    #lorem(600)
  ]

})
