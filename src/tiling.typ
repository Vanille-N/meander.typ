#import "std.typ"
#import "geometry.typ"

/// Pattern with red crosses to display forbidden zones.
/// -> pattern
#let pat-forbidden(
  /// Size of the tiling.
  /// -> length
  sz,
) = tiling(size: (sz, sz))[
  #place(box(width: 100%, height: 100%, stroke: none, fill: red.transparentize(95%)))
  #place(line(start: (25%, 25%), end: (75%, 75%), stroke: red + 0.1pt))
  #place(line(start: (25%, 75%), end: (75%, 25%), stroke: red + 0.1pt))
]

/// Pattern with green pluses to display allowed zones.
/// -> pattern
#let pat-allowed(
  /// Size of the tiling.
  /// -> length
  sz,
) = tiling(size: (sz, sz))[
  #place(box(width: 100%, height: 100%, stroke: none, fill: green.transparentize(95%)))
  #place(line(start: (25%, 50%), end: (75%, 50%), stroke: green + 0.1pt))
  #place(line(start: (50%, 25%), end: (50%, 75%), stroke: green + 0.1pt))
]


/// See: `next-elem` to explain `data`.
/// This function computes the effective obstacles from an input object,
/// as well as the display and debug outputs.
/// -> elem
#let elem-of-placed(
  /// Internal state.
  /// -> opaque
  data,
  /// Object to measure, pad, and place.
  /// -> placed
  obj,
) = {
  let (width, height) = measure(obj.content, ..data.size)
  let (x, y) = geometry.align(obj.align, dx: obj.dx, dy: obj.dy, width: width, height: height)
  let dims = geometry.resolve(data.size, x: x, y: y, width: width, height: height)
  let display = if obj.display {
    place[#move(dx: dims.x, dy: dims.y)[#{obj.content}]]
  } else { none }

  // Apply the boundary redrawing functions in order to know the true
  // footprint of the object in the layout.
  let bounds = (dims,)
  for func in obj.boundary {
    let func = if func != auto { func } else {
      import "contour.typ"
      contour.margin(5pt).at(0)
    }
    bounds = bounds.map(func).flatten()
  }
  let forbidden = ()
  let debug = []
  for dims in bounds {
    forbidden.push((..dims, aux: obj.aux))
    debug += place[#move(dx: dims.x, dy: dims.y)[#box(stroke: red, fill: pat-forbidden(30pt), width: dims.width, height: dims.height)]]
  }
  (type: place, debug: debug, display: display, blocks: forbidden)
}

/// Eliminates non-candidates by determining if the obstacle is ignored by the container.
#let is-ignored(
  /// Must have the field `_.aux.ignore-labels`,
  /// as containers do.
  container,
  /// Must have the fields `_.aux.tags` and `_.aux.name`,
  /// as obstacles do.
  obstacle,
) = {
  let tags = obstacle.aux.tags + (obstacle.aux.name,)
  for label in container.aux.ignore-labels {
    if label in tags {
      return true
    }
  }
  false
}

/// See: `next-elem` to explain `data`.
/// Computes the effective containers from an input object,
/// as well as the display and debug outputs.
/// -> elem
#let elem-of-container(
  /// Internal state.
  /// -> opaque
  data,
  /// Container to segment.
  /// -> container
  obj,
) = {
  // TODO: handle ignore-labels

  // Calculate the absolute dimensions of the container
  let (x, y) = geometry.align(obj.align, dx: obj.dx, dy: obj.dy, width: obj.width, height: obj.height)
  let dims = geometry.resolve(data.size, x: x, y: y, width: obj.width, height: obj.height)
  // Select only the obstacles that may intersect this container
  let relevant-obstacles = data.obstacles.filter(exclude => {
    geometry.intersects((dims.x, dims.x + dims.width), (exclude.x, exclude.x + exclude.width)) and not is-ignored(obj, exclude)
  })
  // Cut the zone horizontally at every top or bottom of an intersecting obstacle
  let horizontal-marks = (dims.y, dims.y + dims.height)
  for exclude in relevant-obstacles {
    for line in (exclude.y, exclude.y + exclude.height) {
      if geometry.between(dims.y, line, dims.y + dims.height) {
        horizontal-marks.push(line)
      }
    }
  }
  // This hack helps solve a problem when the container has the height of the whole
  // page: `measure(box(height: 100%), ..size).height` is equal to
  // `measure(box(height: 200%), ..size).height`
  if horizontal-marks.len() == 2 and dims.height == data.size.height {
    horizontal-marks.push(data.size.height / 2)
  }
  horizontal-marks = horizontal-marks.sorted()

  let debug = []
  let all-zones = ()
  // Then for every horizontal region delimited by two adjacent marks,
  // compute the vertical segments.
  for (hi, lo) in horizontal-marks.windows(2) {
    // Further filter the obstacles for better performance.
    let relevant-obstacles = relevant-obstacles.filter(exclude => {
      geometry.intersects((hi, lo), (exclude.y, exclude.y + exclude.height), tolerance: 1mm)
    })
    let vertical-marks = (dims.x, dims.x + dims.width)
    for exclude in relevant-obstacles {
      for line in (exclude.x, exclude.x + exclude.width) {
        if geometry.between(dims.x, line, dims.x + dims.width) {
          vertical-marks.push(line)
        }
      }
    }
    vertical-marks = vertical-marks.sorted()

    // A zone is naturally the space between two adjacent vertical marks,
    // if and only if it does not intersect any obstacle.
    let new-zones = ()
    for (l, r) in vertical-marks.windows(2) {
      if r - l < 1mm { continue }
      let available = true
      for exclude in relevant-obstacles {
        if geometry.intersects((l, r), (exclude.x, exclude.x + exclude.width), tolerance: 1mm) {
          available = false
        }
      }
      if available {
        new-zones.push((x: l, width: r - l))
      }
    }
    for zone in new-zones {
      assert(lo >= hi)
      assert(zone.width >= 0pt)
      debug += place(dx: zone.x, dy: hi)[
        #box(width: zone.width, height: lo - hi, fill: pat-allowed(30pt), stroke: green)
      ]
      all-zones.push((
        x: zone.x, y: hi, height: lo - hi, width: zone.width,
        bounds: dims, // upper limits on how this zone can grow
        margin: obj.margin,
        aux: obj.aux,
      ))
    }
  }
  (type: box, debug: debug, display: none, blocks: all-zones)
}

/// Applies an element's margin to itself.
/// -> elem
#let add-self-margin(elem) = {
  if "margin" not in elem { return elem }
  elem.x -= elem.margin
  elem.y -= elem.margin
  elem.width += 2 * elem.margin
  elem.height += 2 * elem.margin
  elem
}

/// Initializes the initial value of the internal data for the reentering
/// `next-elem`.
#let create-data(
  /// Dimensions of the page
  /// -> (width: length, height: length)
  size: none,
  /// Elements to dispense in order
  /// -> (..elem,)
  elems: (),
) = {
  assert(size != none)
  (
    elems: elems.rev(),
    size: size,
    obstacles: (),
    labels: (:),
  )
}

/// This function is reentering, allowing interactive computation of the layout.
/// Given its internal state `data`, `next-elem` uses the helper functions
/// `elem-of-placed` and `elem-of-container` to compute the dimensions of the
/// next element, which may be an obstacle or a container.
/// -> (elem, opaque)
#let next-elem(
  /// Internal state, stores
  /// - `size` the available page dimensions,
  /// - `elems` the remaining elements to handle in reverse order (they will be `pop`ped),
  /// - `obstacles` the running accumulator of previous obstacles;
  /// -> opaque
  data,
) = {
  let data = data
  if data.elems.len() == 0 { return (none, data) }
  let obj = data.elems.pop()
  if obj.type == place {
    (elem-of-placed(data, obj), data)
  } else if obj.type == box {
    (elem-of-container(data, obj), data)
  } else {
    panic("There is a bug in `separate`")
  }
}

/// Updates the internal state to include the newly created element.
/// -> opaque
#let push-elem(
  /// Internal state.
  /// -> opaque
  data,
  /// Element to register.
  /// -> elem
  elem,
) = {
  let data = data
  for block in elem.blocks {
    if block.aux.name != none {
      let s = str(block.aux.name)
      if s in data.labels {
        panic("name " + s + " should be unique")
      }
      data.labels.insert(s, false)
    }
    for tag in block.aux.tags {
      let s = str(tag)
      if not data.labels.at(s, default: true) {
        panic("name " + s + " should be unique")
      }
      data.labels.insert(s, true)
    }
    data.obstacles.push(block)
  }
  data
}

/// Splits the input sequence into pages of elements (either obstacles or containers),
/// and flowing content.
///
/// An "obstacle" is data produced by the `placed` function.
/// It can contain arbitrary content, and defines a zone where flowing content
/// cannot be placed.
///
/// A "container" is produced by the function `container`.
/// It defines a region where (once the obstacles are subtracted) is allowed
/// to contain flowing content.
///
/// Lastly flowing content is produced by the function `content`.
/// It will be threaded through every available container in order.
///
/// ```typ
/// #separate({
///   // This is an obstacle
///   placed(top + left, box(width: 50pt, height: 50pt))
///   // This is a container
///   container(height: 50%)
///   // This is flowing content
///   content[#lorem(50)]
/// })
/// ```
///
/// -> (pages: array, flow: (..content,))
#let separate(
  /// A sequence of constructors `placed`, `container`, and `content`.
  /// -> seq
  seq
) = {
  let pages = ()
  let flow = ()
  let elems = ()
  for obj in seq {
    if obj.type == place or obj.type == box {
      elems.push(obj)
    } else if obj.type == text {
      flow.push(obj)
    } else if obj.type == std.pagebreak {
      pages.push(elems)
      elems = ()
    } else if obj.type == std.colbreak {
      flow.push(obj)
    } else if obj.type == pad {
      flow.push(obj)
    } else {
      panic("Unknown element of type " + repr(obj.type))
    }
  }
  pages.push(elems)
  (flow: flow, pages: pages) 
}

