#import "_preamble.typ": *
#set par(justify: true)
#set text(hyphenate: false)
//@ <doc>
#set text(hyphenate: true)
#meander.reflow({
  //@ <...>
  import meander: *
  for i in range(100) {
    container(dy: i * 1%, height: 2%)
  }
  //@ </...>
  content[
    #lorem(600)
  ]
})
