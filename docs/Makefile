figs/%.svg: figs/%.typ figs/_preamble.typ
	typst compile --format=svg --root=.. $< $@

FIGS=$(wildcard figs/[^_]*.typ)

figs: $(FIGS:%.typ=%.svg)

loop-figs:
	while true; do make figs; sleep 0.1; done
