// Generalist functions for 1D and 2D geometry

/// Bound a value between #arg[min] and #arg[max].
/// No constraints on types as long as they support inequality testing.
/// -> any
#let clamp(
  /// Base value.
  /// -> any
  val,
  /// Lower bound.
  /// -> any | none
  min: none,
  /// Upper bound.
  /// -> any | none
  max: none,
) = {
  let val = val
  if min != none and min > val { val = min }
  if max != none and max < val { val = max }
  val
}

/// Testing `a <= b <= c`, helps only computing `b` once.
/// -> bool
#let between(
  /// Lower bound.
  /// -> length
  a,
  /// Tested value.
  /// -> length
  b,
  /// Upper bound. Asserted to be `>= a`.
  /// -> length
  c,
) = {
  assert(a <= c)
  a <= b and b <= c
}

/// Tests if two intervals intersect.
#let intersects(
  /// First interval as a tuple of `(low, high)` in absolute lengths.
  /// -> (length, length)
  i1,
  /// Second interval.
  /// -> (length, length)
  i2,
  /// Set to nonzero to ignore small intersections.
  /// -> length
  tolerance: 0pt,
) = {
  let (l1, r1) = i1
  let (l2, r2) = i2
  assert(l1 <= r1)
  assert(l2 <= r2)
  if r1 < l2 + tolerance { return false }
  if r2 < l1 + tolerance { return false }
  true
}

/// Converts relative and contextual lengths to absolute.
/// The return value will contain each of the arguments once converted,
/// with arguments that begin or end with ```typc "x"``` or start with
/// ```typc "w"``` being interpreted as horizontal, and arguments that
/// begin or end with ```typc "y"``` or start with ```typc "h"``` being
/// interpreted as vertical.
/// ```typ
/// #context resolve(
///     (width: 100pt, height: 200pt),
///     x: 10%, y: 50% + 1pt,
///     width: 50%, height: 5pt,
/// )
/// ```
///
/// -> dictionary
#let resolve(
  /// Size of the container as given by the `layout` function.
  /// -> size
  size,
  /// Arbitrary many length arguments, automatically inferred to be horizontal
  /// or vertical.
  /// -> dictionary
  ..args
) = {
  if "width" not in size { panic(size) }
  let scale-value(rel, max) = {
    let rel = 0% + 0pt + rel
    rel.ratio * max + rel.length.to-absolute()
  }
  // TODO: filter to only convert lengths
  let ans = (:)
  for (arg, val) in args.named() {
    let is-x = arg.at(0) == "x" or arg.last() == "x" or arg.at(0) == "w"
    let is-y = arg.at(0) == "y" or arg.last() == "y" or arg.at(0) == "h"
    if is-x and is-y {
      panic("Cannot infer if " + arg + " is horizontal or vertical")
    } else if is-x {
      ans.insert(arg, scale-value(val, size.width))
    } else if is-y {
      ans.insert(arg, scale-value(val, size.height))
    } else {
      ans.insert(arg, val)
    }
  }
  ans
}

/// Compute the position of the upper left corner, taking into account the
/// alignment and displacement.
/// -> (x: relative, y: relative)
#let align(
  /// Absolute alignment.
  /// -> align
  alignment,
  /// Horizontal displacement.
  /// -> relative
  dx: 0pt,
  /// Vertical displacement.
  /// -> relative
  dy: 0pt,
  /// Object width.
  /// -> relative
  width: 0pt,
  /// Object height.
  /// -> relative
  height: 0pt,
  /// Anchor point.
  /// -> align | auto
  anchor: auto,
) = {
  let page-x = if alignment.x == left {
    0%
  } else if alignment.x == right {
    100%
  } else if alignment.x == center {
    50%
  } else {
    0%
  }
  let page-y = if alignment.y == top {
    0%
  } else if alignment.y == bottom {
    100%
  } else if alignment.y == horizon {
    50%
  } else {
    0%
  }
  let obj-dx = if anchor == auto {
    if alignment.x == left {
      0pt
    } else if alignment.x == right {
      -width
    } else if alignment.x == center {
      -width / 2
    } else {
      0pt
    }
  } else {
    if anchor.x == left {
      0pt
    } else if anchor.x == right {
      -width
    } else if anchor.x == center {
      -width / 2
    } else {
      -width / 2
    }
  }
  let obj-dy = if anchor == auto {
    if alignment.y == top {
      0pt
    } else if alignment.y == bottom {
      -height
    } else if alignment.y == horizon {
      -height / 2
    } else {
      0pt
    }
  } else {
    if anchor.y == top {
      0pt
    } else if anchor.y == bottom {
      -height
    } else if anchor.y == horizon {
      -height / 2
    } else {
      -height / 2
    }
  }
  (x: page-x + obj-dx + dx, y: page-y + obj-dy + dy)
}


