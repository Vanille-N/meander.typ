typstc cmd file fmt="pdf":
  typst {{ cmd }} --root=. {{ file }} {{ replace(file, ".typ", "." + fmt) }}

doc: (typstc "watch" "docs/main.typ")

figs force="":
  cd docs && if [ "{{force}}" = force ]; then touch figs/_preamble.typ; fi && watch make figs

test T: (typstc "watch" "tests/"+T+"/test.typ")

example T: (typstc "watch" "examples/"+T+"/main.typ")

