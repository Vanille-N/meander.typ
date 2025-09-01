#import "geometry.typ"
#import "tiling.typ"

#let frac-rect(frac, abs, ..style) = {
  place(
    top + left,
    dx: abs.x + frac.x * abs.width,
    dy: abs.y + frac.y * abs.height,
    box(
      width: frac.width * abs.width,
      height: frac.height * abs.height,
      ..style,
    )
  )
}

#let redraw-grid(fun, div: 5, debug: true, block: (:)) = {
  let (div-x, div-y) = if type(div) == int {
    (div, div)
  } else if type(div) == dictionary {
    (div.x, div.y)
  } else {
    panic("div should be an integer or an array")
  }
  let dw = block.width / div-x
  let dh = block.height / div-y
  for i in range(div-y) {
    let start = 0
    for j in range(div-x) {
      if fun((j + 0.5) / div-x, (i + 0.5) / div-y) {
        continue
      } else {
        if start < j {
          frac-rect(
              (x: start / div-x, y: i / div-y, width: (j - start) / div-x, height: 1 / div-y),
            block,
            stroke: if debug { red } else { none },
          )
        }
        start = j + 1
      }
    }
    if start < div-x {
      frac-rect(
        (x: start / div-x, y: i / div-y, width: (div-x - start) / div-x, height: 1 / div-y),
        block,
        stroke: if debug { red } else { none },
      )
    }
  }
}

#let redraw-horiz(fun, div: 5, debug: true, block: (:)) = {
  assert(type(div) == int, message: "div should be an integer")
  let dh = block.height / div
  for i in range(div) {
    let (l, r) = fun((i + 0.5) / div)
    frac-rect(
      (x: l, y: i / div, width: r - l, height: 1 / div),
      block,
      stroke: if debug { red } else { none },
    )
  }
}

#let redraw-vert(fun, div: 5, debug: true, block: (:)) = {
  assert(type(div) == int, message: "div should be an integer")
  let dw = block.width / div
  for j in range(div) {
    let (t, b) = fun((j + 0.5) / div)
    frac-rect(
      (x: j / div, y: t, width: 1 / div, height: b - t),
      block,
      stroke: if debug { red } else { none },
    )
  }
}


#let redraw-width(fun, div: 5, debug: true, flush: center, block: (:)) = {
  assert(type(div) == int, message: "div should be an integer")
  let dh = block.height / div
    for i in range(div) {
      let (a, w) = fun((i + 0.5) / div)
      if flush == center {
        frac-rect(
          (x: a - w/2, y: i / div, width: w, height: 1 / div),
          block,
          stroke: if debug { red } else { none },
        )
      } else if flush == right {
        frac-rect(
          (x: 1 - a - w, y: i / div, width: w, height: 1 / div),
          block,
          stroke: if debug { red } else { none },
        )
      } else {
        frac-rect(
          (x: a, y: i / div, width: w, height: 1 / div),
          block,
          stroke: if debug { red } else { none },
        )
      }
    }
  }
}

#let redraw-height(fun, div: 5, debug: true, flush: center, block: (:)) = {
  assert(type(div) == int, message: "div should be an integer")
  let dw = block.width / div
    for j in range(div) {
      let (a, h) = fun((j + 0.5) / div)
      if flush == horizon {
        frac-rect(
          (x: j / div, y: a - h/2, width: 1 / div, height: h),
          block,
          stroke: if debug { red } else { none },
        )
      } else if flush == bottom {
        frac-rect(
          (x: j / div, y: a - h, width: 1 / div, height: h),
          block,
          stroke: if debug { red } else { none },
        )
      } else {
        frac-rect(
          (x: j / div, y: 1 - a, width: 1 / div, height: h),
          block,
          stroke: if debug { red } else { none },
        )
      }
    }
  }
}


/// Manually redraw the boundaries of an object.
#let redraw(
  ct,
  debug: false,
  phantom: true,
  grid: none,
  horiz: none,
  width: none,
  vert: none,
  height: none,
  ..args,
) = {
  assert(ct.func() == place, message: "contour can only operate on `place`d content.")
  let fields = ct.fields()
  let alignment = fields.at("alignment", default: top + left)
  let dx = fields.at("dx", default: 0pt)
  let dy = fields.at("dy", default: 0pt)
  assert(ct.body.func() != place, message: "contour cannot handle two nested `place`")
  let dims = measure(ct.body)
  assert(dims.width > 0pt, message: "object width must be positive")
  assert(dims.height > 0pt, message: "object height must be positive")
  let (x, y) = geometry.align(alignment, dx: dx, dy: dy, ..dims)
  if phantom {
    tiling.phantom(ct)
  } else {
    ct
  }
  if grid != none {
    redraw-grid(grid, ..args, debug: debug, block: (x: x, y: y, ..dims))
    return
  } else if horiz != none {
    redraw-horiz(horiz, ..args, debug: debug, block: (x: x, y: y, ..dims))
    return
  } else if width != none {
    redraw-width(width, ..args, debug: debug, block: (x: x, y: y, ..dims))
    return
  } else if vert != none {
    redraw-vert(vert, ..args, debug: debug, block: (x: x, y: y, ..dims)) 
    return
  } else if height != none {
    redraw-height(height, ..args, debug: debug, block: (x: x, y: y, ..dims))
    return
  }
  panic("no contouring function provided")
}

