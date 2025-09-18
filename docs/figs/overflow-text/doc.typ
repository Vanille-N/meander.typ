#import "../_preamble.typ": *
//@ <doc>
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
  content[#lorem(1000)]
})

#text(fill: red)[
  #lorem(100)
]
