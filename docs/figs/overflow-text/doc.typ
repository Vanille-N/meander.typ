#import "../_preamble.typ": *
#set par(justify: true)
//@ <doc>
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
    style:
      (text-fill: blue),
  )
  container(
    width: 48%,
    height: 50%,
    align: right,
    style:
      (text-fill: blue))
  content[#lorem(700)]
})

#text(fill: red)[
  #lorem(200)
]
