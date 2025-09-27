/// Use ```typ #std.pagebreak()``` if an ```typ #import meander: *```
/// has shadowed the builtin `pagebreak`.
/// -> content
#let pagebreak = pagebreak

/// Use ```typ #std.colbreak()``` if an ```typ #import meander: *```
/// has shadowed the builtin `colbreak`.
/// -> content
#let colbreak = colbreak

/// Use ```typc std.content``` if an ```typ #import meander: *```
/// has shadowed the builtin `content`.
/// -> type
#let content = content

/// Use ```typc #std.grid(..)``` if an ```typ #import meander.contour: *```
/// has shadowed the builtin `grid`.
/// -> function
#let grid = grid
