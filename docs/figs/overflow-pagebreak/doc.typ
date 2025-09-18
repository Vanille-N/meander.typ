#import "../_preamble.typ": *
//@ <doc>
#meander.reflow(
  overflow: pagebreak, {
  import meander: *
  container(
    width: 48%,
    style:
      (text-fill: blue),
  )
  container(
    align: right,
    width: 48%,
    style:
      (text-fill: blue),
  )
  content[#lorem(1000)]
}) \
#text(fill: red)[
  #lorem(100)
]
