typstc cmd file fmt="pdf":
  typst {{ cmd }} --root=. {{ file }} {{ replace(file, ".typ", "." + fmt) }}

doc: (typstc "watch" "docs/main.typ")

figs force="":
  cd docs && if [ "{{force}}" = force ]; then touch figs/_preamble.typ; fi && watch make figs

test T: (typstc "watch" "tests/"+T+"/test.typ")

example T: (typstc "watch" "examples/"+T+"/main.typ")

up-to-date:
  ./publish-helper.py gallery/multi-obstacles.typ
  ./publish-helper.py gallery/two-columns.typ
  ./publish-helper.py gallery/circle-hole.typ
  ./publish-helper.py README.md

publish-up-to-date:
  ./publish-helper.py release/README.md --publish

publish:
  mkdir -p release
  rm -rf release/*
  cp -r src release/
  cp README.md LICENSE typst.toml release/
  mkdir release/gallery
  cp gallery/*.svg release/gallery/

