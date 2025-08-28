#import "../geometry.typ"

/// Splits content into obstacles, containers, and flowing text.
///
/// An "obstacle" is any content inside a `place` at the toplevel.
/// It will be appended in order to the `placed` field as `content`.
///
/// A "container" is a `box(place({}))`. Both `box` and `place` are allowed
/// to have `width`, `height`, etc. parameters, but no inner contents.
/// It will be appended in order to the `free` field as a block,
/// i.e. a dictionary with the fields `x`, `y`, `width`, `height` describing
/// the upper left corner and the dimensions of the container.
///
/// Everything that is neither obstacle nor container is flowing text,
/// and will end in the field `flow`.
///
/// ```typ
/// #separate[
///   // This is an obstacle
///   #place(top + left, box(width: 50pt, height: 50pt))
///   // This is a container
///   #box(height: 50%, place({}))
///   // This is flowing text
///   #lorem(50)
/// ]
/// ```
///
/// -> (flow: array(block), placed: array(content), free: content)
#let separate(
  /// -> content
  ct
) = {
  let flow = []
  let placed = ()
  let free = ()
  assert(ct.func() == [].func(), message: "`separate` expects sequence-like content.")
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
  // TODO: rename to obstacles and containers
  (flow: flow, placed: placed, free: free)
}

/// Pattern with red crosses to display forbidden zones.
#let pat-forbidden = tiling(size: (30pt, 30pt))[
  #place(box(width: 100%, height: 100%, stroke: none, fill: red.transparentize(95%)))
  #place(line(start: (25%, 25%), end: (75%, 75%), stroke: red))
  #place(line(start: (25%, 75%), end: (75%, 25%), stroke: red))
]

/// Pattern with blue pluses to display allowed zones.
#let pat-allowed = tiling(size: (30pt, 30pt))[
  #place(box(width: 100%, height: 100%, stroke: none, fill: green.transparentize(95%)))
  #place(line(start: (33%, 50%), end: (66%, 50%), stroke: green))
  #place(line(start: (50%, 33%), end: (50%, 66%), stroke: green))
]

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
    let dims = geometry.resolve(size, x: real-x, y: real-y, width: width, height: height)
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
  let zones-to-fill = ()
  let debug = []
  for zone in free {
    let zone = geometry.resolve(size, ..zone)
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
        if geometry.intersects((hi, lo), (no-zone.y, no-zone.y + no-zone.height), tolerance: 1mm) {
          relevant-forbidden.push(no-zone)
          if geometry.between(zone.x, no-zone.x, zone.x + zone.width) {
            vertical-marks.push(no-zone.x)
          }
          if geometry.between(zone.x, no-zone.x + no-zone.width, zone.x + zone.width) {
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
          if geometry.intersects((l, r), (no-zone.x, no-zone.x + no-zone.width), tolerance: 1mm) { available = false }
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

