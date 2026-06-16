#import "/src/lib.typ" as meander

#meander.reflow({
  import meander: *
  opt.debug.post-thread()
  container(align: left,width: 50%, margin: 2.5mm)
  container(align: right, width: 50%, margin: 2.5mm)
  content[

    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer elementum vestibulum condimentum. Vestibulum placerat justo justo. Vivamus tempus felis diam, ac rhoncus neque suscipit sit amet. Ut at felis eu mauris eleifend egestas. Phasellus mollis rutrum neque, quis egestas purus consectetur at. Proin diam diam, blandit nec tincidunt ac, consequat a quam. Ut hendrerit ullamcorper 

    #std.colbreak()

    Suspendisse potenti. Aliquam libero lectus, efficitur ac ipsum sed, tristique aliquam orci. Integer purus lacus, pulvinar in scelerisque ut, consectetur quis ex. Praesent lobortis metus in nibh pulvinar, in sagittis sem consequat. Vestibulum scelerisque nec dui et luctus. 
  ]
})
