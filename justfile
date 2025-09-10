typstc cmd file fmt="pdf":
  typst {{ cmd }} --root=. {{ file }} {{ replace(file, ".typ", "." + fmt) }}

doc: (typstc "watch" "docs/main.typ")

figs force="":
  cd docs && if [ "{{force}}" = force ]; then touch figs/_preamble.typ; fi && watch make figs
  cp docs/figs/multi-obstacles.svg gallery/
  cp docs/figs/two-columns.svg gallery/
  cp docs/figs/circle-hole.svg gallery/

test T: (typstc "watch" "tests/"+T+"/test.typ")

example T: (typstc "watch" "examples/"+T+"/main.typ")

scrybe:
  scrybe gallery/*.typ README.md typst.toml --version=0.2.0

scrybe-publish:
  scrybe release/README.md release/typst.toml --publish --version=0.2.0

publish:
  mkdir -p release
  rm -rf release/*
  cp -r src release/
  cp README.md LICENSE typst.toml release/
  mkdir release/gallery
  cp gallery/*.svg release/gallery/

