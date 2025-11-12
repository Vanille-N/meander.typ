#import "/src/lib.typ" as meander

#let test-case(debug, num) = {
  lorem(num)
  meander.reflow(debug: debug, {
    import meander: *
    placed(bottom + right, rect(fill: yellow, height: 3cm, width: 10cm))  
  })
  pagebreak(weak: true)
}

#test-case(meander.debug.pre-thread, 100)
#test-case(meander.debug.release, 100)
#test-case(meander.debug.pre-thread, 300)
#test-case(meander.debug.release, 300)
#test-case(meander.debug.pre-thread, 500)
#test-case(meander.debug.release, 500)


