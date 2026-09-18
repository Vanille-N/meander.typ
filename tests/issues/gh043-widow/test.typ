#import "/src/lib.typ" as meander

#set page(width: 11cm, height: 5.3cm, margin: 0.8cm)
#set par(justify: true, leading: 0.5em, spacing: 0.9em, first-line-indent: (amount: 1em, all: true))
#set text(size: 9pt)

#let body = {
  par[Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod
      tempor incididunt ut labore et dolore magnam aliquam quaerat voluptatem.]
  par[Ut enim aeque doleamus animo, cum corpore dolemus, fieri tamen permagna
      accessio potest, si aliquod aeternum et infinitum impendere malum nobis
      opinemur. Quod idem licet transferre in voluptatem, ut postea variari.]
  par[Voluptas distinguique possit, augeri amplificarique non possit. At etiam
      Athenis, ut e patre audiebam facete et urbane Stoicos irridente, statua est
      in quo a nobis philosophia defensa et collaudata est, cum id quod maxime.]
}

#let demo(extra) = meander.reflow({
  import meander: *
  placed(top + right, rect(width: 3.5cm, height: 2cm, fill: silver))
  container()
  content(body)
  extra
})

// Off by default: the region runs out in the middle of the third paragraph and
// leaves its first line behind.
#demo(())

#pagebreak()

// Asked for, the whole paragraph moves on instead, as it would in ordinary
// flow, and the room it would have taken is left blank.
#demo(meander.opt.widows.avoid())

#pagebreak()

// `text.costs` set to zero asks for the avoidance to be switched off, and the
// paragraph is split where the region ends even though it was asked for.
#[
  #set text(costs: (widow: 0%, orphan: 0%))
  #demo(meander.opt.widows.avoid())
]

#pagebreak()

// The text carried over is set beside a float at the top of the next region, so
// it makes more lines there than it would at the full width. The check measures
// it at the width it will actually get.
#meander.reflow({
  import meander: *
  placed(top + right, rect(width: 3.5cm, height: 2cm, fill: silver))
  container()
  pagebreak()
  placed(top + left, rect(width: 6cm, height: 2.4cm, fill: olive))
  container()
  content(body)
  meander.opt.widows.avoid()
})
