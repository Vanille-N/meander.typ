#import "_preamble.typ": *
#set text(hyphenate: false)
//@ <doc>
#meander.reflow({
  //@ <...>
  import meander: *
  for i in range(100) {
    container(dy: i * 1%, height: 2%)
  }
  //@ </...>
  content[
    #par(justify: true)[
      #lorem(600)
    ]
  ]
})
