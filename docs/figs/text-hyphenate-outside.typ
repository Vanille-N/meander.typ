#import "_preamble.typ": *
#set par(justify: true)
#set text(size: 28pt, hyphenate: false)
//@ <doc>
#set text(hyphenate: true)
#meander.reflow({
  //@ <...>
  import meander: *
  for i in range(100) {
    container(dy: i * 1%, height: 5%)
  }
  //@ </...>
  content[

    #lorem(100)
  ]
})
