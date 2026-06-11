#import "/src/lib.typ" as meander

#let current-par = par(first-line-indent: (amount:2em, all: true), justify: true)[#lorem(200)]

#meander.reflow({
    meander.container(width: 49%)
    meander.container()
    meander.pagebreak()
   meander.container(width: 49%)
    meander.container()
    meander.content({
        for i in range(4){current-par}
    })
})
