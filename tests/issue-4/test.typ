#import "/src/lib.typ" as meander

#let test-case(num) = {
  lorem(num)
  meander.reflow({
    import meander: *
    placed(bottom + right, rect(fill: yellow, height: 3cm, width: 10cm))  
  })
  pagebreak(weak: true)
}

#test-case(100)
#test-case(300)
#test-case(500)


