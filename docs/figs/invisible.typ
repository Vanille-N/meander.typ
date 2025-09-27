#import "_preamble.typ": *
//@ <doc>
#meander.reflow({
  import meander: *
  // Obstacles
  placed(left,
    my-img-1, tags: <x>)
  placed(left, dy: 7cm,
    my-img-2, tags: <x>)
  placed(left, dy: 10cm,
    my-img-3, tags: <x>)
  placed(left, dy: 14cm,
    my-img-4, tags: <x>)
  placed(left, dy: 19cm,
    my-img-5, tags: <x>)

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
