#let clamp(val, min: none, max: none) = {
  let val = val
  if min != none and min > val { val = min }
  if max != none and max < val { val = max }
  val
}

#let fill-boxes(body, ..containers, size: (:)) = {
  let full = ()
  let body = body
  for cont in containers.pos() {
    if body == none {
      full.push((cont, none))
      continue
    }
    import "bisect.typ"
    let max-dims = measure(box(height: cont.height, width: cont.width), ..size)
    let (fits, overflow) = bisect.fill-box(max-dims)[#body]
    full.push((cont, fits))
    body = overflow
  }
  full
}

#let try-stretch(container, content, iterations: 10, err: 1%, bounds: (-10%, 20%), par-leading: (:)) = {
  // If there's a small discrepancy between the height of the box and the height of the content,
  // we try to fix it by adjusting some parameters.
  let par-leading = {
    let default = (default: 0.65em, min: 0.5em, max: 1em, weight: 100%)
    for (field,_) in default {
      if field in par-leading {
        default.at(field) = par-leading.at(field)
      }
    }
    default
  }
  let weight-stretch-clamp(stretch: 100%, default: 1em, min: 0cm, max: 100em, weight: 100%) = {
    clamp(default * (100% + stretch * weight), min: min, max: max)
  }
  let (min-stretch, max-stretch) = bounds
  let stretched-content(stretch, content) = {
    let par-leading-value = weight-stretch-clamp(stretch: stretch, ..par-leading)
    {
      set par(leading: par-leading-value)
      content
    }
  }
  for _ in range(iterations) {
    let stretch = (min-stretch + max-stretch) / 2
    let stretched = stretched-content(stretch, content)
    if measure(box(width: container.width)[#stretched]).height > container.height {
      max-stretch = stretch
    } else {
      min-stretch = stretch
    }
  }
  let stretch = min-stretch
  let stretched = stretched-content(stretch, content)
  let final-height = measure(box(width: container.width)[#stretched]).height
  if final-height > container.height * (100% + err) { return none }
  if final-height < container.height * (100% - err) { return none }
  stretched  
}

#let auto-stretch(container, content, iterations: 10, err: 1%, bounds: (-10%, 20%), par-leading: (:)) = {
  let stretched = try-stretch(container, content, iterations: iterations, err: err, bounds: bounds, par-leading: par-leading)
  if stretched != none {
    stretched
  } else {
    content
  }
}

#let test-content = [
  #lorem(50)
  - #lorem(30)
  - #lorem(12)
  - #lorem(20)
  - #lorem(20)

  #lorem(30)
  *#lorem(50)*
  #lorem(30)

  - #lorem(30)
  - #lorem(20)
  - #lorem(20)
  - #lorem(20)
  #align(center)[#rect(width: 50%, height: 3cm, fill: orange.transparentize(30%), radius: 5mm)]

  - #lorem(20)
    - #lorem(20)
    - #lorem(20)
    - #lorem(20)
    - #lorem(30)
  - #lorem(10)
  - #lorem(30)
  - #lorem(20)
]

#let test-boxes = (
  (width: 5cm, height: 3cm),
  (width: 7cm, height: 6cm),
  (width: 3cm, height: 8cm),
  (width: 6cm, height: 4cm),
  (width: 7cm, height: 3cm),
  (width: 5cm, height: 5cm),
  (width: 10cm, height: 4.5cm),
)

= Threading test (upfront, absolute boxes, no stretching)

#context for (container, content) in fill-boxes(
  test-content,
  ..test-boxes,
) {
  box(..container, stroke: black)[#content]
}

= Threading test (upfront, absolute boxes, auto stretching)

#context for (container, content) in fill-boxes(
  test-content,
  ..test-boxes,
) {
  box(..container, stroke: black)[#auto-stretch(container)[#content]]
}

= Alignment test (upfront, absolute boxes, auto stretching)

#let test-case(ct) = {
  table(
    columns: (1fr, 1fr, 1fr, 1fr, 1fr),
    ..for height in (4.6cm, 4.7cm, 4.8cm, 4.9cm, 5cm,) {
      let dims = (height: height, width: 3cm)
      (box(height: 10cm)[#{
        context {
          let boxes = ()
          for (container, content) in fill-boxes(ct, dims, dims) {
            boxes.push(box(..container, stroke: red)[#text(fill: red)[#auto-stretch(container)[#content]]])
            boxes.push([\ ])
          }
          place(top + left)[#table(..boxes, inset: 0pt, stroke: none)]
          place(top + left)[#box(width: dims.width, height: dims.height * 2, stroke: black)[#ct]]
        }
      }],)
    }
  )
}

#test-case[#lorem(35)]

= Alignment test (upfront, absolute boxes, truncation)

#let test-case(ct) = {
  table(
    columns: (1fr, 1fr, 1fr, 1fr, 1fr),
    ..for height in (4.6cm, 4.7cm, 4.8cm, 4.9cm, 5cm,) {
      let dims = (height: height, width: 3cm)
      (box(height: 10cm)[#{
        context {
          let boxes = ()
          for (container, content) in fill-boxes(ct, dims, dims) {
            boxes.push(box(width: container.width, stroke: red)[#text(fill: red)[#content]])
            boxes.push([\ ])
          }
          place(top + left)[#table(..boxes, inset: 0pt, stroke: none)]
          place(top + left)[#box(width: dims.width, height: dims.height * 2, stroke: black)[#ct]]
        }
      }],)
    }
  )
}

#test-case[#lorem(35)]

// Caveat: remember to put the #layout(_ => {}) call at the right location...
= Alignment test (upfront, relative boxes, truncation)

#let test-case(ct) = {
  table(
    columns: (1fr, 1fr, 1fr, 1fr, 1fr),
    ..{
      for height in (50%, 52%, 54%, 56%, 58%,) {
        let dims = (height: height, width: 100%)
        (box(height: 10cm)[#layout(size => {
          let boxes = ()
          for (container, content) in fill-boxes(ct, dims, dims, size: size) {
            boxes.push(box(width: container.width, stroke: red)[#text(fill: red)[#content]])
            boxes.push([\ ])
          }
          place(top + left)[#for box in boxes { box }]
          place(top + left)[#box(width: dims.width, height: 100%, stroke: black)[#ct]]
        })],)
      }
    }
  )
}

//#layout(size => panic(measure(box(width: 100%), ..size)))

#test-case[#lorem(35)]