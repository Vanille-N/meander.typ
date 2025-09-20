#import "_preamble.typ": *

#set page(height: 17cm, width: 15cm)

#let image = text(size: 50pt)[
  ```
  #   /   \

  [   ]   ^   _

  ,   .   '   `

  J   F   L   7
  ```
]

//@ <doc>
#meander.reflow(debug: true, {
  import meander: *
  placed(top + left,
    boundary: contour.margin(6mm) +
      contour.ascii-art(
        ```
        # / \

        [ ] ^ _

        , . ' `

        J F L 7
        ```
      )
  )[#image]
})

