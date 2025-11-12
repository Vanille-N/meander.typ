#import "../_preamble.typ": *
//@ <doc>

//#set block(spacing: 0em)
// First half-page
#meander.reflow({
  import meander: *
  opt.debug.pre-thread()
  placed(top + left, my-img-1)
  container(height: 45%)
})

// Overflows on the second page
#meander.reflow({
  import meander: *
  opt.debug.pre-thread()
  placed(bottom + center, my-img-2)
  container(align: bottom, height: 50%, width: 48%)
  container(align: bottom + right,
            height: 50%, width: 48%)

  pagebreak()

  placed(top + center, my-img-3)
  placed(horizon, my-img-4)
  container(height: 50%, width: 48%)
  container(align: right, height: 50%, width: 48%)
})

// Takes over for the last half-page
#meander.reflow({
  import meander: *
  opt.debug.pre-thread()
  // This obstacle is already placed by the previous
  // invocation. We just restate it without displaying
  // it so that it appears only once yet still gets
  // counted as an obstacle for both invocations.
  placed(display: false, horizon, my-img-4)
  container(align: bottom, height: 45%)
})

