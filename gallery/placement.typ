// @scrybe(jump import; grep preview; grep {{version}})
// @scrybe(until eof; diff docs/figs/overflow-text/doc.typ)
#import "@preview/meander:0.2.5"
#set par(justify: true)

#text(fill: green)[
  #lorem(200)
]

#meander.reflow(
  placement: box,
  overflow: text, {
  import meander: *
  container(
    width: 48%,
    height: 50%,
    style: (text-fill: blue),
  )
  container(
    width: 48%,
    height: 50%,
    align: right,
    style: (text-fill: blue),
  )

  content[#lorem(700)]
})

#text(fill: red)[
  #lorem(200)
]
