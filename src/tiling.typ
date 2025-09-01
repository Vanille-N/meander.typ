#import "geometry.typ"

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
/// See the helper function `container` that constructs a container directly.
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
/// -> (containers: (..block,), obstacles: (..content,), flow: content)
#let separate(
  /// -> content
  ct
) = {
  let flow = []
  let flow-has-par = false
  // TODO: rename
  let placed = ()
  let free = ()
  assert(ct.func() == [].func(), message: "`separate` expects sequence-like content.")
  for child in ct.children {
    if child.func() == pagebreak {
      panic("Pagebreaks are not supported inside `separate`")
    } else if child.func() == place {
      placed.push(child)
    } else if child.func() == box and child.has("body") {
      // The box is eligible if its body is only a `place` and the place itself is empty
      let outer = child
      let inner = child.body
      if inner.func() == place and inner.body == [] {
        let width = outer.fields().at("width", default: 100%)
        let height = outer.fields().at("height", default: 100%)
        let alignment = inner.fields().at("alignment", default: top + left)
        let dx = inner.at("dx", default: 0pt)
        let dy = inner.at("dy", default: 0pt)
        let (x, y) = geometry.align(alignment, dx: dx, dy: dy, width: width, height: height)
        free.push((x: x, y: y, width: width, height: height))
      } else {
        flow += child
      }
    } else if child.func() == [].func() {
      let child-sep = separate(child)
      flow += child-sep.flow
      placed += child-sep.obstacles
      free += child-sep.containers
    } else {
      flow += child
      /*
      if child.func() == parbreak {
        if flow-has-par {
          flow += child
          flow-has-par = false
        }
      } else {
        flow += child
        if flow not in ([ ], []) {
          flow-has-par = true
        }
      }
      */
    }
  }
  (flow: flow, obstacles: placed, containers: free)
}

/// Marks the contents as not an obstacle.
#let phantom(ct) = place(ct)

/// Creates a standard container.
/// This is not obscure, it's simply a `box(place({}))`, which is by convention
/// recognized by `separate` as a container.
/// -> content
#let container(
  /// Accepts the parameters:
  /// - `alignment` (positional, default top + left), passed to `place`
  /// - `dx: relative` (named, default `0%`), passed to `place`
  /// - `dy: relative` (named, default `0%`), passed to `place`
  /// - `width: relative` (named, default `100%`), passed to `box`
  /// - `height: relative` (named, default `100%`), passed to `box`
  /// -> args
  ..args,
) = {
  let named = args.named()
  let pos = args.pos()
  if pos.len() > 1 { panic("`container` expects at most an alignment as positional argument") }

  let box-named = (:)
  let place-named = (:)
  for arg in ("dx", "dy") {
    if arg in args.named() {
      place-named.insert(arg, named.at(arg))
    }
  }
  for arg in ("width", "height") {
    if arg in args.named() {
      box-named.insert(arg, named.at(arg))
    }
  }
  box(..box-named, place(..pos, ..place-named, {}))
}

/// Pattern with red crosses to display forbidden zones.
/// -> pattern
#let pat-forbidden(
  /// Size of the tiling
  sz,
) = tiling(size: (sz, sz))[
  #place(box(width: 100%, height: 100%, stroke: none, fill: red.transparentize(95%)))
  #place(line(start: (25%, 25%), end: (75%, 75%), stroke: red + 0.1pt))
  #place(line(start: (25%, 75%), end: (75%, 25%), stroke: red + 0.1pt))
]

/// Pattern with green pluses to display allowed zones.
/// -> pattern
#let pat-allowed(
  /// Size of the tiling
  sz,
) = tiling(size: (sz, sz))[
  #place(box(width: 100%, height: 100%, stroke: none, fill: green.transparentize(95%)))
  #place(line(start: (25%, 50%), end: (75%, 50%), stroke: green + 0.1pt))
  #place(line(start: (50%, 25%), end: (50%, 75%), stroke: green + 0.1pt))
]

/// From a set of obstacles (see `separate`: an obstacle is any `place`d content
/// at the toplevel, so excluding `place`s that are inside `box`, `rect`, etc.),
/// construct the blocks `(x: length, y: length, width: length, height: length)`
/// that surround the obstacles.
///
/// The return value is as follows:
/// - `rects`, a list of `block`s `(x: length, y: length, width: length, height: length)`
/// - `display`, show this to include the placed content in the final output
/// - `debug`, show this to include helper boxes to visualize the layout
///
/// -> (rects: (..block,), display: content, debug: content)
#let forbidden-rectangles(
  /// Array of all the obstacles that are placed on this document.
  /// -> (..content,)
  obstacles,
  /// Add padding around the obstacles.
  /// -> length
  margin: 0pt,
  /// Dimensions of the parent container, as provided by `layout`.
  /// -> (width: length, height: length)
  size: none
) = {
  if size == none { panic("Need to provide a size") }
  let forbidden = ()
  let display = []
  let debug = []
  for elem in obstacles {
    let (elem, reflow) = {
      if elem.fields().body.func() == place {
        (elem.fields().body, false)
      } else {
        (elem, true)
      }
    }
    let fields = elem.fields()
    let inner = fields.body
    let alignment = fields.at("alignment", default: top + left)
    let dx = fields.at("dx", default: 0pt)
    let dy = fields.at("dy", default: 0pt)
    let (width, height) = measure(inner, ..size)
    let (x, y) = geometry.align(alignment, dx: dx, dy: dy, width: width, height: height)
    let dims = geometry.resolve(size, x: x, y: y, width: width, height: height)
    // TODO: does this correctly handle obstacles that go below 0% ?
    display += place[#move(dx: dims.x, dy: dims.y)[#inner]]

    if reflow {
      let padded = (x: none, y: none, width: none, height: none)
      padded.x = geometry.clamp(dims.x - margin, min: 0pt)
      padded.y = geometry.clamp(dims.y - margin, min: 0pt)
      padded.width = calc.min(size.width, dims.x + dims.width + margin) - padded.x
      padded.height = calc.min(size.height, dims.y + dims.height + margin) - padded.y

      assert(padded.width >= 0pt)
      assert(padded.height >= 0pt)
      forbidden.push(padded)
      debug += place(top + left)[#move(dx: padded.x, dy: padded.y)[#box(stroke: red, fill: pat-forbidden(10pt), width: padded.width, height: padded.height)]]
    }
  }
  (rects: forbidden, display: display, debug: debug)
}

/// Partition the complement of `avoid` into `containers` as a series of rectangles.
///
/// The algorithm is roughly as follows:
/// ```
/// for container in containers {
///   horizontal-cuts = sorted(top and bottom of zone for zone in avoid)
///   for (top, bottom) in horizontal-cuts.windows(2) {
///     vertical-cuts = sorted(
///       left and right of zone for zone in avoid
///       if zone intersects (top, bottom)
///     )
///     new zone (top, bottom, left, right)
///   }
/// }
/// ```
/// The main difficulty is in bookkeeping and handling edge cases
/// (weird intersections, margins of error, containers that overflow the page, etc.)
/// There are no heuristics to exclude zones that are too small,
/// and no worries about zones that intersect vertically.
/// That would be the threading algorithm's job.
///
/// Blocks are given an additional field `bounds` that dictate the upper
/// limit of how much this block is allowed to stretch vertically, set to
/// the dimensions of the container that produced this block.
///
/// -> (rects: (..block,), debug: content)
#let tolerable-rectangles(containers, avoid: (), size: none) = {
  if size == none { panic("Need to provide a size") }
  let zones-to-fill = ()
  let debug = []
  // TODO: include previous zones when cutting horizontally
  for zone in containers {
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
      let bounds = zone
      for zone in valid-zones {
        assert(lo >= hi)
        assert(zone.width >= 0pt)
        debug += place(dx: zone.x, dy: hi)[#box(width: zone.width, height: lo - hi, fill: pat-allowed(10pt), stroke: green)]
        zones-to-fill.push((dx: zone.x, dy: hi, height: lo - hi, width: zone.width, bounds: bounds))
      }
    }
  }
  (rects: zones-to-fill, debug: debug)
}

/// Debug version of the toplevel `reflow`,
/// that only displays the partitioned layout.
/// -> content
#let debug-reflow(
  /// Content to be segmented and have its layout displayed.
  /// -> content
  ct,
  /// Whether to show the placed objects.
  /// -> bool
  display: true,
) = layout(size => {
  let (obstacles, containers) = separate(ct)
  let forbidden = forbidden-rectangles(obstacles, margin: 5pt, size: size)
  if display {
    forbidden.display
  }
  forbidden.debug

  let allowed = tolerable-rectangles(containers, avoid: forbidden.rects, size: size)
  allowed.debug
})
