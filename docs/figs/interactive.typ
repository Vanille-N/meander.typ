#import "_preamble.typ": *
#set page(width: 11cm)
//@ <doc>
#meander.reflow({
  import meander: *
  let placed-below(
    tag, img, tags: (),
  ) = {
    placed(
      // fetch position
      // of previous elem.
      query.position(tag, at: bottom + left),
      img, tags: tags,
      // correct for margins
      dx: 5pt, dy: -5pt,
    )
  }
  // Obstacles
  placed(left, my-img-1, tags: (<x>, <a1>))
  placed-below(<a1>, my-img-2, tags: (<x>, <a2>))
  placed-below(<a2>, my-img-3, tags: (<x>, <a3>))
  placed-below(<a3>, my-img-4, tags: (<x>, <a4>))
  placed-below(<a4>, my-img-5, tags: <x>)

  // Occupies the complement of
  // the obstacles, but has
  // no content.
  container(margin: 6pt)
  colfill()

  // The actual content occupies
  // the complement of the
  // complement of the obstacles.
  container(invisible: <x>)
  content[
    #set par(justify: true)
    #lorem(225)
  ]
})
