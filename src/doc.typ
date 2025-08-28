#import "@preview/tidy:0.4.3"

#let parse-and-show(path, header) = {
  header
  import path as mod
  let docs = tidy.parse-module(
    read(path),
    scope: (mod: mod),
    preamble: "#import mod: *;"
  )
  tidy.show-module(docs, style: tidy.styles.default)
}

= Module documentation

#parse-and-show("geometry.typ")[
  == Geometry (`geometry.typ`)
  Generalist functions for 1D and 2D geometry.
]

#parse-and-show("tiling/default.typ")[
  == Tiling (`tiling/default.typ`)
]

