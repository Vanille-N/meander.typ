#import "_preamble.typ": *
#set par(justify: true)
#set text(size: 28pt, hyphenate: false)
//@ <doc>
#set text(hyphenate: true)
#meander.reflow({
  //@ <...>
  import meander: *
  for i in range(100) {
    placed(right, dy: i * 1%, box(height: 5%, width: 1%))
  }
  container()
  //@ </...>
  content[

    #lorem(70)
  ]
})
