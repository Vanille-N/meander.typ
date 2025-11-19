#import "/src/types.typ"

/*
#let full-page() = {
  ((type: types.opt.pre, field: "full-page", payload: true),)
}
*/

#let no-spacing() = {
  ((type: types.opt.post, field: "virtual-spacing", payload: false),)
}

#let no-outset() = {
  ((type: types.opt.pre, field: "no-outset", payload: true),)
}

#let default = (
  //full-page: false,
  virtual-spacing: true,
  no-outset: false,
)
