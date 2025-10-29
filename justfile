typstc cmd file fmt="pdf":
  typst {{ cmd }} --root=. --font-path=. {{ file }} {{ replace(file, ".typ", "." + fmt) }}

doc: (typstc "watch" "docs/docs.typ")

figs force="":
  cd docs && if [ "{{force}}" = force ]; then touch figs/_preamble.typ; fi && make figs
  convert -resize 50% docs/figs/multi-obstacles.svg gallery/multi-obstacles.png
  convert -resize 50% docs/figs/two-columns.svg gallery/two-columns.png
  convert -resize 50% docs/figs/circle-hole.svg gallery/circle-hole.png
  convert -resize 50% docs/figs/overflow-text/doc.1.svg gallery/placement-1.png
  convert -resize 50% docs/figs/overflow-text/doc.2.svg gallery/placement-2.png

test T: (typstc "watch" "tests/"+T+"/test.typ")

example T fmt="pdf": (typstc "watch" "examples/"+T+"/main.typ" fmt)

issue N mode="watch" fmt="pdf": (typstc mode "issues/"+N+".typ" fmt)

scrybe:
  scrybe gallery/*.typ README.md typst.toml docs/*.typ --version=0.2.4

scrybe-publish:
  scrybe release/README.md release/typst.toml --publish --version=0.2.4

publish:
  mkdir -p release
  rm -rf release/*
  cp -r src release/
  cp README.md LICENSE typst.toml release/
  mkdir release/gallery
  cp gallery/*.png release/gallery/

