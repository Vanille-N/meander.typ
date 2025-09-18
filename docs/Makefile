figs/%.svg: figs/%.typ figs/_preamble.typ
	typst compile --format=svg --root=.. $< $@

figs/%.1.svg: figs/%.typ figs/_preamble.typ
	typst compile --format=svg --root=.. $< "figs/$*.{p}.svg"

FIGS=$(wildcard figs/[^_]*.typ)
DIRS=$(wildcard figs/*/)

$(info $(DIRS))

figs: $(FIGS:%.typ=%.svg) $(DIRS:%=%doc.1.svg)

loop-figs:
	while true; do make figs; sleep 0.1; done
