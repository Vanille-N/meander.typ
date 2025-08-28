#let separate(ct) = {
  let flow = []
  let placed = ()
  let free = ()
  assert(ct.func() == [].func())
  for child in ct.children {
    if child.func() == pagebreak {
      panic("Pagebreaks are not supported inside `separate`")
    } else if child.func() == place {
      placed.push(child)
    } else if child.func() == box{
      // The box is eligible if its body is only a `place` and the place itself is empty
      let inner = child.body
      if inner.func() == place and inner.body == [] {
        let width = child.fields().at("width", default: 100%)
        let height = child.fields().at("height", default: 100%)
        let alignment = inner.fields().at("alignment", default: top + left)
        let dx = inner.at("dx", default: 0pt)
        let dy = inner.at("dy", default: 0pt)
        let x = if alignment.x == left {
          0% + dx
        } else if alignment.x == right {
          100% + dx - width
        } else {
          50% + dx - width/2
        }
        let y = if alignment.y == top {
          0% + dy
        } else if alignment.y == bottom {
          100% + dy - height
        } else {
          50% + dy - height/2
        }
        free.push((x: x, y: y, width: width, height: height))
      } else {
        flow += child
      }
    } else if child.func() == [].func() {
      let child-sep = separate(child)
      flow += child-sep.flow
      placed += child-sep.placed
    } else {
      flow += child
    }
  }
  (flow: flow, placed: placed, free: free)
}

#let pat-forbidden = tiling(size: (30pt, 30pt))[
  #place(box(width: 100%, height: 100%, stroke: none, fill: red.transparentize(95%)))
  #place(line(start: (25%, 25%), end: (75%, 75%), stroke: red))
  #place(line(start: (25%, 75%), end: (75%, 25%), stroke: red))
]

#let pat-allowed = tiling(size: (30pt, 30pt))[
  #place(box(width: 100%, height: 100%, stroke: none, fill: green.transparentize(95%)))
  #place(line(start: (33%, 50%), end: (66%, 50%), stroke: green))
  #place(line(start: (50%, 33%), end: (50%, 66%), stroke: green))
]

#let resolve(size: (:), ..args) = {
  let ans = (:)
  for (arg, val) in args.named() {
    let is-x = arg.contains("x") or (arg.at(0) == "w")
    let is-y = arg.contains("y") or (arg.at(0) == "h")
    if is-x and is-y {
      panic("Cannot infer if " + arg + " is horizontal or vertical")
    } else if is-x {
      ans.insert(arg, measure(box(width: val), ..size).width)
    } else if is-y {
      ans.insert(arg, measure(box(height: val), ..size).height)
    } else {
      panic("Cannot infer if " + arg + " is horizontal or vertical")
    }
  }
  ans
}

#let between(a, b, c) = a <= b and b <= c

#let intersects(i1, i2, tolerance: 0pt) = {
  let (l1, r1) = i1
  let (l2, r2) = i2
  assert(l1 <= r1)
  assert(l2 <= r2)
  if r1 < l2 + tolerance { return false }
  if r2 < l1 + tolerance { return false }
  true
}

#let forbidden-rectangles(placed, margin: 0pt, size: none) = {
  if size == none { panic("Need to provide a size") }
  let forbidden = ()
  let display = []
  let debug = []
  for elem in placed {
    let fields = elem.fields()
    let inner = fields.body
    let horiz = fields.at("alignment", default: top + left).x
    let vert = fields.at("alignment", default: top + left).y
    let dx = fields.at("dx", default: 0pt)
    let dy = fields.at("dy", default: 0pt)
    let (width, height) = measure(inner, ..size)
    let real-x = {
      if horiz == left {
        0% + dx
      } else if horiz == right {
        100% + dx - width
      } else {
        50% + dx - width/2
      }
    }
    let real-y = {
      if vert == top {
        0% + dy
      } else if vert == bottom {
        100% + dy - height
      } else {
        50% + dy - height/2
      }
    }
    let dims = resolve(size: size, x: real-x, y: real-y, width: width, height: height)
    display += place(top + left)[#move(dx: dims.x, dy: dims.y)[#inner]]

    let padded = (x: none, y: none, width: none, height: none)
    padded.x = calc.max(0pt, dims.x - margin)
    padded.y = calc.max(0pt, dims.y - margin)
    padded.width = calc.min(size.width, dims.x + dims.width + margin) - padded.x
    padded.height = calc.min(size.height, dims.y + dims.height + margin) - padded.y

    assert(padded.width >= 0pt)
    assert(padded.height >= 0pt)
    forbidden.push(padded)
    debug += place(top + left)[#move(dx: padded.x, dy: padded.y)[#box(stroke: red, fill: pat-forbidden, width: padded.width, height: padded.height)]]
  }
  (rects: forbidden, display: display, debug: debug)
}

#let tolerable-rectangles(free, avoid: (), size: (:)) = {
  //let zone = resolve(size: size, x: 0%, y: 0%, width: 100%, height: 100%)
  let zones-to-fill = ()
  let debug = []
  for zone in free {
    let zone = resolve(size: size, ..zone)
    // Cut the zone horizontally
    let horizontal-marks = (zone.y, zone.y + zone.height)
    for no-zone in avoid {
      if zone.y <= no-zone.y and no-zone.y <= zone.y + zone.height {
        horizontal-marks.push(no-zone.y)
      }
      if zone.y <= no-zone.y + no-zone.height and no-zone.y + no-zone.height <= zone.y + zone.height {
        horizontal-marks.push(no-zone.y + no-zone.height)
      }
    }
    horizontal-marks = horizontal-marks.sorted()
    for (hi, lo) in horizontal-marks.windows(2) {
      let vertical-marks = (zone.x, zone.x + zone.width)
      let relevant-forbidden = ()
      for no-zone in avoid {
        if intersects((hi, lo), (no-zone.y, no-zone.y + no-zone.height), tolerance: 1mm) {
          relevant-forbidden.push(no-zone)
          if between(zone.x, no-zone.x, zone.x + zone.width) {
            vertical-marks.push(no-zone.x)
          }
          if between(zone.x, no-zone.x + no-zone.width, zone.x + zone.width) {
            vertical-marks.push(no-zone.x + no-zone.width)
          }
        }
      }
      let vertical-marks = vertical-marks.sorted()
      let valid-zones = ()
      for (l, r) in vertical-marks.windows(2) {
        if r - l < 1mm { continue }
        let available = true
        for no-zone in relevant-forbidden {
          if intersects((l, r), (no-zone.x, no-zone.x + no-zone.width), tolerance: 1mm) { available = false }
        }
        if available {
          valid-zones.push((x: l, width: r - l))
        }
      }
      for zone in valid-zones {
        assert(lo >= hi)
        assert(zone.width >= 0pt)
        debug += place(dx: zone.x, dy: hi)[#box(width: zone.width, height: lo - hi, fill: pat-allowed, stroke: green)]
        zones-to-fill.push((dx: zone.x, dy: hi, height: lo - hi, width: zone.width))
      }
    }
  }
  (rects: zones-to-fill, debug: debug)
}

#let smart-fill-boxes(body, avoid: (), boxes: (), extend: 1em, size: (:)) = {
  let full = ()
  let body = body
  for cont in boxes {
    if body == none {
      full.push((cont, none))
      continue
    }
    // Leave it a little room
    // 1em margin at the bottom to let it potentially add an extra line
    let old-lo = cont.dy + cont.height
    let new-lo = old-lo + resolve(size: size, y: 0.5em).y
    new-lo = calc.min(new-lo, resolve(size: size, height: 100%).height)
    for no-box in avoid {
      if intersects((cont.dx, cont.dx + cont.width), (no-box.x, no-box.x + no-box.width), tolerance: 1mm) {
        if intersects((old-lo, new-lo), (no-box.y, no-box.y), tolerance: 0mm) {
          new-lo = calc.min(new-lo, no-box.y)
        }
      }
    }
    cont.height = new-lo - cont.dy
    // As much as it wants on the top to fill previously unused space
    let old-hi = cont.dy
    let new-hi = 0pt
    let lineskip = resolve(size: size, y: 0.65em).y
    let lo = cont.dy + cont.height
    for no-box in avoid {
      if new-hi > lo { continue }
      if intersects((cont.dx, cont.dx + cont.width), (no-box.x, no-box.x + no-box.width), tolerance: 1mm) {
        if intersects((new-hi, lo), (no-box.y, no-box.y + no-box.height), tolerance: 1mm) {
          new-hi = calc.max(new-hi, no-box.y + no-box.height)
        }
      }
    }
    for (full-box,_) in full {
      if new-hi > lo { continue }
      if intersects((cont.dx, cont.dx + cont.width), (full-box.dx, full-box.dx + full-box.width), tolerance: 1mm) {
        if intersects((new-hi, lo), (full-box.dy, full-box.dy + full-box.height + lineskip)) {
          new-hi = calc.max(new-hi, full-box.dy + full-box.height + lineskip)
        }
      }
    }
    if new-hi > lo { continue }
    cont.dy = new-hi
    cont.height = lo - new-hi
    
    import "bisect.typ"
    let max-dims = measure(box(height: cont.height, width: cont.width), ..size)
    let (fits, overflow) = bisect.fill-box(max-dims)[#body]
    if fits == none { continue }
    let actual-dims = measure(box(width: cont.width)[#fits], ..size)
    if actual-dims.height < 1mm { continue }
    cont.width = actual-dims.width
    cont.height = actual-dims.height
    full.push((cont, fits))
    body = overflow
  }
  full
}

#let tile(ct) = layout(size => {
  let (flow, placed, free) = separate(ct)
  let forbidden = forbidden-rectangles(placed, margin: 5pt, size: size)
  //forbidden.debug
  forbidden.display

  let allowed = tolerable-rectangles(free, avoid: forbidden.rects, size: size)
  //allowed.debug

  //return
  import "thread.typ"
  for (container, content) in smart-fill-boxes(
    size: size,
    avoid: forbidden.rects,
    boxes: allowed.rects,
    [#flow],
  ) {
    place(dx: container.dx, dy: container.dy, {
      box(width: container.width, height: container.height, {
        thread.auto-stretch(container)[#content]
      })
    })
  }
})

#let fakeimg(align, dx: 0pt, dy: 0pt, fill: white, width: 1cm, height: 1cm) = {
  place(align, dx: dx, dy: dy)[#box(fill: fill.transparentize(70%), width: width, height: height, radius: 5mm)]
}

#let filler = lorem(1000)
//#let filler = range(1000).map(str).join(" ")

#set par(justify: false)
#context tile[
  #fakeimg(top + left, width: 5cm, height: 3cm, fill: green)
  #fakeimg(bottom + left, width: 3cm, height: 6cm, fill: red)
  #fakeimg(bottom + right, width: 2cm, height: 5cm, fill: blue)
  #fakeimg(top + right, width: 5cm, height: 8cm, fill: orange)
  #box(place({}))
  #filler
]
#pagebreak()
#context tile[
  #fakeimg(top + right, width: 8cm, height: 2cm, fill: orange)
  #fakeimg(top + left, dy: 5cm, height: 3cm, width: 3cm, fill: blue)
  #fakeimg(left + horizon, height: 1cm, width: 6cm, fill: green)
  #fakeimg(bottom + right, height: 6cm, width: 5cm, fill: red)
  #box(place({}))
  #filler
]
#pagebreak()
#context tile[
  #fakeimg(center + horizon, dx: 5%, dy: 10%, width: 7cm, height: 5cm, fill: green)
  #fakeimg(top + left, fill: blue, width: 6cm, height: 6cm)
  #fakeimg(bottom + right, fill: orange, width: 5cm, height: 3cm)
  #box(width: 47%, place({}))
  #box(width: 47%, place(top + right, {}))
  #filler
]
#pagebreak()
#context tile[
  #fakeimg(top + left, width: 7cm, height: 7cm, fill: green)
  #fakeimg(top + left, dx: 5cm, dy: 5cm, width: 6cm, height: 6cm, fill: orange)
  #box(width: 40%, place({}))
  #box(width: 55%, place(top + right, {}))
  #filler
]
#pagebreak()
#context tile[
  #fakeimg(top + center, width: 8cm, height: 2cm, fill: orange)
  #fakeimg(top + center, dy: 5cm, height: 3cm, width: 3cm, fill: blue)
  #fakeimg(center + horizon, height: 1cm, width: 6cm, fill: green)
  #fakeimg(bottom, height: 6cm, width: 5cm, fill: red)
  #box(width: 47%, place({}))
  #box(width: 47%, place(top + right, {}))
  #filler
]
#pagebreak()
#context tile[
  #for i in range(11) {
    fakeimg(top + left, dy: i * 2.2cm, width: i * 1cm, height: 2cm, fill: orange)
    if i <= 8 {
      fakeimg(top + right, dy: i * 2.2cm, width: (8 - i) * 1cm, height: 2cm, fill: orange)
    }
  }
  #box(place({}))
  #filler
]
#pagebreak()
#context tile[
  #let vradius = 12.2cm
  #let vcount = 50
  #let hradius = 5cm
  #for i in range(vcount) {
    let frac = (2 * (i + 0.5) / vcount) - 1
    let width = calc.sqrt(1 - frac * frac) * 10cm
    fakeimg(top + left, dy: i * (2 * vradius / vcount), width: width, height: 2 * vradius / vcount, fill: red)
  }
  #box(place(top + left, {}))
  #filler
]
#pagebreak()
#context tile[
  #for i in range(30) {
    fakeimg(top + left, dy: -i * 4mm + 14cm, width: i * 3mm, height: 3mm, fill: blue)
    fakeimg(top + right, dy: -i * 4mm + 14cm, width: i * 3mm, height: 3mm, fill: blue)
    fakeimg(bottom + left, dy: i * 4mm - 14cm, width: i * 3mm, height: 3mm, fill: blue)
    fakeimg(bottom + right, dy: i * 4mm - 14cm, width: i * 3mm, height: 3mm, fill: blue)
  }
  #box(place(top + left, {}))
  #filler
]

// TODO: count previous allowed boxes when splitting new ones
// TODO: allow controling the alignment inside boxes
// TODO: forbid stretching the boxes beyond major containers
// TODO: handle pagebreaks
// TODO: hyphenation
