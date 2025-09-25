#import "tiling.typ"
#import "threading.typ"
#import "elems.typ"

/// Debug version of the toplevel `reflow`,
/// that only displays the partitioned layout.
/// -> content
#let regions(
  /// Input sequence to segment.
  /// Constructed from `placed`, `container`, and `content`.
  /// -> seq
  seq,
  /// Whether to show the placed objects (`true`),
  /// or only their hitbox (`false`).
  /// -> bool
  display: true,
  /// Controls relation to other content on the page.
  /// See analoguous `placement` option on `reflow`.
  placement: page,
) = {
  // TODO: extract to aux function. Same for `reflow`.
  let wrapper(inner) = {
    if placement == page {
      set block(spacing: 0em)
      layout(size => inner(size))
    } else if placement == float {
      place(top + left)[
        #box(width: 100%, height: 100%)[
          #layout(size => inner(size))
        ]
      ]
    } else if placement == box {
      layout(size => inner(size))
    } else {
      panic("Invalid placement option")
    }
  }
  wrapper(size => {
    let (pages,) = tiling.separate(seq)
    for (idx, elems) in pages.enumerate() {
      if idx != 0 {
        colbreak()
      }
      let data = tiling.create-data(size: size, elems: elems)
      while true {
        // Compute
        let (elem, _data) = tiling.next-elem(data)
        if elem == none { break }
        data = _data

        // Show
        if display { elem.display }
        elem.debug

        // Record
        data = tiling.push-elem(data, elem)
      }
    }
  })
}

/// Segment the input sequence according to the tiling algorithm,
/// then thread the flowing text through it.
///
/// -> content
#let reflow(
  /// See module `tiling` for how to format this content.
  /// -> seq
  seq,
  /// Whether to show the boundaries of boxes.
  /// -> bool
  debug: false,
  /// Controls the behavior in case the content overflows the provided
  /// containers.
  /// - `false` -> adds a warning box to the document
  /// - `true` -> ignores any overflow
  /// - `pagebreak` -> the text that overflows is simply placed normally on the next page
  /// - `panic` -> refuses to compile the document
  /// - any `content => content` function -> uses that for formatting
  /// -> any
  overflow: false,
  /// Relationship with the rest of the content on the page.
  /// - `page`: content is not visible to the rest of the layout, and will be placed
  ///   at the current location. Supports pagebreaks.
  /// - `box`: meander will simulate a box of the same dimensions as its contents
  ///   so that normal text can go before and after. Supports pagebreaks.
  /// - `float`: similar to `page` in that it is invisible to the rest of the content,
  ///   but always placed at the top left of the page. Does not support pagebreaks.
  placement: page,
) = {
  let wrapper(inner) = {
    if placement == page {
      // TODO: there's a bug here visible in section IV.b of the docs
      set block(spacing: 0em)
      layout(size => inner(size))
    } else if placement == float {
      place(top + left)[
        #box(width: 100%, height: 100%)[
          #layout(size => inner(size))
        ]
      ]
    } else if placement == box {
      layout(size => inner(size))
    } else {
      panic("Invalid placement option")
    }
  }
  wrapper(size => {
    let (flow, pages) = tiling.separate(seq)

    for (idx, elems) in pages.enumerate() {
      let maximum-height = 0pt
      if idx != 0 {
        if placement == float {
          panic("Pagebreaks are only supported when the placement is 'page' or 'box'")
        }
        colbreak()
      }
      let data = tiling.create-data(size: size, elems: elems)
      while true {
        // Compute
        let (elem, _data) = tiling.next-elem(data)
        if elem == none { break }
        data = _data

        if elem.type == place {
          elem.display
          if debug { elem.debug }
          data = tiling.push-elem(data, elem)
          for block in elem.blocks {
            maximum-height = calc.max(maximum-height, block.y + block.height)
          }
          continue
        }
        assert(elem.type == box)
        let (full, overflow) = threading.smart-fill-boxes(
          size: size,
          avoid: data.obstacles,
          boxes: elem.blocks,
          flow,
        )
        flow = overflow
        for (container, content) in full {
          for (key, val) in container.aux.style {
            if key == "align" {
              content = align(val, content)
            } else if key == "text-fill" {
              content = text(fill: val, content)
            } else {
              panic("Container does not support the styling option '" + key + "'")
            }
          }
          // TODO: this needs a new push-elem, but with the actual dimensions not the original ones.
          place(dx: container.x, dy: container.y, {
            box(width: container.width, height: container.height, stroke: if debug { green } else { none }, {
              content
            })
          })
          data = tiling.push-elem(data, (blocks: (tiling.add-self-margin(container),)))
          maximum-height = calc.max(maximum-height, container.y + container.height)
        }
      }
      // This box fills the space occupied by the meander canvas,
      // and thus fills the same vertical space, allowing surrounding text
      // to fit before and after.
      if placement == box {
        box(width: 100%, height: maximum-height)
      }
    }
    // Prepare data for the overflow handler
    if flow != () {
      if overflow == false {
        place(top + left)[#box(width: 100%, height: 100%)[
          #place(bottom + right)[
            #box(fill: red, stroke: black, inset: 2mm)[
              #align(center)[
                *Warning* \
                This container is insufficient to hold the full text. \
                Consider adding more containers or a `pagebreak`.
              ]
            ]
          ]
        ]]
      } else if overflow == true {
        // Ignore
      } else if overflow == text {
        for ct in flow {
          // TODO: apply the styles
          ct.data
        }
      } else if overflow == std.pagebreak or overflow == elems.pagebreak {
        colbreak()
        for ct in flow {
          // TODO: apply the styles
          ct.data
        }
      } else if overflow == panic {
        panic("The containers provided cannot hold the remaining text: " + repr(flow))
      } else if type(overflow) == function {
        overflow((
          raw: flow,
          structured: {
            // TODO: apply the styles
            for ct in flow {
              elems.content(ct.data)
            }
          },
          styled: {
            // TODO: apply the styles
            for ct in flow {
              ct.data
            }
          },
        ))
      } else {
        panic("Not a valid value for overflow")
      }
    }
  })
}

