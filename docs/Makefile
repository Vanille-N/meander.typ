figs/%.svg: figs/%.typ figs/_preamble.typ
	typst compile --format=svg --root=.. $< $@

FIGS=$(wildcard figs/[^_]*.typ)

figs/two-pages/doc.1.svg: figs/two-pages/doc.typ figs/_preamble.typ
	typst compile --format=svg --root=.. $< "figs/two-pages/doc.{p}.svg"

figs/junction/doc.1.svg: figs/junction/doc.typ figs/_preamble.typ
	typst compile --format=svg --root=.. $< "figs/junction/doc.{p}.svg"

figs: $(FIGS:%.typ=%.svg) figs/two-pages/doc.1.svg figs/junction/doc.1.svg

loop-figs:
	while true; do make figs; sleep 0.1; done
