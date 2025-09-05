#import "/src/lib.typ" as meander

#set page(
  height: 15cm,
  margin: 0pt,
  background: box(fill: rgb("ded7d1"), width: 100%, height: 100%),
)

#set par(justify: true)

#meander.reflow({
  import meander: *
  placed(
    bottom + left,
    boundary: contour.ascii-art(```
    ##L        
    ###L,      
    #####      
    #####[     
    ######_    
    #######    
    ########   
    ########   
    ```)
  )[#image("image.png")]
  container()
  content[#lorem(600)]
})
