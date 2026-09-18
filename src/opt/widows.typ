#import "/src/types.typ"

/// Keep the split at the end of a page or column from leaving a paragraph with
/// a single line on either side of it, as Typst does in ordinary flow.
///
/// Off by default: it can move a line onto the next page, and so change where
/// a reflow that was laid out without it breaks.
///
/// Splits that merely change the measure, where text passes an obstacle, are
/// never affected — only the split that ends a page or column.
/// -> option
#let avoid() = {
  ((type: types.opt.post, field: "widows", payload: (avoid: true)),)
}

/// Split at the end of a page or column wherever the text happens to reach,
/// which is the default.
/// -> option
#let allow() = {
  ((type: types.opt.post, field: "widows", payload: (avoid: false)),)
}

#let default = (
  widows: (avoid: false),
)
