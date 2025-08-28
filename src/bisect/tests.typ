#import "default.typ": *

#let test-case(ct) = {
  let dims = (width: 5cm, height: 5cm)
  context {
    [#{(ct,)}]
    let (fit, rest) = fill-box(dims, ct)
    table(
      columns: 2,
      box(..dims, stroke: green)[#fit],
      box(stroke: orange)[#rest],
    )
  }
}

#test-case[]

#test-case[ ]

#test-case[#h(1em)]

#test-case[

]

#test-case[#lorem(50)]

#test-case(text(fill: red)[#lorem(50)])

#test-case[
  #lorem(50)
]

#test-case[
  #for i in range(8) {
    text(size: 7pt)[#lorem(5) ]
    text(size: 11pt)[#lorem(5) ]
  }
]

#test-case[
  #lorem(10) #lorem(10) #lorem(10) #lorem(10) #lorem(10) #lorem(10)
]

#test-case[
  *#lorem(50)*
]

#test-case[
  _#lorem(50)_
]

#test-case[
  = #lorem(30)
]

#test-case[
  - #lorem(10)
  - #lorem(50)
  - #lorem(10)
]

#test-case[
  + #lorem(10)
  + #lorem(50)
  + #lorem(10)
]

#test-case[
  - 1 #lorem(5)
  - 2 #lorem(10)
  - 3 #lorem(10)
  - 4 #lorem(10)
  - 5 #lorem(10)
  - 6 #lorem(10)
]

#test-case[
  + 1 #lorem(5)
  + 2 #lorem(10)
  + 3 #lorem(10)
  + 4 #lorem(10)
    #lorem(10)
  + 5 #lorem(10)
]

#test-case[
  - #lorem(20)
  - #lorem(10)
    - #lorem(10)
    - #lorem(3)
  - #lorem(3)
]

// TODO: see if I can fix the numbering pattern
#test-case[
  + #lorem(10)
  + #lorem(10)
  + #lorem(10)
    + #lorem(10)
    + #lorem(10)
  + #lorem(10)
]

#test-case[
  1. #lorem(20)
  2. #lorem(20)
  3. #lorem(20)
]

