#import "/src/lib.typ" as meander

#let column(n-pages, last-page-height: 50%, placement: (), content) = {
meander.reflow({
  for page in range(n-pages) {
      meander.container(
        width: 50% - 3mm,
        margin: 6.83mm,
      )
      meander.container(
      )
      meander.pagebreak()
        
  }
  meander.content[
    #content
  ]
})
}
#set par(justify: true)
#let element  = [
= Titre 1
#lorem(121)
== titre 2
#lorem(121)
=== titre 3 
#lorem(121)
]

#column(3)[#for i in range(4){
element
}]
