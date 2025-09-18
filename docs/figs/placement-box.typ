#import "_preamble.typ": *
//@ <doc>
#lorem(100)

#meander.reflow(placement: box, {
  import meander: *
  placed(top + left, dy: 1cm,
          my-img-1)
  container()
  content[
    #set text(fill: red)
    #lorem(100)

    #lorem(100)
  ]
})

#lorem(100)
