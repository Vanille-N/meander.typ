#let new-sections = state("new-sections", (:))

#let tagged(hl) = (sec) => {
  sec
  new-sections.update(secs => {
    let body = if sec.func() == heading {
      sec.body
    } else if sec.func() == [a:].func() {
      sec.children.at(0).body
    } else {
      panic(sec)
    }
    secs.insert(body.text, hl)
    secs
  })
}

#let styles = (
  new: it => [#highlight(fill: green.transparentize(70%), it)#text(fill: green, super[*(+)*])],
  major: it => [#highlight(fill: orange.transparentize(70%), it)#text(fill: orange, super[*(!!)*])],
  minor: it => [#highlight(fill: yellow.transparentize(70%), it)#text(fill: yellow, super[*(!)*])],
  breaking: it => [#highlight(fill: red.transparentize(70%), it)#text(fill: red, super[*(#sym.arrow.zigzag)*])]
)

#let new = tagged(styles.new)
#let minor = tagged(styles.minor)
#let major = tagged(styles.major)
#let breaking = tagged(styles.breaking)

#let highlight-outline-entries(doc) = {
  show outline.entry: it => {
    context {
      let secs = new-sections.final()
      if it.element.body.text in secs {
        show it.element.body.text: it2 => {
          (secs.at(it.element.body.text))(it2)
        }
        it
      } else {
        it
      }
    }
  }
  doc
}


