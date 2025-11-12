#let opt = {
  let pre() = {}
  let post() = {}
  (pre: pre, post: post)
}

#let flow = {
  let content() = {}
  let colbreak() = {}
  let colfill() = {}
  (content: content, colbreak: colbreak, colfill: colfill)
}

#let elt = {
  let placed() = {}
  let container() = {}
  let pagebreak() = {}
  (placed: placed, container: container, pagebreak: pagebreak)
}
