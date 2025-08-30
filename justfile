doc:
  typst watch --root=. docs/main.typ docs/main.pdf

test T:
  typst watch --root=. tests/{{T}}/test.typ x.pdf
