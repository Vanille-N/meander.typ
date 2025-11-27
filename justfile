typstc cmd file fmt="pdf":
  typst {{ cmd }} --root=. --font-path=. {{ file }} {{ replace(file, ".typ", "." + fmt) }}

doc: (typstc "watch" "docs/docs.typ")

test T: (typstc "watch" "tests/"+T+"/test.typ")

example T fmt="pdf": (typstc "watch" "examples/"+T+"/main.typ" fmt)

issue N mode="watch" fmt="pdf": (typstc mode "issues/"+N+".typ" fmt)

scrybe:
  scrybe -R README.md typst.toml docs/docs.typ --version=0.3.0

scrybe-publish:
  scrybe -R release --publish --version=0.3.0

publish:
  mkdir -p release
  rm -rf release/*
  cp -r src release/
  cp README.md LICENSE typst.toml release/
  rsync -rhP tests --include='*/' --include='gallery/*/ref/*.png' --exclude='*' release/
