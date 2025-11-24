#import "/src/types.typ"

#let ignore() = {
  ((type: types.opt.post, field: "overflow", payload: (fun: _ => {})),)
}

#let repeat(count: 1,) = {
  ((type: types.opt.post, field: "overflow", payload: (repeat: (count: count,))),)
}

#let alert() = {
  ((type: types.opt.post, field: "overflow", payload: (alert: none)),)
}

#let custom(fun) = {
  ((type: types.opt.post, field: "overflow", payload: (fun: fun)),)
}

#let state(state) = {
  let state = if type(state) == std.state { state } else { std.state(state) }
  ((type: types.opt.post, field: "overflow", payload: (state: state)),)
}

#let pagebreak() = {
  ((type: types.opt.post, field: "overflow", payload: (fun: data => {
    std.colbreak
    data.styled
  })))
}

#let default = (
  overflow: (fun: data => data.styled),
)
