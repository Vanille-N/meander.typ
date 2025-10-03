typstc cmd file fmt="pdf":
  typst {{ cmd }} --root=. --font-path=. {{ file }} {{ replace(file, ".typ", "." + fmt) }}

doc: (typstc "watch" "docs/docs.typ")

figs force="":
  cd docs && if [ "{{force}}" = force ]; then touch figs/_preamble.typ; fi && make figs
  convert docs/figs/multi-obstacles.svg gallery/multi-obstacles.png
  convert docs/figs/two-columns.svg gallery/two-columns.png
  convert docs/figs/circle-hole.svg gallery/circle-hole.png

test T: (typstc "watch" "tests/"+T+"/test.typ")

example T fmt="pdf": (typstc "watch" "examples/"+T+"/main.typ" fmt)

issue N fmt="pdf": (typstc "watch" "issues/"+N+".typ" fmt)

scrybe:
  scrybe gallery/*.typ README.md typst.toml --version=0.2.3

scrybe-publish:
  scrybe release/README.md release/typst.toml --publish --version=0.2.3

publish:
  mkdir -p release
  rm -rf release/*
  cp -r src release/
  cp README.md LICENSE typst.toml release/
  mkdir release/gallery
  cp gallery/*.png release/gallery/

