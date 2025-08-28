// Generalist functions for 1D and 2D geometry

/// Testing `a <= b <= c`, helps only computing `b` once.
/// -> bool
#let between(
  /// Lower bound.
  /// -> length
  a,
  /// Tested value.
  /// -> length
  b,
  /// Upper bound. Asserted to be `>= c`.
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
/// with arguments that contain `'x'` or start with `'w'` being interpreted as
/// horizontal, and arguments that contain `'y'` or start with `'h'` being
/// interpreted as vertical.
///
/// ```example
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
  /// -> (width: length, height: length)
  size,
  /// -> dictionary
  ..args
) = {
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


