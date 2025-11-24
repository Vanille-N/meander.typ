#import "/src/lib.typ" as meander

// Motivated by https://forum.typst.app/t/is-there-an-equivalent-to-latex-s-parshape/1006

#set page(width: 23cm, height: 25cm)
#set par(justify: true)
#set text(size: 15pt)

#let nonsense = [We thrive in information-thick worlds because of our marvelous and everyday capacity to select, edit, single out, structure, highlight, group, pair, merge, harmonize, synthesize, focus, organize, condense, reduce, boil down, choose, categorize, catalog, classify, list, abstract, scan, look into, idealize, isolate, discriminate, distinguish, screen, pigeonhole, pick over, sort, integrate, blend, inspect, filter, lump, skip, smooth, chunk, average, approximate, cluster, aggregate, outline, summarize, itemize, review, dip into, flip through, browse, glance into, leaf through, skim, refine, enumerate, glean, synopsize, winnow the wheat from the chaff and separate the sheep from the goats.]

#meander.reflow({
  import meander: *
  placed(top + left,
    rotate(-90deg, reflow: true)[#image("image.png")],
    boundary: contour.width(div: 30, flush: left, y => {
      let r = if y <= 0.25 {
        1
      } else if y <= 0.50 {
        0.75
      } else if y <= 0.75 {
        1
      } else {
        0.3 + 3 * (1 - y)
      }
      (0, r)
    }),
  )
  container()
  content[#nonsense #nonsense]
})
