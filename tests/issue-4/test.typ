#import "/src/lib.typ" as meander

#let test-case(fun, num) = {
  lorem(num)
  fun({
    import meander: *
    placed(bottom + right, rect(fill: yellow, height: 3cm, width: 10cm))  
  })
  pagebreak(weak: true)
}

#test-case(meander.regions, 100)
#test-case(meander.reflow, 100)
#test-case(meander.regions, 300)
#test-case(meander.reflow, 300)
#test-case(meander.regions, 500)
#test-case(meander.reflow, 500)


