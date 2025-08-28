/*#let word-fits-inside(dims, ct, cfg, size: (:)) = {
  let content = measure(ct, ..size)
  let container = measure(box(width: dims.width, height: dims.height), ..size) // resolves relative width in dims
  if (not cfg.allow-horiz-overflow) and (content.width > container.width) {
    return false
  }
  content.height <= container.height
}*/

#let fits-inside(dims, ct, cfg, size: (:)) = {
  let content = measure(box(width: dims.width)[#ct], ..size)
  let container = measure(box(width: dims.width, height: dims.height), ..size) // resolves relative width in dims
  content.height <= container.height
}

#let default-rebuild(ct, inner-field) = {
  let fields = ct.fields()
  let inner = fields.remove(inner-field)
  let number = if "number" in fields { (fields.remove("number"),) } else { () }
  let styles = if "styles" in fields { (fields.remove("styles"),) } else { () }
  let rebuild(inner) = {
    let pos = (inner, ..number, ..styles)
    ct.func()(..fields, ..pos)
  }
  (inner, rebuild)
}

#let take-it-or-leave-it(ct, fits-inside) = {
  if fits-inside(ct) {
    (ct, none)
  } else {
    (none, ct)
  }
}

#let has-text(ct, split-dispatch, fits-inside, cfg) = {
  let (inner, rebuild) = default-rebuild(ct, "text")
  let inner = inner.split(" ")
  if not fits-inside([]) {
    return (none, ct)
  }
  for i in range(inner.len()) {
    if fits-inside(rebuild(inner.slice(0, i + 1).join(" "))) {
      continue
    } else {
      let left = rebuild(inner.slice(0, i).join(" "))
      assert(fits-inside(left))
      let right = rebuild(inner.slice(i).join(" "))
      return (left, right)
    }
  }
  return (rebuild(inner.join(" ")), none)
}

#let has-child(ct, split-dispatch, fits-inside, cfg) = {
  let (inner, rebuild) = default-rebuild(ct, "child")
  let (left, right) = split-dispatch(inner, ct => fits-inside(rebuild(ct)), cfg)
  assert(fits-inside(rebuild(left)))
  (rebuild(left), rebuild(right))
}

#let has-children(ct, split-dispatch, fits-inside, cfg) = {
  let (inner, rebuild) = default-rebuild(ct, "children")
  if not fits-inside([]) { return (none, ct) }
  for i in range(inner.len()) {
    // If inner.at(i) fits, take it
    if fits-inside(rebuild(inner.slice(0, i + 1))) {
      continue
    } else {
      // Otherwise try to split it
      let hanging = inner.at(i)
      let (left, right) = split-dispatch(hanging, ct => fits-inside(rebuild((..inner.slice(0, i), ct))), cfg)
      assert(fits-inside(rebuild((..inner.slice(0, i), left))))
      let left = rebuild({
        if left == none {
          if i == 0 {
            return (none, rebuild(inner))
          } else {
            inner.slice(0, i)
          }
        } else {
          (..inner.slice(0, i), left)
        }
      })
      let right = rebuild({
        if right == none {
          inner.slice(i + 1)
        } else {
          (right, ..inner.slice(i + 1))
        }
      })
      return (left, right)
    }
  }
  return (rebuild(inner), none)
}

#let has-body(ct, split-dispatch, fits-inside, cfg) = {
  if ct.func() == list.item {
    let (inner, rebuild) = default-rebuild(ct, "body")
    let (left, right) = {
      let cfg = cfg
      cfg.list-depth += 1
      split-dispatch(inner, ct => fits-inside(rebuild(ct)), cfg)
    }
    let left = if left == none { none } else {
      assert(fits-inside(rebuild(left)))
      rebuild(left)
    }
    let right = if right == none {
      none
    } else if left == none {
      rebuild(right)
    } else {
      // Here we need to do some magic to handle list items that were split in half.
      if cfg.list-depth >= cfg.list-markers.len() {
        panic("Not enough list markers. Decrease nesting or provide `cfg.list-markers`")
      }
      for i in range(cfg.list-depth + 1) {
        cfg.list-markers.at(i) = h(0.5em)
      }
      // TODO: improve the ad-hoc spacing
      [#set list(marker: cfg.list-markers); #rebuild(right)]
    }
    (left, right)
  } else if ct.func() == enum.item {
    let (inner, rebuild) = default-rebuild(ct, "body")
    let (left, right) = {
      let cfg = cfg
      cfg.enum-depth += 1
      split-dispatch(inner, ct => fits-inside(rebuild(ct)), cfg)
    }
    let left = if left == none { none } else {
      assert(fits-inside(rebuild(left)))
      rebuild(left)
    }
    let right = if right == none {
      none
    } else if left == none {
      rebuild(right)
    } else {
      // Again, some magic to simulate a `enum.item` split in half
      if cfg.enum-depth >= cfg.enum-numbering.len() {
        panic("Not enough enum markers. Decrease nesting or provide `cfg.enum-numbering`")
      }
      for i in range(cfg.enum-depth + 1) {
        cfg.enum-numbering.at(i) = ""
      }
      let numbering = (..nums) => {
        let nums = {
          if nums.pos().len() <= cfg.enum-depth {
            ()
          } else {
            nums.pos().slice(cfg.enum-depth + 1)
          }
        }
        if nums == () {
          h(0.7em) // TODO: improve the ad-hoc spacing
        } else {
          numbering(cfg.enum-numbering.join(""), ..nums)
        }
      }
      // TODO: improve the ad-hoc spacing
      [#set enum(full: true, numbering: numbering); #rebuild(right)]
    }
    (left, right)
  } else if ct.func() in (strong, emph, underline, stroke, overline, highlight) {
    let (inner, rebuild) = default-rebuild(ct, "body")
    let (left, right) = split-dispatch(inner, ct => fits-inside(rebuild(ct)), cfg)
    assert(fits-inside(rebuild(left)))
    (rebuild(left), rebuild(right))
  } else {
    take-it-or-leave-it(ct, fits-inside)
  }
}

#let dispatch(ct, fits-inside, cfg) = {
  if ct.has("text") {
    has-text(ct, dispatch, fits-inside, cfg)
  } else if ct.has("child") {
    has-child(ct, dispatch, fits-inside, cfg)
  } else if ct.has("children") {
    has-children(ct, dispatch, fits-inside, cfg)
  } else if ct.has("body") {
    has-body(ct, dispatch, fits-inside, cfg)
  } else {
    // This item is not splittable
    take-it-or-leave-it(ct, fits-inside)
  }
}

#let fill-box(dims, ct, size: (:), cfg: (:)) = {
  if "list-markers" not in cfg {
    cfg.insert("list-markers", ([•], [‣], [–]) * 2)
  }
  cfg.insert("list-depth", 0)
  if "enum-numbering" not in cfg {
    cfg.insert("enum-numbering", ("1.",) * 6)
  }
  cfg.insert("enum-depth", 0)
  if "allow-horiz-overflow" not in cfg {
    cfg.insert("allow-horiz-overflow", false)
  }
  dispatch(ct, ct => fits-inside(dims, ct, cfg, size: size), cfg)
}

#let test-case(ct) = {
  let dims = (width: 5cm, height: 5cm)
  context {
    [#{(ct,)}]
    let (fit, rest) = fill-box(dims, ct)
    table(
      columns: 2,
      box(..dims, stroke: green)[#fit],
      box(stroke: orange)[#rest],
    )
  }
}

#test-case[]

#test-case[ ]

#test-case[#h(1em)]

#test-case[

]

#test-case[#lorem(50)]

#test-case(text(fill: red)[#lorem(50)])

#test-case[
  #lorem(50)
]

#test-case[
  #for i in range(8) {
    text(size: 7pt)[#lorem(5) ]
    text(size: 11pt)[#lorem(5) ]
  }
]

#test-case[
  #lorem(10) #lorem(10) #lorem(10) #lorem(10) #lorem(10) #lorem(10)
]

#test-case[
  *#lorem(50)*
]

#test-case[
  _#lorem(50)_
]

#test-case[
  = #lorem(30)
]

#test-case[
  - #lorem(10)
  - #lorem(50)
  - #lorem(10)
]

#test-case[
  + #lorem(10)
  + #lorem(50)
  + #lorem(10)
]

#test-case[
  - 1 #lorem(5)
  - 2 #lorem(10)
  - 3 #lorem(10)
  - 4 #lorem(10)
  - 5 #lorem(10)
  - 6 #lorem(10)
]

#test-case[
  + 1 #lorem(5)
  + 2 #lorem(10)
  + 3 #lorem(10)
  + 4 #lorem(10)
    #lorem(10)
  + 5 #lorem(10)
]

#test-case[
  - #lorem(20)
  - #lorem(10)
    - #lorem(10)
    - #lorem(3)
  - #lorem(3)
]

// TODO: see if I can fix the numbering pattern
#test-case[
  + #lorem(10)
  + #lorem(10)
  + #lorem(10)
    + #lorem(10)
    + #lorem(10)
  + #lorem(10)
]

#test-case[
  1. #lorem(20)
  2. #lorem(20)
  3. #lorem(20)
]

