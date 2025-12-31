#import "/src/lib.typ" as meander

#set page(paper: "a4", columns: 1)

#place(
    top + center,
    float: true,
    scope: "parent",
    text(1.4em, weight: "bold")[
        #lorem(5)
    ]
)

#place(
    top + center,
    float: true,
    scope: "parent",
    text[
        #lorem(30)
    ],
)

// ============================================================== 

= Introduction

#lorem(150)

= Observations

#lorem(80)

#lorem(80)

#lorem(80)

// #lorem(28) // this would work!
#lorem(29)

== Infantry
#meander.reflow({
    import meander: *

    placed(
        top + left,
        image("example.svg", width: 8mm, height: 8mm)
    )
    container()
    content[
        #set par(justify: true)
        #lorem(20)
    ]
})
