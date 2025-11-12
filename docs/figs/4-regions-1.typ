#import "_preamble.typ": *
//@ <doc>
#meander.reflow({
  import meander: *
  opt.debug.pre-thread()
  placed(center + horizon,
    line(end: (100%, 0%)))
  placed(center + horizon,
    line(end: (0%, 100%)))

  container(width: 100%)

})
//@ </doc>
#place(center + horizon, dx: -25%, dy: -25%)[#text(size: 90pt)[*1*]]
#place(center + horizon, dx: 25%, dy: -25%)[#text(size: 90pt)[*2*]]
#place(center + horizon, dx: -25%, dy: 25%)[#text(size: 90pt)[*3*]]
#place(center + horizon, dx: 25%, dy: 25%)[#text(size: 90pt)[*4*]]
