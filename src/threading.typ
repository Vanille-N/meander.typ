#import "geometry.typ"
#import "elems.typ"
#import "tiling.typ"
#import "types.typ"
#import "bisect.typ" as bisect-mod

/// The paragraphs of a piece of content, one entry each.
///
/// Recognises both shapes prose comes in: an explicit `par` element, and a run
/// of inline content delimited by `parbreak`s, which is what markup produces —
/// markup carries no `par` elements at all.
/// -> (..content,)
#let paragraphs-of(ct) = {
  let leaves-of(ct) = if ct == none {
    ()
  } else if ct.func() == par {
    // A paragraph is a leaf here: descending into its body would hide it.
    (ct,)
  } else if ct.has("children") {
    ct.children.map(leaves-of).flatten()
  } else if ct.has("body") {
    leaves-of(ct.body)
  } else if ct.has("child") {
    leaves-of(ct.child)
  } else {
    (ct,)
  }
  let out = ()
  let current = ()
  for leaf in leaves-of(ct) {
    if leaf.func() == parbreak {
      if current.len() > 0 { out.push(current.join()) }
      current = ()
    } else if leaf.func() == par {
      if current.len() > 0 { out.push(current.join()) }
      current = ()
      out.push(leaf)
    } else {
      current.push(leaf)
    }
  }
  if current.len() > 0 { out.push(current.join()) }
  out
}

/// Whether a split fell inside a paragraph rather than between two.
///
/// The halves of a paragraph that was cut are, between them, one paragraph more
/// than the content they came from; a split that lands on a paragraph boundary
/// conserves the count.
/// -> bool
#let cuts-a-paragraph(input, fits, overflow) = {
  paragraphs-of(fits).len() + paragraphs-of(overflow).len() > paragraphs-of(input).len()
}

/// #property(requires-context: true)
/// Thread text through a list of boxes in order,
/// allowing the boxes to stretch vertically to accomodate for uneven tiling.
///
/// -> (full: , overflow: overflow)
#let smart-fill-boxes(
  /// Flowing text.
  /// -> content
  body,
  /// An array of @type:block to avoid.
  /// -> (..block,)
  avoid: (),
  /// An array of @type:block to fill.
  ///
  /// The #arg[bound] parameter of @type:block is used to know how much
  /// the container is allowed to stretch.
  ///
  /// -> (..block,)
  boxes: (),
  /// Dimensions of the container as given by #typ.layout.
  /// -> size
  size: none,
  /// Whether these are the last boxes of the page, so that a split here ends
  /// a page or column rather than merely changing the measure.
  /// -> bool
  final: false,
  /// The width text carried out of this page will be set at, which is the first
  /// box of the page that follows. Defaults to this page's own width.
  /// -> length
  next-width: none,
) = {
  assert(size != none)
  let text-size = text.size
  let par-leading = par.leading

  let full = ()
  let last-box = none

  let body-queue = body.rev()
  let body = (data: none)
  let cont-queue = boxes.rev()
  let cont = none
  let current-fill = none
  let force-break = false

  let cuts = ()

  while true {
    if cont == none {
      if cont-queue.len() == 0 { break }
      cont = cont-queue.pop()
    }
    if body.data == none {
      if body-queue.len() == 0 { break }
      body = body-queue.pop()
    }

    if body.type == types.flow.colfill {
      cuts.push(current-fill)
      full.push((cont, current-fill))
      while cont-queue.len() > 0 {
        full.push((cont-queue.pop(), none))
      }
      break
    }
    if body.type == types.flow.colbreak {
      force-break = true
    }

    if current-fill == none {
      text-size = body.style.at("size", default: text.size)
      par-leading = body.style.at("leading", default: par.leading)
    }
    // Leave it a little room
    // 0.5em margin at the bottom to let it potentially add an extra line
    let old-lo = calc.min(cont.y + cont.height, cont.bounds.y + cont.bounds.height)
    let new-lo = old-lo + geometry.resolve(size, y: 0.5 * text-size).y
    new-lo = calc.min(new-lo, cont.bounds.y + cont.bounds.height)
    for no-box in avoid {
      if tiling.is-ignored(cont, no-box) { continue }
      if geometry.intersects((cont.x, cont.x + cont.width), (no-box.x, no-box.x + no-box.width), tolerance: 1mm) {
        if geometry.intersects((old-lo, new-lo), (no-box.y, no-box.y), tolerance: 0mm) {
          new-lo = calc.min(new-lo, no-box.y)
        }
      }
    }
    cont.height = new-lo - cont.y
    // As much as it wants on the top to fill previously unused space
    let old-hi = cont.y
    let new-hi = cont.bounds.y
    let lineskip = geometry.resolve(size, y: par-leading.em * text-size + par-leading.abs).y
    let lo = cont.y + cont.height
    for no-box in avoid {
      if tiling.is-ignored(cont, no-box) { continue }
      if new-hi > lo { continue }
      if geometry.intersects((cont.x, cont.x + cont.width), (no-box.x, no-box.x + no-box.width), tolerance: 1mm) {
        if geometry.intersects((new-hi, lo), (no-box.y, no-box.y + no-box.height), tolerance: 0.1pt) {
          new-hi = calc.max(new-hi, no-box.y + no-box.height)
        }
      }
    }
    for (full-box,_) in full {
      if new-hi > lo { continue }
      if geometry.intersects((cont.x, cont.x + cont.width), (full-box.x, full-box.x + full-box.width), tolerance: 1mm) {
        if geometry.intersects((new-hi, lo), (full-box.y, full-box.y + full-box.height + lineskip), tolerance: 0.1pt) {
          new-hi = calc.max(new-hi, full-box.y + full-box.height + lineskip)
        }
      }
    }
    if new-hi > lo {
      // Drop this box
      cont = none
      continue
    }
    cont.y = new-hi
    cont.height = lo - new-hi

    import "bisect.typ" as bisect
    let max-dims = measure(box(height: cont.height, width: cont.width), ..size)
    let box-input = [#current-fill] + [#body.data]
    let (fits, overflow) = bisect.fill-box(max-dims, size: size, cfg: body.style, box-input)
    if fits == none {
      // Drop this box
      cont = none
      continue
    }
    if overflow == none and body-queue.len() > 0 and not force-break {
      // It all fits, try more
      current-fill = fits
      body.data = none
      continue
    }
    let actual-dims = measure(box(width: cont.width)[#fits], ..size)
    if actual-dims.height < 1mm {
      // Drop this box
      cont = none
      continue
    }
    cont.width = actual-dims.width
    cont.height = actual-dims.height
    cuts.push(fits)
    full.push((cont, fits))
    last-box = (cont: cont, dims: max-dims, input: box-input, fits: fits)
    current-fill = none
    body.data = overflow
    if force-break {
      break
    }
  }
  // A split at the end of a page is a page or column turn, and must not leave
  // a paragraph with fewer than `min-lines` on either side. Splits between
  // boxes are not turns and are left alone.
  let min-lines = 2
  if final and last-box != none and body.data != none {
    let leading = geometry.resolve(size, y: par-leading.em * text-size + par-leading.abs).y
    let base-line = measure[X].height
    // The number of lines a fragment occupies at a given width: `n` lines stand
    // `n` line heights and `n - 1` leadings tall.
    //
    // The height of one line is taken from the fragment itself, measured where
    // it cannot wrap, so that text set at another size is counted against its
    // own size rather than the surrounding text's. That measurement is of a line holding
    // everything, though, so for a fragment whose lines differ — one carrying
    // something tall among plain ones — it is the tallest line rather than a
    // typical one, and dividing by it would undercount. The surrounding line
    // height bounds it below, which leaves the estimate erring towards more
    // lines than there are: a miscount then costs a correction that was not
    // made, rather than one made where the text was already fine.
    let lines-of(ct, width) = if ct == none {
      0
    } else {
      let one = calc.min(measure(box(width: 100000pt, ct)).height, base-line)
      if one <= 0pt { return 0 }
      calc.round((measure(box(width: width, ct)).height + leading) / (one + leading))
    }
    let carried-width = if next-width == none { size.width } else { next-width }
    let strands(fits, rest, width) = {
      if not cuts-a-paragraph(last-box.input, fits, rest) { return false }
      let kept = paragraphs-of(fits)
      let carried = paragraphs-of(rest)
      // Nothing on one side means nothing to strand there.
      if kept.len() == 0 or carried.len() == 0 { return false }
      // `text.costs` gives these as ratios of the default penalty, but for
      // widows and orphans the setting is currently all or nothing.
      let costs = text.costs
      ((costs.orphan != 0% and lines-of(kept.last(), width) < min-lines)
        or (costs.widow != 0% and lines-of(carried.first(), carried-width) < min-lines))
    }
    let width = last-box.cont.width
    if strands(last-box.fits, body.data, width) {
      // Walk the split back by refilling this box alone, a line shorter each
      // time. Two steps is the useful range.
      let taken = none
      // At most as many steps as the minimum itself: a split still stranding a
      // line once `min-lines` have moved down will not be helped by another.
      for step in range(1, min-lines + 1) {
        // Shortened by a line of the paragraph being moved, measured from that
        // paragraph rather than from the surrounding text size. Here the tallest
        // line is what is wanted, not the shortest: taking less than a full line
        // off the box might not move the split at all.
        let fragment = paragraphs-of(last-box.fits).last()
        let one-line = measure(box(width: 100000pt, fragment)).height + leading
        let dims = (width: last-box.dims.width, height: last-box.dims.height - step * one-line)
        let (fits, rest) = bisect-mod.fill-box(dims, size: size, cfg: body.style, last-box.input)
        if fits == none { break }
        if not strands(fits, rest, width) {
          taken = (fits: fits, rest: rest)
          break
        }
      }
      if taken != none {
        let cont = last-box.cont
        let actual = measure(box(width: cont.width)[#taken.fits], ..size)
        cont.height = actual.height
        cuts.at(cuts.len() - 1) = taken.fits
        full.at(full.len() - 1) = (cont, taken.fits)
        body.data = taken.rest
      }
    }
  }
  let overflow = body-queue
  if body.data != none { overflow.push(body) }
  (full: full, overflow: overflow.rev(), cuts: cuts)
}

