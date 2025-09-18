#let new-stuff = state("new-stuff", (:))

#let new(tag) = {
  let label = label(tag)
  [#new-stuff.update(news => {
    news.insert(tag, label)
    news
  }) #label]
}

#let print(version) = context {
  let news = new-stuff.final()
  if news == (:) { return }
  [What's new since #version? ]
  news.pairs().map(((tag, label),) => link(label)[#tag]).join(", ")
}
