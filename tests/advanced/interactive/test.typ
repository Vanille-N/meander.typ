#import "/src/lib.typ" as meander

#let label(i) = text(size: 30pt)[#raw(str(i))]
#let img(width, height, fill, num) = {
  box(
    width: width,
    height: height,
    radius: 2mm,
    fill: fill.transparentize(70%)
  )[
    #align(center + horizon)[#label(num)]
  ]
}

#meander.reflow({
  import meander: *
  opt.debug.post-thread()
  placed(top + left, img(5cm, 5cm, blue, 1), tags: <A>)
  container(invisible: <A>)
  container()

  content[#lorem(50)]
  colbreak()
  content[#lorem(50)]
})

#pagebreak()

#meander.reflow({
  import meander: *
  opt.debug.post-thread()
  container(tags: <A>, margin: (y: 2cm, rest: 5mm))
  content(lorem(100))
  colbreak()

  callback(
    env: (
      a: query.position(<A>, at: bottom + left),
    ),
    env => {
    placed(
      env.a,
      anchor: top + left, dx: 5mm, dy: 1cm,
      box(width: 5cm, height: 5cm, fill: red),
      tags: <B>,
    )
  })
  callback(
    env: (
      b: query.position(<B>),
      bw: query.width(<B>, transform: 200%),
      bh: query.height(<B>, transform: x => 3 * x),
    ),
    env => {
    container(
      align: env.b,
      width: env.bw,
      height: env.bh,
    )
  })
  content(lorem(250))
})
