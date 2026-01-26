#import "/src/lib.typ" as meander

#let label(i) = text(size: 30pt)[#raw(str(i))]
#let img(width, height, fill, num) = {
  box(
    width: width,
    height: height,
    radius: 2mm,
    fill: fill.darken(-70%)
  )[
    #align(center + horizon)[#label(num)]
  ]
}

#let my-img-1 = img(7cm, 7cm, orange, 1)
#let my-img-2 = img(5cm, 3cm, blue, 2)
#let my-img-3 = img(8cm, 4cm, green, 3)
#let my-img-4 = img(5cm, 5cm, red, 4)
#let my-img-5 = img(4cm, 3cm, yellow, 5)
#set page(width: 11cm)
//@ <doc>
#meander.reflow({
  import meander: *
  let placed-below(
    tag, img, tags: (),
  ) = {
    callback(
      // fetch position of previous element.
      env: (pos: query.position(tag, at: bottom + left)),
      env => {
        placed(
          env.pos,
          img, tags: tags,
          // correct for margins
          dx: 5pt, dy: -5pt,
        )
      }
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
