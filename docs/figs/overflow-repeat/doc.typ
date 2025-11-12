#import "../_preamble.typ": *
#set par(justify: true)
// <doc>
#meander.reflow(
  overflow: repeat,
{
  import meander: *
  container(width: 70%)
  container()
  content[#lorem(2000)]
})
// </doc>
